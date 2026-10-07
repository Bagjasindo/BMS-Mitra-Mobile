-- Safe transaction correction RPCs, synchronized from live database on 2026-10-07.

CREATE OR REPLACE FUNCTION public.correct_warehouse_stock_shipment_atomic(p_id uuid, p_shipment_date date, p_destination_type text, p_barn_id uuid, p_quantity numeric, p_reference text DEFAULT NULL::text, p_notes text DEFAULT NULL::text)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  v_s public.warehouse_stock_shipments%rowtype;
  v_i public.warehouse_stock_items%rowtype;
  v_used numeric;
  v_dest text;
begin
  if not exists(select 1 from public.profiles p where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','LOGISTIK')) then raise exception 'Akses ditolak.'; end if;
  select * into v_s from public.warehouse_stock_shipments where id=p_id for update;
  if v_s.id is null then raise exception 'Pengiriman gudang tidak ditemukan.'; end if;
  select * into v_i from public.warehouse_stock_items where id=v_s.stock_item_id for update;
  if v_i.id is null then raise exception 'Barang stok tidak ditemukan.'; end if;
  if p_shipment_date is null then raise exception 'Tanggal kirim wajib.'; end if;
  if coalesce(p_quantity,0)<=0 then raise exception 'Jumlah kirim harus lebih dari 0.'; end if;
  v_dest:=upper(trim(coalesce(p_destination_type,'')));
  if v_dest not in ('KANDANG','KANTOR') then raise exception 'Tujuan tidak valid.'; end if;
  if v_dest='KANDANG' and (p_barn_id is null or not exists(select 1 from public.barns b where b.id=p_barn_id)) then raise exception 'Pilih kandang tujuan.'; end if;
  if v_dest='KANTOR' then p_barn_id:=null; end if;
  select coalesce(sum(s.quantity),0) into v_used from public.warehouse_stock_shipments s where s.stock_item_id=v_i.id and s.id<>p_id;
  if p_quantity>v_i.quantity-v_used then raise exception 'Jumlah kirim melebihi stok tersedia.'; end if;

  if v_i.stock_kind='ASET' then
    if v_s.asset_id is null then raise exception 'Aset terkait pengiriman tidak ditemukan.'; end if;
    update public.barn_assets
      set barn_id=p_barn_id,location_type=v_dest,name=v_i.standard_name,quantity=p_quantity,unit=v_i.unit,
          acquired_on=p_shipment_date,acquisition_value=p_quantity*v_i.unit_price,
          notes='Sumber: Kirim Stok Gudang · Nota '||v_i.invoice_id::text||' · Item '||v_i.id::text||
                case when nullif(trim(coalesce(p_reference,'')),'') is not null then ' · Ref: '||trim(p_reference) else '' end||
                case when nullif(trim(coalesce(p_notes,'')),'') is not null then ' · '||trim(p_notes) else '' end,
          updated_at=now()
      where id=v_s.asset_id;
    if not found then raise exception 'Aset terkait pengiriman tidak ditemukan.'; end if;
  elsif v_s.asset_id is not null then
    raise exception 'Data pengiriman tidak konsisten dengan jenis stok.';
  end if;

  update public.warehouse_stock_shipments
     set shipment_date=p_shipment_date,destination_type=v_dest,barn_id=p_barn_id,quantity=p_quantity,
         reference=nullif(trim(coalesce(p_reference,'')),''),notes=nullif(trim(coalesce(p_notes,'')),'')
   where id=p_id;
  return p_id;
end $function$


CREATE OR REPLACE FUNCTION public.delete_logistics_equipment_purchase_atomic(p_id uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  v_asset uuid;
begin
  if not exists(select 1 from public.profiles p where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','LOGISTIK')) then
    raise exception 'Akses ditolak.';
  end if;
  select asset_id into v_asset from public.logistics_equipment_purchases where id=p_id for update;
  if not found then raise exception 'Pembelian peralatan tidak ditemukan.'; end if;
  if exists(select 1 from public.supplier_payments sp where sp.source_type='BELI_PERALATAN' and sp.source_id=p_id) then
    raise exception 'Pembelian sudah memiliki pembayaran dan tidak boleh dihapus.';
  end if;
  delete from public.logistics_equipment_purchases where id=p_id;
  if v_asset is not null then delete from public.barn_assets where id=v_asset; end if;
end $function$


CREATE OR REPLACE FUNCTION public.delete_warehouse_stock_shipment_atomic(p_id uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare v_asset uuid;
begin
  if not exists(select 1 from public.profiles p where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','LOGISTIK')) then raise exception 'Akses ditolak.'; end if;
  select asset_id into v_asset from public.warehouse_stock_shipments where id=p_id for update;
  if not found then raise exception 'Pengiriman gudang tidak ditemukan.'; end if;
  delete from public.warehouse_stock_shipments where id=p_id;
  if v_asset is not null then delete from public.barn_assets where id=v_asset; end if;
end $function$


CREATE OR REPLACE FUNCTION public.finance_correct_asset_invoice_atomic(p_invoice_id uuid, p_purchase_date date, p_supplier_name text, p_asset_location_type text, p_barn_id uuid, p_payment_method text, p_reference text, p_notes text, p_items jsonb)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  v_ids uuid[]; v_assets uuid[]; v_count int; v_i int; v_item jsonb; v_name text; v_unit text; v_qty numeric; v_price numeric; v_total numeric:=0; v_loc text;
begin
  if not exists(select 1 from public.profiles p where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','KEUANGAN')) then raise exception 'Akses ditolak.'; end if;
  perform 1 from public.finance_asset_purchase_invoices h where h.id=p_invoice_id for update;
  if not found then raise exception 'Nota aset tidak ditemukan.'; end if;
  v_loc:=upper(trim(coalesce(p_asset_location_type,'')));
  if v_loc not in ('KANDANG','KANTOR') then raise exception 'Lokasi aset tidak valid.'; end if;
  if v_loc='KANDANG' and p_barn_id is null then raise exception 'Pilih kandang tujuan aset.'; end if;
  if v_loc='KANTOR' then p_barn_id:=null; end if;
  if p_payment_method not in ('TUNAI','TRANSFER') then raise exception 'Metode pembayaran tidak valid.'; end if;
  if p_items is null or jsonb_typeof(p_items)<>'array' or jsonb_array_length(p_items)=0 then raise exception 'Minimal satu barang wajib diisi.'; end if;

  select array_agg(d.id order by d.created_at,d.id),array_agg(d.linked_id order by d.created_at,d.id),count(*)
    into v_ids,v_assets,v_count from public.finance_direct_purchases d where d.invoice_id=p_invoice_id and d.purchase_type='ASSET';
  if v_count<>jsonb_array_length(p_items) then raise exception 'Jumlah jenis barang tidak boleh diubah saat koreksi. Koreksi setiap baris yang sudah ada.'; end if;
  if exists(select 1 from public.barn_assets a where a.id=any(v_assets) and a.status<>'AKTIF') then raise exception 'Ada aset yang statusnya sudah berubah sehingga nota tidak boleh dikoreksi.'; end if;
  for v_i in 1..v_count loop
    v_item:=p_items->(v_i-1); v_name:=nullif(trim(coalesce(v_item->>'standard_name','')),''); v_unit:=upper(nullif(trim(coalesce(v_item->>'unit','')),''));
    begin v_qty:=(v_item->>'quantity')::numeric;v_price:=(v_item->>'unit_price')::numeric; exception when others then raise exception 'Jumlah atau harga aset tidak valid.'; end;
    if v_name is null or v_unit is null or coalesce(v_qty,0)<=0 or coalesce(v_price,-1)<0 then raise exception 'Data aset tidak valid.'; end if;
    v_total:=v_total+v_qty*v_price;
    update public.finance_direct_purchases set purchase_date=p_purchase_date,standard_name=v_name,description=nullif(trim(coalesce(v_item->>'description','')),''),
      supplier_name=nullif(trim(coalesce(p_supplier_name,'')),''),barn_id=p_barn_id,quantity=v_qty,unit=v_unit,unit_price=v_price,total_amount=v_qty*v_price,
      payment_method=p_payment_method,reference=nullif(trim(coalesce(p_reference,'')),''),notes=nullif(trim(coalesce(p_notes,'')),''),asset_location_type=v_loc where id=v_ids[v_i];
    update public.barn_assets set barn_id=p_barn_id,location_type=v_loc,name=v_name,quantity=v_qty,unit=v_unit,acquired_on=p_purchase_date,
      acquisition_value=v_qty*v_price,notes='Sumber: Beli Aset Keuangan Nota '||p_invoice_id::text||' · Detail '||v_ids[v_i]::text||
      case when nullif(trim(coalesce(v_item->>'description','')),'') is not null then ' · '||trim(v_item->>'description') else '' end||
      case when nullif(trim(coalesce(p_reference,'')),'') is not null then ' · Ref: '||trim(p_reference) else '' end,updated_at=now() where id=v_assets[v_i];
    if not found then raise exception 'Aset terkait nota tidak ditemukan.'; end if;
  end loop;
  update public.finance_asset_purchase_invoices set purchase_date=p_purchase_date,supplier_name=nullif(trim(coalesce(p_supplier_name,'')),''),
    asset_location_type=v_loc,barn_id=p_barn_id,payment_method=p_payment_method,reference=nullif(trim(coalesce(p_reference,'')),''),
    notes=nullif(trim(coalesce(p_notes,'')),''),total_amount=v_total where id=p_invoice_id;
  return p_invoice_id;
end $function$


CREATE OR REPLACE FUNCTION public.finance_correct_stock_invoice_atomic(p_invoice_id uuid, p_purchase_date date, p_supplier_name text, p_payment_method text, p_reference text, p_notes text, p_items jsonb)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  v_item jsonb; v_name text; v_unit text; v_kind text; v_qty numeric; v_price numeric; v_total numeric:=0;
begin
  if not exists(select 1 from public.profiles p where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','KEUANGAN')) then raise exception 'Akses ditolak.'; end if;
  perform 1 from public.finance_stock_purchase_invoices h where h.id=p_invoice_id for update;
  if not found then raise exception 'Nota pembelian stok tidak ditemukan.'; end if;
  if exists(select 1 from public.warehouse_stock_shipments s join public.warehouse_stock_items i on i.id=s.stock_item_id where i.invoice_id=p_invoice_id) then
    raise exception 'Nota sudah memiliki pengiriman gudang dan tidak boleh dikoreksi. Koreksi pengiriman terlebih dahulu bila diperlukan.';
  end if;
  if p_payment_method not in ('TUNAI','TRANSFER') then raise exception 'Metode pembayaran tidak valid.'; end if;
  if p_items is null or jsonb_typeof(p_items)<>'array' or jsonb_array_length(p_items)=0 then raise exception 'Minimal satu barang stok wajib diisi.'; end if;
  for v_item in select value from jsonb_array_elements(p_items) loop
    v_name:=nullif(trim(coalesce(v_item->>'standard_name','')),''); v_unit:=upper(nullif(trim(coalesce(v_item->>'unit','')),'')); v_kind:=upper(trim(coalesce(v_item->>'stock_kind','ASET')));
    begin v_qty:=(v_item->>'quantity')::numeric; v_price:=(v_item->>'unit_price')::numeric; exception when others then raise exception 'Jumlah atau harga barang stok tidak valid.'; end;
    if v_name is null or v_unit is null or v_kind not in ('ASET','HABIS_PAKAI') or coalesce(v_qty,0)<=0 or coalesce(v_price,-1)<0 then raise exception 'Data barang stok tidak valid.'; end if;
    v_total:=v_total+v_qty*v_price;
  end loop;
  delete from public.warehouse_stock_items where invoice_id=p_invoice_id;
  update public.finance_stock_purchase_invoices set purchase_date=p_purchase_date,supplier_name=nullif(trim(coalesce(p_supplier_name,'')),''),
    payment_method=p_payment_method,reference=nullif(trim(coalesce(p_reference,'')),''),notes=nullif(trim(coalesce(p_notes,'')),''),total_amount=v_total where id=p_invoice_id;
  for v_item in select value from jsonb_array_elements(p_items) loop
    insert into public.warehouse_stock_items(invoice_id,standard_name,description,stock_kind,quantity,unit,unit_price,total_amount,created_by)
    values(p_invoice_id,trim(v_item->>'standard_name'),nullif(trim(coalesce(v_item->>'description','')),''),
      upper(trim(coalesce(v_item->>'stock_kind','ASET'))),(v_item->>'quantity')::numeric,upper(trim(v_item->>'unit')),(v_item->>'unit_price')::numeric,
      (v_item->>'quantity')::numeric*(v_item->>'unit_price')::numeric,auth.uid());
  end loop;
  return p_invoice_id;
end $function$


CREATE OR REPLACE FUNCTION public.finance_delete_asset_invoice_atomic(p_invoice_id uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare v_assets uuid[];
begin
  if not exists(select 1 from public.profiles p where p.user_id=auth.uid() and p.active and p.role='ADMIN') then raise exception 'Hanya Administrator yang dapat menghapus nota.'; end if;
  perform 1 from public.finance_asset_purchase_invoices h where h.id=p_invoice_id for update;
  if not found then raise exception 'Nota aset tidak ditemukan.'; end if;
  select array_agg(d.linked_id) into v_assets from public.finance_direct_purchases d where d.invoice_id=p_invoice_id and d.purchase_type='ASSET';
  if exists(select 1 from public.barn_assets a where a.id=any(v_assets) and a.status<>'AKTIF') then raise exception 'Ada aset yang statusnya sudah berubah sehingga nota tidak boleh dihapus.'; end if;
  delete from public.finance_direct_purchases where invoice_id=p_invoice_id;
  if v_assets is not null then delete from public.barn_assets where id=any(v_assets); end if;
  delete from public.finance_asset_purchase_invoices where id=p_invoice_id;
end $function$


CREATE OR REPLACE FUNCTION public.finance_delete_stock_invoice_atomic(p_invoice_id uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  if not exists(select 1 from public.profiles p where p.user_id=auth.uid() and p.active and p.role='ADMIN') then raise exception 'Hanya Administrator yang dapat menghapus nota.'; end if;
  perform 1 from public.finance_stock_purchase_invoices h where h.id=p_invoice_id for update;
  if not found then raise exception 'Nota pembelian stok tidak ditemukan.'; end if;
  if exists(select 1 from public.warehouse_stock_shipments s join public.warehouse_stock_items i on i.id=s.stock_item_id where i.invoice_id=p_invoice_id) then raise exception 'Nota sudah memiliki pengiriman gudang dan tidak boleh dihapus.'; end if;
  delete from public.warehouse_stock_items where invoice_id=p_invoice_id;
  delete from public.finance_stock_purchase_invoices where id=p_invoice_id;
end $function$


GRANT EXECUTE ON FUNCTION public.delete_logistics_equipment_purchase_atomic(uuid) TO authenticated,service_role;
GRANT EXECUTE ON FUNCTION public.correct_warehouse_stock_shipment_atomic(uuid,date,text,uuid,numeric,text,text) TO authenticated,service_role;
GRANT EXECUTE ON FUNCTION public.delete_warehouse_stock_shipment_atomic(uuid) TO authenticated,service_role;
GRANT EXECUTE ON FUNCTION public.finance_correct_stock_invoice_atomic(uuid,date,text,text,text,text,jsonb) TO authenticated,service_role;
GRANT EXECUTE ON FUNCTION public.finance_delete_stock_invoice_atomic(uuid) TO authenticated,service_role;
GRANT EXECUTE ON FUNCTION public.finance_correct_asset_invoice_atomic(uuid,date,text,text,uuid,text,text,text,jsonb) TO authenticated,service_role;
GRANT EXECUTE ON FUNCTION public.finance_delete_asset_invoice_atomic(uuid) TO authenticated,service_role;
