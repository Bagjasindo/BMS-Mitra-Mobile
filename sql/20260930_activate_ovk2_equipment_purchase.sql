-- BMS Mobile: activate OVK2 / equipment purchase flow
-- Applied to Supabase project mqqrfhwqgcpkjeaasdsr on 2026-09-30.
-- Design: keep category='OVK' for backward compatibility; ovk_type distinguishes OVK1/OVK2.

alter table public.items add column if not exists ovk_type text;
do $$
begin
  if not exists (
    select 1 from pg_constraint
    where conrelid='public.items'::regclass and conname='items_ovk_type_check'
  ) then
    alter table public.items add constraint items_ovk_type_check
      check (ovk_type is null or ovk_type in ('OVK1','OVK2'));
  end if;
end $$;
update public.items set ovk_type='OVK1' where category='OVK' and ovk_type is null;

create table if not exists public.logistics_equipment_purchases (
  id uuid primary key default gen_random_uuid(),
  supplier_id uuid not null references public.suppliers(id),
  item_id uuid not null references public.items(id),
  barn_id uuid not null references public.barns(id),
  purchase_date date not null default current_date,
  quantity numeric not null check (quantity > 0),
  purchase_unit_price numeric not null check (purchase_unit_price >= 0),
  reference_number text,
  notes text,
  asset_id uuid unique references public.barn_assets(id) on delete set null,
  created_by uuid default auth.uid() references public.profiles(user_id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.logistics_equipment_purchases enable row level security;
grant select,insert,update,delete on public.logistics_equipment_purchases to authenticated;

drop policy if exists equipment_purchase_read on public.logistics_equipment_purchases;
create policy equipment_purchase_read on public.logistics_equipment_purchases
for select to authenticated
using ((select private.my_bms_role()) in ('ADMIN','LOGISTIK','KEUANGAN','OWNER'));

drop policy if exists equipment_purchase_write on public.logistics_equipment_purchases;
create policy equipment_purchase_write on public.logistics_equipment_purchases
for all to authenticated
using ((select private.my_bms_role()) in ('ADMIN','LOGISTIK'))
with check ((select private.my_bms_role()) in ('ADMIN','LOGISTIK'));

alter table public.supplier_payments alter column contract_assignment_id drop not null;
alter table public.supplier_payments drop constraint if exists supplier_payments_source_type_check;
alter table public.supplier_payments add constraint supplier_payments_source_type_check
check (source_type in ('SAPRONAK_LUAR','TAMBAH_DAGING','BELI_PERALATAN'));

create or replace function public.save_logistics_equipment_purchase_atomic(
  p_id uuid,p_supplier_id uuid,p_item_id uuid,p_barn_id uuid,p_purchase_date date,
  p_quantity numeric,p_purchase_unit_price numeric,p_reference_number text default null,p_notes text default null
) returns uuid
language plpgsql security definer set search_path=''
as $$
declare
  v_item record;
  v_purchase public.logistics_equipment_purchases%rowtype;
  v_id uuid;
  v_asset_id uuid;
  v_asset_notes text;
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','LOGISTIK')
  ) then raise exception 'Akses ditolak.'; end if;
  if p_purchase_date is null then raise exception 'Tanggal pembelian wajib.'; end if;
  if coalesce(p_quantity,0)<=0 then raise exception 'Jumlah harus lebih dari 0.'; end if;
  if coalesce(p_purchase_unit_price,-1)<0 then raise exception 'Harga beli tidak valid.'; end if;

  select i.id,i.code,i.name,i.category,i.ovk_type,i.unit,i.active into v_item
  from public.items i where i.id=p_item_id;
  if v_item.id is null or not v_item.active then raise exception 'Barang Master Data tidak ditemukan/aktif.'; end if;
  if v_item.category<>'OVK' or coalesce(v_item.ovk_type,'')<>'OVK2' then
    raise exception 'Beli Peralatan hanya menerima barang OVK2 dari Master Data.';
  end if;
  if not exists(select 1 from public.suppliers s where s.id=p_supplier_id and s.active) then
    raise exception 'Supplier tidak ditemukan/aktif.';
  end if;
  if not exists(select 1 from public.barns b where b.id=p_barn_id) then
    raise exception 'Kandang tidak ditemukan.';
  end if;

  if p_id is not null then
    select * into v_purchase from public.logistics_equipment_purchases where id=p_id;
    if v_purchase.id is null then raise exception 'Pembelian peralatan tidak ditemukan.'; end if;
    if exists(select 1 from public.supplier_payments sp where sp.source_type='BELI_PERALATAN' and sp.source_id=p_id) then
      raise exception 'Pembelian sudah memiliki pembayaran dan tidak boleh diubah.';
    end if;
    v_id:=p_id; v_asset_id:=v_purchase.asset_id;
    update public.logistics_equipment_purchases
    set supplier_id=p_supplier_id,item_id=p_item_id,barn_id=p_barn_id,purchase_date=p_purchase_date,
        quantity=p_quantity,purchase_unit_price=p_purchase_unit_price,
        reference_number=nullif(trim(coalesce(p_reference_number,'')),''),
        notes=nullif(trim(coalesce(p_notes,'')),''),
        updated_at=now()
    where id=v_id;
  else
    insert into public.logistics_equipment_purchases(
      supplier_id,item_id,barn_id,purchase_date,quantity,purchase_unit_price,reference_number,notes,created_by
    ) values (
      p_supplier_id,p_item_id,p_barn_id,p_purchase_date,p_quantity,p_purchase_unit_price,
      nullif(trim(coalesce(p_reference_number,'')),''),
      nullif(trim(coalesce(p_notes,'')),''),
      auth.uid()
    ) returning id into v_id;
  end if;

  v_asset_notes :=
    'Sumber: Beli Peralatan Logistik '||v_id::text||
    ' · Item: '||coalesce(v_item.code,'-')||
    ' · Jumlah: '||p_quantity::text||' '||coalesce(v_item.unit,'')||
    case when nullif(trim(coalesce(p_reference_number,'')),'') is not null then ' · Nota: '||trim(p_reference_number) else '' end||
    case when nullif(trim(coalesce(p_notes,'')),'') is not null then ' · '||trim(p_notes) else '' end;

  if v_asset_id is null then
    insert into public.barn_assets(
      barn_id,name,category,acquired_on,acquisition_value,condition,status,notes,created_by
    ) values (
      p_barn_id,v_item.name,'PERALATAN',p_purchase_date,p_quantity*p_purchase_unit_price,
      'BAIK','AKTIF',v_asset_notes,auth.uid()
    ) returning id into v_asset_id;
    update public.logistics_equipment_purchases set asset_id=v_asset_id where id=v_id;
  else
    update public.barn_assets
    set barn_id=p_barn_id,name=v_item.name,category='PERALATAN',
        acquired_on=p_purchase_date,acquisition_value=p_quantity*p_purchase_unit_price,
        notes=v_asset_notes,updated_at=now()
    where id=v_asset_id;
  end if;
  return v_id;
end $$;

revoke all on function public.save_logistics_equipment_purchase_atomic(uuid,uuid,uuid,uuid,date,numeric,numeric,text,text) from public,anon;
grant execute on function public.save_logistics_equipment_purchase_atomic(uuid,uuid,uuid,uuid,date,numeric,numeric,text,text) to authenticated;

-- finance_supplier_payables_v1, finance_save_supplier_payment_atomic, and
-- finance_correct_supplier_payment_v1 were extended in the live DB to support
-- source_type='BELI_PERALATAN' while preserving SAPRONAK_LUAR and TAMBAH_DAGING.
-- Their current canonical definitions can be pulled with pg_get_functiondef().
