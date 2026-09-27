-- Automatic Supplier Payables for Sapronak Luar and Tambah Daging
-- Applied live on 2026-09-27

create table if not exists public.supplier_payments (
  id uuid primary key default gen_random_uuid(),
  source_type text not null check (source_type in ('SAPRONAK_LUAR','TAMBAH_DAGING')),
  source_id uuid not null,
  supplier_id uuid not null references public.suppliers(id),
  contract_assignment_id uuid not null references public.logistics_contract_assignments(id),
  barn_id uuid not null references public.barns(id),
  paid_on date not null,
  amount numeric not null check (amount > 0),
  method text not null check (method in ('TUNAI','TRANSFER')),
  reference text,
  notes text,
  created_by uuid not null default auth.uid(),
  created_at timestamptz not null default now()
);

create index if not exists idx_supplier_payments_source
  on public.supplier_payments(source_type,source_id);
create index if not exists idx_supplier_payments_supplier_date
  on public.supplier_payments(supplier_id,paid_on);
create index if not exists idx_supplier_payments_assignment
  on public.supplier_payments(contract_assignment_id);

alter table public.supplier_payments enable row level security;

drop policy if exists supplier_payments_read on public.supplier_payments;
create policy supplier_payments_read on public.supplier_payments
for select to authenticated
using (
  private.my_bms_role() = any(array['ADMIN'::bms_role,'KEUANGAN'::bms_role,'OWNER'::bms_role])
);

revoke all on table public.supplier_payments from anon;
revoke insert,update,delete,truncate,references,trigger on table public.supplier_payments from authenticated;
grant select on table public.supplier_payments to authenticated;

create or replace function public.finance_supplier_payables_v1()
returns table(
  source_type text,
  source_id uuid,
  supplier_id uuid,
  supplier_code text,
  supplier_name text,
  supplier_bank_name text,
  supplier_bank_account_number text,
  supplier_bank_account_name text,
  contract_assignment_id uuid,
  barn_id uuid,
  barn_code text,
  barn_name text,
  transaction_date date,
  reference text,
  total_amount numeric,
  paid_amount numeric,
  balance numeric,
  status text
)
language plpgsql
security definer
set search_path=''
as $$
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid() and p.active
      and p.role in ('ADMIN','KEUANGAN','OWNER')
  ) then
    raise exception 'Akses ditolak.';
  end if;

  return query
  with sap as (
    select
      'SAPRONAK_LUAR'::text source_type,
      h.id source_id,
      h.supplier_id,
      h.contract_assignment_id,
      h.barn_id,
      h.shipment_date transaction_date,
      h.reference_number reference,
      coalesce(sum(i.quantity*i.purchase_unit_price),0)::numeric total_amount
    from public.logistics_external_shipments h
    join public.logistics_external_shipment_items i on i.external_shipment_id=h.id
    group by h.id,h.supplier_id,h.contract_assignment_id,h.barn_id,h.shipment_date,h.reference_number
  ),
  meat as (
    select
      'TAMBAH_DAGING'::text source_type,
      m.id source_id,
      m.supplier_id,
      m.contract_assignment_id,
      m.barn_id,
      m.purchase_date transaction_date,
      m.reference_number reference,
      (m.weight_kg*m.purchase_price_per_kg)::numeric total_amount
    from public.marketing_external_meat_purchases m
  ),
  src as (
    select * from sap
    union all
    select * from meat
  ),
  pay as (
    select p.source_type,p.source_id,coalesce(sum(p.amount),0)::numeric paid_amount
    from public.supplier_payments p
    group by p.source_type,p.source_id
  )
  select
    s.source_type,s.source_id,
    s.supplier_id,sp.code,sp.name,sp.bank_name,sp.bank_account_number,sp.bank_account_name,
    s.contract_assignment_id,s.barn_id,b.code,b.name,
    s.transaction_date,s.reference,
    s.total_amount,
    coalesce(p.paid_amount,0)::numeric,
    greatest(0,s.total_amount-coalesce(p.paid_amount,0))::numeric,
    case
      when coalesce(p.paid_amount,0)<=0 then 'BELUM_LUNAS'
      when coalesce(p.paid_amount,0)+0.0001 < s.total_amount then 'SEBAGIAN'
      else 'LUNAS'
    end::text
  from src s
  join public.suppliers sp on sp.id=s.supplier_id
  join public.barns b on b.id=s.barn_id
  left join pay p on p.source_type=s.source_type and p.source_id=s.source_id
  order by s.transaction_date desc,sp.code,s.source_type;
end
$$;

revoke execute on function public.finance_supplier_payables_v1() from public,anon;
grant execute on function public.finance_supplier_payables_v1() to authenticated;

create or replace function public.finance_save_supplier_payment_atomic(
  p_source_type text,
  p_source_id uuid,
  p_paid_on date,
  p_amount numeric,
  p_method text,
  p_reference text default null,
  p_notes text default null
)
returns uuid
language plpgsql
security definer
set search_path=''
as $$
declare
  v_row record;
  v_paid numeric;
  v_balance numeric;
  v_id uuid;
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid() and p.active
      and p.role in ('ADMIN','KEUANGAN')
  ) then
    raise exception 'Akses ditolak.';
  end if;

  if p_source_type not in ('SAPRONAK_LUAR','TAMBAH_DAGING') then
    raise exception 'Sumber hutang supplier tidak valid.';
  end if;
  if p_paid_on is null then raise exception 'Tanggal pembayaran wajib.'; end if;
  if coalesce(p_amount,0)<=0 then raise exception 'Nominal pembayaran harus lebih dari 0.'; end if;
  if p_method not in ('TUNAI','TRANSFER') then raise exception 'Metode pembayaran tidak valid.'; end if;

  if p_source_type='SAPRONAK_LUAR' then
    select h.supplier_id,h.contract_assignment_id,h.barn_id,
           coalesce(sum(i.quantity*i.purchase_unit_price),0)::numeric total_amount
    into v_row
    from public.logistics_external_shipments h
    join public.logistics_external_shipment_items i on i.external_shipment_id=h.id
    where h.id=p_source_id
    group by h.supplier_id,h.contract_assignment_id,h.barn_id;
  else
    select m.supplier_id,m.contract_assignment_id,m.barn_id,
           (m.weight_kg*m.purchase_price_per_kg)::numeric total_amount
    into v_row
    from public.marketing_external_meat_purchases m
    where m.id=p_source_id;
  end if;

  if v_row.supplier_id is null then raise exception 'Transaksi sumber tidak ditemukan.'; end if;

  perform pg_advisory_xact_lock(hashtextextended(p_source_type||':'||p_source_id::text,0));

  select coalesce(sum(p.amount),0)::numeric into v_paid
  from public.supplier_payments p
  where p.source_type=p_source_type and p.source_id=p_source_id;

  v_balance:=greatest(0,v_row.total_amount-v_paid);
  if p_amount>v_balance+0.0001 then
    raise exception 'Pembayaran melebihi sisa hutang. Sisa Rp %.',v_balance;
  end if;

  insert into public.supplier_payments(
    source_type,source_id,supplier_id,contract_assignment_id,barn_id,
    paid_on,amount,method,reference,notes,created_by
  ) values (
    p_source_type,p_source_id,v_row.supplier_id,v_row.contract_assignment_id,v_row.barn_id,
    p_paid_on,p_amount,p_method,nullif(trim(coalesce(p_reference,'')),''),
    nullif(trim(coalesce(p_notes,'')),''),auth.uid()
  )
  returning id into v_id;

  return v_id;
end
$$;

revoke execute on function public.finance_save_supplier_payment_atomic(text,uuid,date,numeric,text,text,text) from public,anon;
grant execute on function public.finance_save_supplier_payment_atomic(text,uuid,date,numeric,text,text,text) to authenticated;

create or replace function public.finance_cashflow_entries_v2()
returns table(
  txn_date date,txn_type text,source text,amount numeric,barn_id uuid,
  contract_assignment_id uuid,detail text,reference text
)
language plpgsql
security definer
set search_path=''
as $$
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid() and p.active
      and p.role in ('ADMIN','KEUANGAN','OWNER')
  ) then
    raise exception 'Akses ditolak.';
  end if;

  return query
  select v.txn_date,v.txn_type,
         case when v.source='BOP KANDANG' then 'BOP PRODUKSI' else v.source end,
         v.amount,v.barn_id,v.contract_assignment_id,v.detail,v.reference
  from public.finance_cashflow_entries_v1() v
  union all
  select m.incurred_on,'KELUAR'::text,'PERAWATAN KANDANG'::text,m.amount,m.barn_id,m.contract_assignment_id,
         replace(m.category,'_',' ')::text,coalesce(m.reference,'')
  from public.barn_maintenance_costs m
  union all
  select p.paid_on,'KELUAR'::text,'BAYAR HUTANG SUPPLIER'::text,p.amount,p.barn_id,p.contract_assignment_id,
         case when p.source_type='SAPRONAK_LUAR' then 'Sapronak Tambahan' else 'Tambah Daging' end,
         coalesce(p.reference,'')
  from public.supplier_payments p;
end
$$;

revoke execute on function public.finance_cashflow_entries_v2() from public,anon;
grant execute on function public.finance_cashflow_entries_v2() to authenticated;
