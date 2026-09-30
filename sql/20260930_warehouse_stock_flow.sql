-- Warehouse stock flow: Finance purchase -> Logistics stock -> Logistics shipment
-- Applied to Supabase project mqqrfhwqgcpkjeaasdsr on 2026-09-30.

create table if not exists public.finance_stock_purchase_invoices (
  id uuid primary key default gen_random_uuid(),
  purchase_date date not null,
  supplier_name text,
  payment_method text not null check (payment_method in ('TUNAI','TRANSFER')),
  reference text,
  notes text,
  total_amount numeric not null default 0 check (total_amount >= 0),
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now()
);

create table if not exists public.warehouse_stock_items (
  id uuid primary key default gen_random_uuid(),
  invoice_id uuid not null references public.finance_stock_purchase_invoices(id) on delete restrict,
  standard_name text not null check (length(btrim(standard_name)) > 0),
  description text,
  quantity numeric not null check (quantity > 0),
  unit text not null check (length(btrim(unit)) > 0),
  unit_price numeric not null check (unit_price >= 0),
  total_amount numeric not null check (total_amount >= 0),
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now()
);

create table if not exists public.warehouse_stock_shipments (
  id uuid primary key default gen_random_uuid(),
  stock_item_id uuid not null references public.warehouse_stock_items(id) on delete restrict,
  shipment_date date not null,
  destination_type text not null check (destination_type in ('KANDANG','KANTOR')),
  barn_id uuid references public.barns(id) on delete restrict,
  quantity numeric not null check (quantity > 0),
  make_asset boolean not null default false,
  asset_id uuid references public.barn_assets(id) on delete restrict,
  reference text,
  notes text,
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  constraint warehouse_stock_shipments_destination_ck check (
    (destination_type='KANDANG' and barn_id is not null)
    or (destination_type='KANTOR' and barn_id is null)
  )
);

create index if not exists warehouse_stock_items_invoice_idx on public.warehouse_stock_items(invoice_id);
create index if not exists warehouse_stock_shipments_item_idx on public.warehouse_stock_shipments(stock_item_id);
create index if not exists warehouse_stock_shipments_date_idx on public.warehouse_stock_shipments(shipment_date);

alter table public.finance_stock_purchase_invoices enable row level security;
alter table public.warehouse_stock_items enable row level security;
alter table public.warehouse_stock_shipments enable row level security;

drop policy if exists finance_stock_purchase_invoices_select on public.finance_stock_purchase_invoices;
create policy finance_stock_purchase_invoices_select on public.finance_stock_purchase_invoices
for select to authenticated using (
  exists(select 1 from public.profiles p where p.user_id=(select auth.uid()) and p.active and p.role in ('ADMIN','KEUANGAN','LOGISTIK'))
);

drop policy if exists warehouse_stock_items_select on public.warehouse_stock_items;
create policy warehouse_stock_items_select on public.warehouse_stock_items
for select to authenticated using (
  exists(select 1 from public.profiles p where p.user_id=(select auth.uid()) and p.active and p.role in ('ADMIN','KEUANGAN','LOGISTIK'))
);

drop policy if exists warehouse_stock_shipments_select on public.warehouse_stock_shipments;
create policy warehouse_stock_shipments_select on public.warehouse_stock_shipments
for select to authenticated using (
  exists(select 1 from public.profiles p where p.user_id=(select auth.uid()) and p.active and p.role in ('ADMIN','KEUANGAN','LOGISTIK'))
);

grant select on public.finance_stock_purchase_invoices, public.warehouse_stock_items, public.warehouse_stock_shipments to authenticated;
revoke all on public.finance_stock_purchase_invoices, public.warehouse_stock_items, public.warehouse_stock_shipments from anon;

create or replace function public.finance_save_stock_invoice_atomic(
  p_purchase_date date,p_supplier_name text,p_payment_method text,p_reference text,p_notes text,p_items jsonb
) returns uuid language plpgsql security definer set search_path='' as $$
declare v_invoice_id uuid; v_item jsonb; v_name text; v_unit text; v_qty numeric; v_price numeric; v_total numeric:=0;
begin
  if not exists(select 1 from public.profiles p where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','KEUANGAN')) then raise exception 'Akses ditolak.'; end if;
  if p_purchase_date is null then raise exception 'Tanggal pembelian wajib.'; end if;
  if p_payment_method not in ('TUNAI','TRANSFER') then raise exception 'Metode pembayaran tidak valid.'; end if;
  if p_items is null or jsonb_typeof(p_items)<>'array' or jsonb_array_length(p_items)=0 then raise exception 'Minimal satu barang stok wajib diisi.'; end if;
  for v_item in select value from jsonb_array_elements(p_items) loop
    v_name:=nullif(trim(coalesce(v_item->>'standard_name','')),''); v_unit:=upper(nullif(trim(coalesce(v_item->>'unit','')),''));
    begin v_qty:=(v_item->>'quantity')::numeric; v_price:=(v_item->>'unit_price')::numeric; exception when others then raise exception 'Jumlah atau harga barang stok tidak valid.'; end;
    if v_name is null or v_unit is null or coalesce(v_qty,0)<=0 or coalesce(v_price,-1)<0 then raise exception 'Data barang stok tidak valid.'; end if;
    v_total:=v_total+(v_qty*v_price);
  end loop;
  insert into public.finance_stock_purchase_invoices(purchase_date,supplier_name,payment_method,reference,notes,total_amount,created_by)
  values(p_purchase_date,nullif(trim(coalesce(p_supplier_name,'')),''),p_payment_method,nullif(trim(coalesce(p_reference,'')),''),nullif(trim(coalesce(p_notes,'')),''),v_total,auth.uid())
  returning id into v_invoice_id;
  for v_item in select value from jsonb_array_elements(p_items) loop
    v_name:=trim(v_item->>'standard_name'); v_unit:=upper(trim(v_item->>'unit')); v_qty:=(v_item->>'quantity')::numeric; v_price:=(v_item->>'unit_price')::numeric;
    insert into public.warehouse_stock_items(invoice_id,standard_name,description,quantity,unit,unit_price,total_amount,created_by)
    values(v_invoice_id,v_name,nullif(trim(coalesce(v_item->>'description','')),''),v_qty,v_unit,v_price,v_qty*v_price,auth.uid());
  end loop;
  return v_invoice_id;
end $$;
revoke all on function public.finance_save_stock_invoice_atomic(date,text,text,text,text,jsonb) from public,anon;
grant execute on function public.finance_save_stock_invoice_atomic(date,text,text,text,text,jsonb) to authenticated;

create or replace function public.logistics_send_warehouse_stock_atomic(
  p_stock_item_id uuid,p_shipment_date date,p_destination_type text,p_barn_id uuid,p_quantity numeric,
  p_make_asset boolean default false,p_reference text default null,p_notes text default null
) returns uuid language plpgsql security definer set search_path='' as $$
declare v_item public.warehouse_stock_items%rowtype; v_sent numeric; v_remaining numeric; v_destination text; v_shipment_id uuid; v_asset_id uuid;
begin
  if not exists(select 1 from public.profiles p where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','LOGISTIK')) then raise exception 'Akses ditolak.'; end if;
  if p_shipment_date is null or coalesce(p_quantity,0)<=0 then raise exception 'Tanggal dan jumlah kirim wajib.'; end if;
  v_destination:=upper(trim(coalesce(p_destination_type,'')));
  if v_destination not in ('KANDANG','KANTOR') then raise exception 'Tujuan tidak valid.'; end if;
  if v_destination='KANDANG' then
    if p_barn_id is null or not exists(select 1 from public.barns b where b.id=p_barn_id) then raise exception 'Pilih kandang tujuan.'; end if;
  else p_barn_id:=null; end if;
  select * into v_item from public.warehouse_stock_items where id=p_stock_item_id for update;
  if v_item.id is null then raise exception 'Barang stok tidak ditemukan.'; end if;
  select coalesce(sum(s.quantity),0) into v_sent from public.warehouse_stock_shipments s where s.stock_item_id=v_item.id;
  v_remaining:=v_item.quantity-v_sent;
  if p_quantity>v_remaining then raise exception 'Stok tidak cukup. Sisa % %.',v_remaining,v_item.unit; end if;
  if coalesce(p_make_asset,false) then
    insert into public.barn_assets(barn_id,location_type,name,category,quantity,unit,acquired_on,acquisition_value,condition,status,notes,created_by)
    values(p_barn_id,v_destination,v_item.standard_name,'PERALATAN',p_quantity,v_item.unit,p_shipment_date,p_quantity*v_item.unit_price,'BAIK','AKTIF',
      'Sumber: Kirim Stok Gudang · Nota '||v_item.invoice_id::text||' · Item '||v_item.id::text||
      case when nullif(trim(coalesce(p_reference,'')),'') is not null then ' · Ref: '||trim(p_reference) else '' end||
      case when nullif(trim(coalesce(p_notes,'')),'') is not null then ' · '||trim(p_notes) else '' end,auth.uid())
    returning id into v_asset_id;
  end if;
  insert into public.warehouse_stock_shipments(stock_item_id,shipment_date,destination_type,barn_id,quantity,make_asset,asset_id,reference,notes,created_by)
  values(v_item.id,p_shipment_date,v_destination,p_barn_id,p_quantity,coalesce(p_make_asset,false),v_asset_id,nullif(trim(coalesce(p_reference,'')),''),nullif(trim(coalesce(p_notes,'')),''),auth.uid())
  returning id into v_shipment_id;
  return v_shipment_id;
end $$;
revoke all on function public.logistics_send_warehouse_stock_atomic(uuid,date,text,uuid,numeric,boolean,text,text) from public,anon;
grant execute on function public.logistics_send_warehouse_stock_atomic(uuid,date,text,uuid,numeric,boolean,text,text) to authenticated;

create or replace function public.finance_cashflow_entries_v4()
returns table(txn_date date,txn_type text,source text,amount numeric,barn_id uuid,contract_assignment_id uuid,detail text,reference text)
language plpgsql security definer set search_path='' as $$
begin
  if not exists(select 1 from public.profiles p where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','KEUANGAN','OWNER')) then raise exception 'Akses ditolak.'; end if;
  return query
  select v.txn_date,v.txn_type,v.source,v.amount,v.barn_id,v.contract_assignment_id,v.detail,v.reference from public.finance_cashflow_entries_v3() v
  union all
  select h.purchase_date,'KELUAR'::text,'BELI UNTUK STOK'::text,h.total_amount,null::uuid,null::uuid,coalesce(h.supplier_name,'Pembelian Stok Gudang'),coalesce(h.reference,'')
  from public.finance_stock_purchase_invoices h;
end $$;
revoke all on function public.finance_cashflow_entries_v4() from public,anon;
grant execute on function public.finance_cashflow_entries_v4() to authenticated;
