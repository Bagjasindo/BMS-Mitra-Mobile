-- Guards correction/deletion after linked assets stop being ACTIVE.

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
    if exists(select 1 from public.barn_assets ba where ba.id=v_s.asset_id and ba.status<>'AKTIF') then
      raise exception 'Aset terkait sudah tidak AKTIF sehingga pengiriman tidak boleh dikoreksi.';
    end if;
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
  if v_asset is not null and exists(select 1 from public.barn_assets ba where ba.id=v_asset and ba.status<>'AKTIF') then
    raise exception 'Aset terkait sudah tidak AKTIF sehingga pembelian tidak boleh dihapus.';
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
  if v_asset is not null and exists(select 1 from public.barn_assets ba where ba.id=v_asset and ba.status<>'AKTIF') then
    raise exception 'Aset terkait sudah tidak AKTIF sehingga pengiriman tidak boleh dihapus.';
  end if;
  delete from public.warehouse_stock_shipments where id=p_id;
  if v_asset is not null then delete from public.barn_assets where id=v_asset; end if;
end $function$


CREATE OR REPLACE FUNCTION public.save_logistics_equipment_purchase_atomic(p_id uuid, p_supplier_id uuid, p_item_id uuid, p_barn_id uuid, p_purchase_date date, p_quantity numeric, p_purchase_unit_price numeric, p_reference_number text DEFAULT NULL::text, p_notes text DEFAULT NULL::text)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
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

           select i.id,i.code,i.name,i.category,i.ovk_type,i.unit,i.active
           into v_item from public.items i where i.id=p_item_id;

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
             if v_asset_id is not null and exists(select 1 from public.barn_assets ba where ba.id=v_asset_id and ba.status<>'AKTIF') then
               raise exception 'Aset terkait sudah tidak AKTIF sehingga pembelian tidak boleh dikoreksi.';
             end if;
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
               barn_id,name,category,quantity,unit,acquired_on,acquisition_value,condition,status,notes,created_by
             ) values (
               p_barn_id,v_item.name,'PERALATAN',p_quantity,v_item.unit,p_purchase_date,p_quantity*p_purchase_unit_price,
               'BAIK','AKTIF',v_asset_notes,auth.uid()
             ) returning id into v_asset_id;
             update public.logistics_equipment_purchases set asset_id=v_asset_id where id=v_id;
           else
             update public.barn_assets
             set barn_id=p_barn_id,name=v_item.name,category='PERALATAN',
                 quantity=p_quantity,unit=v_item.unit,
                 acquired_on=p_purchase_date,acquisition_value=p_quantity*p_purchase_unit_price,
                 notes=v_asset_notes,updated_at=now()
             where id=v_asset_id;
           end if;

           return v_id;
         end $function$
