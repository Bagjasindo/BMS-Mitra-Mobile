-- Chick-In is the source of ABK allocation for Liga ABK.
-- Saves Chick-In and ABK initial population atomically.
-- Total ABK initial population must equal net DOC population.

create or replace function public.save_chick_in_with_abks_v1(
  p_chick_id uuid,
  p_assignment_id uuid,
  p_arrived_on date,
  p_received integer,
  p_doa integer,
  p_avg_weight numeric,
  p_delivery_number text,
  p_abks jsonb
)
returns uuid
language plpgsql
security definer
set search_path=''
as $$
declare
  v_role public.bms_role;
  v_assignment public.logistics_contract_assignments%rowtype;
  v_chick_id uuid;
  v_net integer;
  v_sum integer;
  v_count integer;
  v_unique_count integer;
  v_abk jsonb;
  v_abk_id uuid;
  v_initial integer;
begin
  select p.role into v_role
  from public.profiles p
  where p.user_id=auth.uid() and p.active=true;

  if v_role not in ('ADMIN','PPL') then
    raise exception 'Akses ditolak. Hanya ADMIN/PPL.';
  end if;

  select * into v_assignment
  from public.logistics_contract_assignments a
  where a.id=p_assignment_id
  for update;

  if v_assignment.id is null then raise exception 'Siklus tidak ditemukan.'; end if;
  if not v_assignment.active then raise exception 'Siklus CLOSED. Buka kembali melalui Administrator sebelum koreksi.'; end if;
  if v_role='PPL' and v_assignment.ppl_id is distinct from auth.uid() then
    raise exception 'PPL hanya dapat mengisi kandang yang menjadi tanggung jawabnya.';
  end if;

  if p_received is null or p_received<=0 then raise exception 'DOC In harus lebih dari 0.'; end if;
  if p_doa is null or p_doa<0 or p_doa>=p_received then raise exception 'DOC Mati Box tidak valid.'; end if;
  if p_avg_weight is not null and p_avg_weight<=0 then raise exception 'Bobot rata-rata DOC harus lebih dari 0.'; end if;
  if p_arrived_on<v_assignment.start_date then raise exception 'Tanggal Chick-In tidak boleh sebelum tanggal mulai siklus.'; end if;

  if p_abks is null or jsonb_typeof(p_abks)<>'array' or jsonb_array_length(p_abks)=0 then
    raise exception 'Pilih minimal 1 ABK dan isi Populasi Awal.';
  end if;

  v_net:=p_received-p_doa;

  select count(*),count(distinct nullif(x->>'abk_id','')),coalesce(sum((x->>'initial_birds')::integer),0)
  into v_count,v_unique_count,v_sum
  from jsonb_array_elements(p_abks) x;

  if v_count<>v_unique_count then raise exception 'ABK tidak boleh dipilih dua kali.'; end if;

  if exists (
    select 1 from jsonb_array_elements(p_abks) x
    where nullif(x->>'abk_id','') is null
       or coalesce((x->>'initial_birds')::integer,0)<=0
  ) then
    raise exception 'Semua ABK dan Populasi Awal wajib diisi.';
  end if;

  if v_sum<>v_net then
    raise exception 'Total Populasi Awal ABK (%) harus sama dengan Populasi Awal Bersih (%)',v_sum,v_net;
  end if;

  if exists (
    select 1
    from jsonb_array_elements(p_abks) x
    left join public.employees e on e.id=(x->>'abk_id')::uuid
    where e.id is null or e.kind<>'ABK' or e.active<>true
  ) then
    raise exception 'ABK tidak ditemukan atau sudah tidak aktif.';
  end if;

  if p_chick_id is not null then
    select c.id into v_chick_id
    from public.chick_ins c
    where c.id=p_chick_id and c.contract_assignment_id=p_assignment_id
    for update;
    if v_chick_id is null then raise exception 'Data Chick-In tidak ditemukan pada siklus ini.'; end if;
  elsif exists (select 1 from public.chick_ins c where c.contract_assignment_id=p_assignment_id) then
    raise exception 'Siklus ini sudah memiliki Chick-In. Gunakan Edit.';
  end if;

  if exists (
    select 1
    from public.logistics_contract_assignment_abks l
    where l.contract_assignment_id=p_assignment_id
      and not exists (
        select 1 from jsonb_array_elements(p_abks) x
        where (x->>'abk_id')::uuid=l.abk_id
      )
      and (
        l.basics_locked_at is not null
        or exists (
          select 1 from public.production_abk_results r
          where r.contract_assignment_id=p_assignment_id and r.abk_id=l.abk_id
        )
      )
  ) then
    raise exception 'ABK yang sudah memiliki data Liga/Pakan tidak dapat dilepas. Koreksi ABK tersebut, jangan hapus.';
  end if;

  if v_chick_id is null then
    insert into public.chick_ins(
      contract_assignment_id,barn_id,arrived_on,received,shipped,doa,strain,avg_weight,delivery_number
    ) values (
      p_assignment_id,v_assignment.barn_id,p_arrived_on,p_received,p_received,p_doa,null,p_avg_weight,nullif(trim(coalesce(p_delivery_number,'')),'')
    )
    returning id into v_chick_id;
  else
    update public.chick_ins
    set arrived_on=p_arrived_on,
        barn_id=v_assignment.barn_id,
        received=p_received,
        shipped=p_received,
        doa=p_doa,
        strain=null,
        avg_weight=p_avg_weight,
        delivery_number=nullif(trim(coalesce(p_delivery_number,'')),'')
    where id=v_chick_id;
  end if;

  delete from public.logistics_contract_assignment_abks l
  where l.contract_assignment_id=p_assignment_id
    and l.basics_locked_at is null
    and not exists (
      select 1 from public.production_abk_results r
      where r.contract_assignment_id=p_assignment_id and r.abk_id=l.abk_id
    )
    and not exists (
      select 1 from jsonb_array_elements(p_abks) x
      where (x->>'abk_id')::uuid=l.abk_id
    );

  for v_abk in select * from jsonb_array_elements(p_abks)
  loop
    v_abk_id:=(v_abk->>'abk_id')::uuid;
    v_initial:=(v_abk->>'initial_birds')::integer;

    insert into public.logistics_contract_assignment_abks(contract_assignment_id,abk_id,initial_birds)
    values (p_assignment_id,v_abk_id,v_initial)
    on conflict (contract_assignment_id,abk_id)
    do update set initial_birds=excluded.initial_birds;
  end loop;

  return v_chick_id;
end
$$;

revoke all on function public.save_chick_in_with_abks_v1(uuid,uuid,date,integer,integer,numeric,text,jsonb) from public,anon;
grant execute on function public.save_chick_in_with_abks_v1(uuid,uuid,date,integer,integer,numeric,text,jsonb) to authenticated;
