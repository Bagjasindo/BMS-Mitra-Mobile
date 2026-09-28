-- Secure correction RPCs for finance transactions and audited ADMIN delete.
-- Roles: ADMIN + KEUANGAN may correct finance transactions.
-- Delete remains ADMIN only through admin_delete_transaction_v1.

create or replace function public.finance_correct_employee_advance_v1(
  p_id uuid,
  p_employee_id uuid,
  p_advanced_on date,
  p_amount numeric,
  p_description text default null
)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
declare
  v_paid numeric;
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','KEUANGAN')
  ) then raise exception 'Akses ditolak.'; end if;

  if coalesce(p_amount,0)<=0 then raise exception 'Nominal kasbon harus lebih dari 0.'; end if;
  if p_advanced_on is null then raise exception 'Tanggal kasbon wajib.'; end if;
  if not exists(select 1 from public.employees e where e.id=p_employee_id and e.active) then
    raise exception 'Karyawan / ABK tidak valid.';
  end if;

  select coalesce(sum(ap.amount),0) into v_paid
  from public.advance_payments ap where ap.advance_id=p_id;

  if p_amount < v_paid then
    raise exception 'Nominal kasbon tidak boleh lebih kecil dari total yang sudah dibayar Rp %.', v_paid;
  end if;

  update public.advances
  set employee_id=p_employee_id,
      advanced_on=p_advanced_on,
      amount=p_amount,
      description=nullif(trim(coalesce(p_description,'')),''),
      contract_assignment_id=null,
      barn_id=null
  where id=p_id;

  if not found then raise exception 'Kasbon tidak ditemukan.'; end if;
  return true;
end $$;

create or replace function public.finance_correct_advance_payment_v1(
  p_id uuid,
  p_advance_id uuid,
  p_paid_on date,
  p_amount numeric,
  p_method text,
  p_notes text default null
)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
declare
  v_advance numeric;
  v_other numeric;
  v_old_method text;
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','KEUANGAN')
  ) then raise exception 'Akses ditolak.'; end if;

  select method into v_old_method from public.advance_payments where id=p_id;
  if v_old_method is null then raise exception 'Pembayaran kasbon tidak ditemukan.'; end if;
  if v_old_method='POTONG_GAJI' then
    raise exception 'Pembayaran dari potongan gaji harus dikoreksi dari transaksi Gaji ABK.';
  end if;
  if p_method not in ('TUNAI','TRANSFER') then raise exception 'Metode pembayaran tidak valid.'; end if;
  if coalesce(p_amount,0)<=0 then raise exception 'Nominal pembayaran harus lebih dari 0.'; end if;

  select a.amount into v_advance from public.advances a where a.id=p_advance_id;
  if v_advance is null then raise exception 'Kasbon tujuan tidak ditemukan.'; end if;

  select coalesce(sum(ap.amount),0) into v_other
  from public.advance_payments ap
  where ap.advance_id=p_advance_id and ap.id<>p_id;

  if p_amount > greatest(0,v_advance-v_other)+0.0001 then
    raise exception 'Nominal melebihi sisa kasbon Rp %.', greatest(0,v_advance-v_other);
  end if;

  update public.advance_payments
  set advance_id=p_advance_id,paid_on=p_paid_on,amount=p_amount,method=p_method,
      notes=nullif(trim(coalesce(p_notes,'')),'')
  where id=p_id;
  return true;
end $$;

create or replace function public.finance_correct_mandiri_receipt_v1(
  p_id uuid,
  p_received_on date,
  p_amount numeric,
  p_method text,
  p_reference text default null,
  p_notes text default null
)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
declare
  v_harvest uuid;
  v_total numeric;
  v_other numeric;
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','KEUANGAN')
  ) then raise exception 'Akses ditolak.'; end if;
  if p_method not in ('TRANSFER','TUNAI','LAINNYA') then raise exception 'Metode tidak valid.'; end if;
  if coalesce(p_amount,0)<=0 then raise exception 'Nominal harus lebih dari 0.'; end if;

  select r.harvest_id into v_harvest from public.finance_mandiri_sales_receipts r where r.id=p_id;
  if v_harvest is null then raise exception 'Penerimaan Mandiri tidak ditemukan.'; end if;

  select h.total_amount into v_total from public.marketing_contract_harvests h where h.id=v_harvest;
  select coalesce(sum(r.amount),0) into v_other
  from public.finance_mandiri_sales_receipts r
  where r.harvest_id=v_harvest and r.id<>p_id;

  if p_amount > greatest(0,v_total-v_other)+0.0001 then
    raise exception 'Nominal melebihi sisa piutang Rp %.', greatest(0,v_total-v_other);
  end if;

  update public.finance_mandiri_sales_receipts
  set received_on=p_received_on,amount=p_amount,method=p_method,
      reference=nullif(trim(coalesce(p_reference,'')),''),
      notes=nullif(trim(coalesce(p_notes,'')),'')
  where id=p_id;
  return true;
end $$;

create or replace function public.finance_correct_mandiri_supplier_payment_v1(
  p_id uuid,
  p_paid_on date,
  p_amount numeric,
  p_method text,
  p_reference text default null,
  p_notes text default null
)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
declare
  v_purchase uuid;
  v_total numeric;
  v_other numeric;
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','KEUANGAN')
  ) then raise exception 'Akses ditolak.'; end if;
  if p_method not in ('TRANSFER','TUNAI','LAINNYA') then raise exception 'Metode tidak valid.'; end if;
  if coalesce(p_amount,0)<=0 then raise exception 'Nominal harus lebih dari 0.'; end if;

  select p.purchase_id into v_purchase from public.finance_mandiri_supplier_payments p where p.id=p_id;
  if v_purchase is null then raise exception 'Pembayaran supplier Mandiri tidak ditemukan.'; end if;

  select m.quantity*m.purchase_unit_price into v_total
  from public.logistics_mandiri_purchases m where m.id=v_purchase;

  select coalesce(sum(p.amount),0) into v_other
  from public.finance_mandiri_supplier_payments p
  where p.purchase_id=v_purchase and p.id<>p_id;

  if p_amount > greatest(0,v_total-v_other)+0.0001 then
    raise exception 'Nominal melebihi sisa hutang Rp %.', greatest(0,v_total-v_other);
  end if;

  update public.finance_mandiri_supplier_payments
  set paid_on=p_paid_on,amount=p_amount,method=p_method,
      reference=nullif(trim(coalesce(p_reference,'')),''),
      notes=nullif(trim(coalesce(p_notes,'')),'')
  where id=p_id;
  return true;
end $$;

create or replace function public.finance_correct_supplier_payment_v1(
  p_id uuid,
  p_paid_on date,
  p_amount numeric,
  p_method text,
  p_reference text default null,
  p_notes text default null
)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
declare
  v_source_type text;
  v_source_id uuid;
  v_total numeric;
  v_other numeric;
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','KEUANGAN')
  ) then raise exception 'Akses ditolak.'; end if;
  if p_method not in ('TRANSFER','TUNAI') then raise exception 'Metode tidak valid.'; end if;
  if coalesce(p_amount,0)<=0 then raise exception 'Nominal harus lebih dari 0.'; end if;

  select p.source_type,p.source_id into v_source_type,v_source_id
  from public.supplier_payments p where p.id=p_id;
  if v_source_id is null then raise exception 'Pembayaran supplier tidak ditemukan.'; end if;

  if v_source_type='SAPRONAK_LUAR' then
    select coalesce(sum(i.quantity*i.purchase_unit_price),0)::numeric into v_total
    from public.logistics_external_shipment_items i
    where i.external_shipment_id=v_source_id;
  elsif v_source_type='TAMBAH_DAGING' then
    select (m.weight_kg*m.purchase_price_per_kg)::numeric into v_total
    from public.marketing_external_meat_purchases m where m.id=v_source_id;
  else
    raise exception 'Sumber pembayaran tidak valid.';
  end if;

  select coalesce(sum(p.amount),0) into v_other
  from public.supplier_payments p
  where p.source_type=v_source_type and p.source_id=v_source_id and p.id<>p_id;

  if p_amount > greatest(0,v_total-v_other)+0.0001 then
    raise exception 'Nominal melebihi sisa hutang Rp %.', greatest(0,v_total-v_other);
  end if;

  update public.supplier_payments
  set paid_on=p_paid_on,amount=p_amount,method=p_method,
      reference=nullif(trim(coalesce(p_reference,'')),''),
      notes=nullif(trim(coalesce(p_notes,'')),'')
  where id=p_id;
  return true;
end $$;

create or replace function public.finance_correct_rhpp_real_v1(
  p_id uuid,
  p_received_on date,
  p_amount numeric,
  p_reference text default null,
  p_notes text default null
)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','KEUANGAN')
  ) then raise exception 'Akses ditolak.'; end if;
  if coalesce(p_amount,0)<0 then raise exception 'Nominal RHPP Real tidak valid.'; end if;
  if p_received_on is null then raise exception 'Tanggal RHPP Real wajib.'; end if;

  update public.rhpp_real
  set received_on=p_received_on,amount=p_amount,
      reference=nullif(trim(coalesce(p_reference,'')),''),
      notes=nullif(trim(coalesce(p_notes,'')),'')
  where id=p_id;
  if not found then raise exception 'RHPP Real tidak ditemukan.'; end if;
  return true;
end $$;

revoke all on function public.finance_correct_employee_advance_v1(uuid,uuid,date,numeric,text) from public,anon;
revoke all on function public.finance_correct_advance_payment_v1(uuid,uuid,date,numeric,text,text) from public,anon;
revoke all on function public.finance_correct_mandiri_receipt_v1(uuid,date,numeric,text,text,text) from public,anon;
revoke all on function public.finance_correct_mandiri_supplier_payment_v1(uuid,date,numeric,text,text,text) from public,anon;
revoke all on function public.finance_correct_supplier_payment_v1(uuid,date,numeric,text,text,text) from public,anon;
revoke all on function public.finance_correct_rhpp_real_v1(uuid,date,numeric,text,text) from public,anon;

grant execute on function public.finance_correct_employee_advance_v1(uuid,uuid,date,numeric,text) to authenticated;
grant execute on function public.finance_correct_advance_payment_v1(uuid,uuid,date,numeric,text,text) to authenticated;
grant execute on function public.finance_correct_mandiri_receipt_v1(uuid,date,numeric,text,text,text) to authenticated;
grant execute on function public.finance_correct_mandiri_supplier_payment_v1(uuid,date,numeric,text,text,text) to authenticated;
grant execute on function public.finance_correct_supplier_payment_v1(uuid,date,numeric,text,text,text) to authenticated;
grant execute on function public.finance_correct_rhpp_real_v1(uuid,date,numeric,text,text) to authenticated;

create or replace function public.admin_delete_transaction_v1(
  p_table text,
  p_id text
)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
declare
  v_allowed boolean := false;
  v_deleted integer := 0;
  v_old jsonb;
begin
  if auth.uid() is null then raise exception 'Sesi login tidak ditemukan.'; end if;
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid() and p.active=true and p.role='ADMIN'
  ) then raise exception 'Hanya ADMIN yang boleh menghapus transaksi.'; end if;

  v_allowed := p_table = any(array[
    'logistics_shipments','logistics_external_shipments','logistics_returns',
    'logistics_external_returns','logistics_mandiri_purchases',
    'marketing_contract_harvests','marketing_external_meat_purchases',
    'chick_ins','recordings','visits','production_estimates',
    'bop','barn_maintenance_costs','bop_outside',
    'finance_expedition_trips','finance_expedition_invoices','finance_expedition_payments',
    'finance_expedition_bop','finance_expedition_maintenance',
    'advances','advance_payments','supplier_payments',
    'finance_mandiri_sales_receipts','finance_mandiri_supplier_payments',
    'rhpp_real','abk_cycle_salaries'
  ]);
  if not v_allowed then raise exception 'Tabel % tidak diizinkan untuk hapus transaksi.',p_table; end if;

  execute format('select to_jsonb(t) from public.%I t where id::text=$1',p_table)
    into v_old using p_id;
  if v_old is null then raise exception 'Transaksi tidak ditemukan atau sudah terhapus.'; end if;

  begin
    execute format('delete from public.%I where id::text=$1',p_table) using p_id;
    get diagnostics v_deleted = row_count;
  exception
    when foreign_key_violation then
      raise exception 'Transaksi tidak dapat dihapus karena masih dipakai data lain. Koreksi atau hapus transaksi turunannya terlebih dahulu.';
  end;

  if v_deleted=0 then raise exception 'Transaksi tidak ditemukan atau sudah terhapus.'; end if;

  insert into public.audit_events(actor,action,table_name,record_id,old_data,new_data)
  values(auth.uid(),'DELETE_ADMIN',p_table,p_id,v_old,null);

  return true;
end $$;

revoke all on function public.admin_delete_transaction_v1(text,text) from public,anon;
grant execute on function public.admin_delete_transaction_v1(text,text) to authenticated;
