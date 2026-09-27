-- Generic DOC, OVK, and other master items may be purchased from the supplier selected on each Mandiri purchase.
-- Items with a fixed supplier remain restricted to that supplier.
create or replace function public.save_mandiri_purchase_atomic(
  p_purchase_id uuid,p_supplier_id uuid,p_item_id uuid,p_purchase_date date,p_quantity numeric,
  p_purchase_unit_price numeric,p_reference_number text,p_notes text,p_allocations jsonb
) returns uuid language plpgsql security definer set search_path='' as $$
declare
  v_id uuid;
  v_sum numeric:=0;
  v jsonb;
  v_assignment uuid;
  v_qty numeric;
begin
  if not exists(select 1 from public.profiles p where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','LOGISTIK')) then raise exception 'Akses ditolak.'; end if;
  if coalesce(p_quantity,0)<=0 then raise exception 'Jumlah pembelian harus lebih dari 0.'; end if;
  if p_purchase_unit_price is null or p_purchase_unit_price<0 then raise exception 'Harga beli tidak valid.'; end if;
  if p_purchase_date is null then raise exception 'Tanggal pembelian wajib diisi.'; end if;
  if not exists(select 1 from public.suppliers s where s.id=p_supplier_id and s.active and s.supplier_type='SAPRONAK') then raise exception 'Supplier Sapronak tidak valid.'; end if;
  if not exists(select 1 from public.items i where i.id=p_item_id and i.active and (i.supplier_id=p_supplier_id or i.supplier_id is null)) then raise exception 'Barang tidak sesuai Supplier.'; end if;
  if p_purchase_id is not null and exists(
    select 1 from public.logistics_mandiri_purchase_allocations a
    join public.logistics_contract_assignments ca on ca.id=a.contract_assignment_id
    where a.purchase_id=p_purchase_id and not ca.active
  ) then raise exception 'Pembelian sudah terkait siklus CLOSED dan tidak dapat diedit.'; end if;
  if p_allocations is null or jsonb_typeof(p_allocations)<>'array' then raise exception 'Distribusi kandang tidak valid.'; end if;

  for v in select value from jsonb_array_elements(p_allocations)
  loop
    v_assignment:=(v->>'assignment_id')::uuid;
    v_qty:=coalesce((v->>'quantity')::numeric,0);
    if v_qty<=0 then raise exception 'Jumlah distribusi harus lebih dari 0.'; end if;
    if not exists(select 1 from public.logistics_contract_assignments a where a.id=v_assignment and a.active and a.cycle_type='MANDIRI') then raise exception 'Distribusi hanya boleh ke siklus Mandiri aktif.'; end if;
    v_sum:=v_sum+v_qty;
  end loop;
  if v_sum>p_quantity then raise exception 'Total distribusi (%) melebihi jumlah pembelian (%).',v_sum,p_quantity; end if;

  if p_purchase_id is null then
    insert into public.logistics_mandiri_purchases(supplier_id,item_id,purchase_date,quantity,purchase_unit_price,reference_number,notes,created_by)
    values(p_supplier_id,p_item_id,p_purchase_date,p_quantity,p_purchase_unit_price,p_reference_number,p_notes,auth.uid())
    returning id into v_id;
  else
    update public.logistics_mandiri_purchases
    set supplier_id=p_supplier_id,item_id=p_item_id,purchase_date=p_purchase_date,quantity=p_quantity,
        purchase_unit_price=p_purchase_unit_price,reference_number=p_reference_number,notes=p_notes,updated_at=now()
    where id=p_purchase_id returning id into v_id;
    if v_id is null then raise exception 'Pembelian Mandiri tidak ditemukan.'; end if;
    delete from public.logistics_mandiri_purchase_allocations where purchase_id=v_id;
  end if;

  for v in select value from jsonb_array_elements(p_allocations)
  loop
    insert into public.logistics_mandiri_purchase_allocations(purchase_id,contract_assignment_id,quantity)
    values(v_id,(v->>'assignment_id')::uuid,(v->>'quantity')::numeric);
  end loop;
  return v_id;
end $$;

