-- ADMIN cycle reopen/reclose control.
-- Reopen is scoped to one barn assignment and blocks a second active cycle in the same barn.
-- Final snapshot is removed while the cycle is open and rebuilt by the official close routine.

create or replace function public.admin_reopen_cycle_v1(p_contract_assignment_id uuid)
returns uuid
language plpgsql
security definer
set search_path=''
as $$
declare
  v public.logistics_contract_assignments%rowtype;
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid() and p.active and p.role='ADMIN'
  ) then
    raise exception 'Akses ditolak. Hanya Administrator yang dapat membuka siklus.';
  end if;

  select * into v
  from public.logistics_contract_assignments
  where id=p_contract_assignment_id
  for update;

  if v.id is null then raise exception 'Siklus tidak ditemukan.'; end if;
  if v.active then raise exception 'Siklus sudah terbuka/aktif.'; end if;

  if exists (
    select 1
    from public.logistics_contract_assignments a
    where a.barn_id=v.barn_id
      and a.active=true
      and a.id<>v.id
  ) then
    raise exception 'Kandang ini masih memiliki siklus aktif lain. Tutup siklus aktif tersebut terlebih dahulu.';
  end if;

  if coalesce(v.cycle_type,'MITRA')='MANDIRI' then
    delete from public.production_mandiri_final
    where contract_assignment_id=v.id;
  else
    delete from public.rhpp_system_final
    where contract_assignment_id=v.id;
  end if;

  perform set_config('bms.allow_production_reopen','1',true);

  update public.logistics_contract_assignments
  set active=true
  where id=v.id;

  return v.id;
end
$$;

create or replace function public.admin_reclose_cycle_v1(p_contract_assignment_id uuid)
returns uuid
language plpgsql
security definer
set search_path=''
as $$
declare
  v_type text;
  v_active boolean;
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid() and p.active and p.role='ADMIN'
  ) then
    raise exception 'Akses ditolak. Hanya Administrator yang dapat menutup siklus.';
  end if;

  select coalesce(cycle_type,'MITRA'),active
  into v_type,v_active
  from public.logistics_contract_assignments
  where id=p_contract_assignment_id;

  if v_type is null then raise exception 'Siklus tidak ditemukan.'; end if;
  if not v_active then raise exception 'Siklus sudah CLOSED.'; end if;

  if v_type='MANDIRI' then
    perform public.admin_close_mandiri_cycle_atomic(p_contract_assignment_id);
  else
    perform public.admin_close_production_atomic(p_contract_assignment_id);
  end if;

  return p_contract_assignment_id;
end
$$;

revoke all on function public.admin_reopen_cycle_v1(uuid) from public, anon;
revoke all on function public.admin_reclose_cycle_v1(uuid) from public, anon;
grant execute on function public.admin_reopen_cycle_v1(uuid) to authenticated;
grant execute on function public.admin_reclose_cycle_v1(uuid) to authenticated;
