-- Allow ADMIN to correct only initial_birds on CLOSED cycle ABK links.
-- All other CLOSED-cycle writes remain locked.

create or replace function private.reject_closed_assignment_write()
returns trigger
language plpgsql
security definer
set search_path=''
as $$
declare
  v_old uuid;
  v_new uuid;
  v_allow_population_correction boolean :=
    coalesce(current_setting('bms.allow_closed_abk_population_correction', true),'')='1';
begin
  if tg_op in ('UPDATE','DELETE') then
    v_old := nullif(to_jsonb(old)->>'contract_assignment_id','')::uuid;
  end if;
  if tg_op in ('UPDATE','INSERT') then
    v_new := nullif(to_jsonb(new)->>'contract_assignment_id','')::uuid;
  end if;

  if exists(
    select 1 from public.logistics_contract_assignments a
    where a.id in (v_old,v_new) and a.active=false
  ) then
    if tg_op='UPDATE'
       and v_allow_population_correction
       and exists(
         select 1 from public.profiles p
         where p.user_id=auth.uid() and p.active and p.role='ADMIN'
       )
       and new.initial_birds is distinct from old.initial_birds
       and new.id is not distinct from old.id
       and new.contract_assignment_id is not distinct from old.contract_assignment_id
       and new.abk_id is not distinct from old.abk_id
       and new.created_at is not distinct from old.created_at
       and new.feed_pre_bags is not distinct from old.feed_pre_bags
       and new.feed_starter_bags is not distinct from old.feed_starter_bags
       and new.feed_finisher_bags is not distinct from old.feed_finisher_bags
       and new.basics_locked_at is not distinct from old.basics_locked_at
    then
      return new;
    end if;
    raise exception 'Periode sudah Close. Buka kembali siklus melalui Administrator sebelum mengubah data.';
  end if;

  if tg_op='DELETE' then return old; else return new; end if;
end
$$;

create or replace function public.admin_correct_closed_abk_population_v1(
  p_link_id uuid,
  p_initial_birds integer
)
returns void
language plpgsql
security definer
set search_path=''
as $$
declare
  v_assignment_id uuid;
begin
  if not exists(
    select 1 from public.profiles p
    where p.user_id=auth.uid() and p.active and p.role='ADMIN'
  ) then
    raise exception 'Akses ditolak. Hanya Administrator.';
  end if;

  if p_initial_birds is null or p_initial_birds <= 0 then
    raise exception 'Populasi awal harus lebih dari 0.';
  end if;

  select l.contract_assignment_id into v_assignment_id
  from public.logistics_contract_assignment_abks l
  where l.id=p_link_id;

  if v_assignment_id is null then
    raise exception 'Data ABK tidak ditemukan.';
  end if;

  if not exists(
    select 1 from public.logistics_contract_assignments a
    where a.id=v_assignment_id and a.active=false
  ) then
    raise exception 'Koreksi khusus ini hanya untuk siklus CLOSED.';
  end if;

  perform set_config('bms.allow_closed_abk_population_correction','1',true);

  update public.logistics_contract_assignment_abks
  set initial_birds=p_initial_birds
  where id=p_link_id;
end
$$;

revoke all on function public.admin_correct_closed_abk_population_v1(uuid,integer) from public, anon;
grant execute on function public.admin_correct_closed_abk_population_v1(uuid,integer) to authenticated;
