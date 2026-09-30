-- Allow ADMIN/PPL to correct ABK feed allocation while assignment is active.
-- Once the cycle is CLOSED, changes are rejected.

create or replace function public.lock_production_abk_basics_atomic(
  p_link_id uuid,
  p_initial_birds integer,
  p_feed_pre_bags numeric,
  p_feed_starter_bags numeric,
  p_feed_finisher_bags numeric
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $function$
declare
  v_assignment_id uuid;
  v_initial integer;
  v_role public.bms_role;
  v_active boolean;
begin
  select p.role into v_role
  from public.profiles p
  where p.user_id=auth.uid() and p.active=true;

  select l.contract_assignment_id,l.initial_birds
    into v_assignment_id,v_initial
  from public.logistics_contract_assignment_abks l
  where l.id=p_link_id
  for update;

  if v_assignment_id is null then
    raise exception 'Data ABK pada kontrak tidak ditemukan.';
  end if;

  select a.active into v_active
  from public.logistics_contract_assignments a
  where a.id=v_assignment_id;

  if coalesce(v_active,false)=false then
    raise exception 'Siklus sudah CLOSED. Data Pakan ABK tidak dapat diubah.';
  end if;

  if v_role='ADMIN' then
    null;
  elsif v_role='PPL' then
    if not exists (
      select 1 from public.logistics_contract_assignments a
      where a.id=v_assignment_id
        and a.active=true
        and a.ppl_id=auth.uid()
    ) then
      raise exception 'PPL hanya dapat mengubah ABK pada kandang aktif yang menjadi tanggung jawabnya.';
    end if;
  else
    raise exception 'Akses ditolak.';
  end if;

  if coalesce(p_feed_pre_bags,0)<0
     or coalesce(p_feed_starter_bags,0)<0
     or coalesce(p_feed_finisher_bags,0)<0 then
    raise exception 'Jumlah zak pakan tidak boleh minus.';
  end if;

  if coalesce(p_feed_pre_bags,0)+coalesce(p_feed_starter_bags,0)+coalesce(p_feed_finisher_bags,0)<=0 then
    raise exception 'Total Penempatan Pakan wajib diisi.';
  end if;

  if coalesce(v_initial,0)<=0 then
    raise exception 'Populasi Awal ABK belum tersedia.';
  end if;

  update public.logistics_contract_assignment_abks
     set feed_pre_bags=coalesce(p_feed_pre_bags,0),
         feed_starter_bags=coalesce(p_feed_starter_bags,0),
         feed_finisher_bags=coalesce(p_feed_finisher_bags,0),
         basics_locked_at=coalesce(basics_locked_at,now())
   where id=p_link_id;

  return p_link_id;
end;
$function$;
