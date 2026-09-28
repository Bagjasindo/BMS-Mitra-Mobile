-- Kasbon pribadi karyawan/ABK: tidak terkait kandang, siklus, RHPP, atau produksi.
create or replace function public.finance_save_employee_advance_atomic(
  p_employee_id uuid,
  p_advanced_on date,
  p_amount numeric,
  p_contract_assignment_id uuid default null,
  p_description text default null,
  p_reference text default null
)
returns uuid
language plpgsql
security definer
set search_path to ''
as $function$
declare
  v_kind text;
  v_id uuid;
begin
  if not exists (
    select 1
    from public.profiles p
    where p.user_id=auth.uid()
      and p.active
      and p.role in ('ADMIN','KEUANGAN')
  ) then
    raise exception 'Akses ditolak.';
  end if;

  if p_amount is null or p_amount<=0 then
    raise exception 'Nominal kasbon harus lebih dari 0.';
  end if;

  if p_advanced_on is null then
    raise exception 'Tanggal kasbon wajib diisi.';
  end if;

  select e.kind into v_kind
  from public.employees e
  where e.id=p_employee_id
    and e.active=true;

  if v_kind is null then
    raise exception 'Karyawan tidak ditemukan atau tidak aktif.';
  end if;

  insert into public.advances(
    employee_id,advanced_on,amount,description,reference,
    contract_assignment_id,barn_id
  ) values (
    p_employee_id,p_advanced_on,p_amount,
    nullif(trim(p_description),''),
    nullif(trim(p_reference),''),
    null,null
  )
  returning id into v_id;

  return v_id;
end
$function$;
