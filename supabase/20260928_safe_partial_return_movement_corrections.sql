-- Safe correction/delete for partial Mitra returns and company feed movements.
create or replace function public.logistics_correct_mitra_split_return_v1(
  p_retained_feed_id uuid,
  p_return_date date,
  p_physical_quantity numeric,
  p_accepted_quantity numeric,
  p_reference text default null,
  p_notes text default null
)
returns boolean
language plpgsql
security definer
set search_path=public
as $$
declare
  v_lot public.logistics_mitra_retained_feed%rowtype;
  v_return_item public.logistics_return_items%rowtype;
  v_retained numeric;
  v_balance numeric;
  v_kg numeric;
begin
  if not exists(select 1 from public.profiles p where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','LOGISTIK'))
  then raise exception 'Akses ditolak.'; end if;

  select * into v_lot from public.logistics_mitra_retained_feed where id=p_retained_feed_id for update;
  if v_lot.id is null then raise exception 'Transaksi retur sebagian tidak ditemukan.'; end if;
  select * into v_return_item from public.logistics_return_items where id=v_lot.return_item_id for update;
  if v_return_item.id is null then raise exception 'Detail retur tidak ditemukan.'; end if;

  if p_return_date is null then raise exception 'Tanggal retur wajib.'; end if;
  if coalesce(p_physical_quantity,0)<=0 or coalesce(p_accepted_quantity,0)<0 or p_accepted_quantity>=p_physical_quantity
  then raise exception 'Jumlah fisik harus lebih besar dari jumlah diterima inti.'; end if;

  v_retained:=p_physical_quantity-p_accepted_quantity;
  select i.kg_per_unit into v_kg from public.items i where i.id=v_lot.item_id;

  select v_retained + coalesce(sum(case when m.direction='OUT' then m.quantity else -m.quantity end),0)
  into v_balance
  from public.logistics_company_feed_movements m
  where m.retained_feed_id=v_lot.id;

  if v_balance < -0.0001 then
    raise exception 'Sisa stok baru tidak cukup untuk pemindahan yang sudah tercatat. Saldo akan menjadi %.',v_balance;
  end if;

  update public.logistics_returns
  set return_date=p_return_date,
      reference=nullif(trim(coalesce(p_reference,'')),''),
      notes=nullif(trim(coalesce(p_notes,'')),''),
      updated_at=now()
  where id=v_lot.return_id;

  update public.logistics_return_items
  set quantity=p_accepted_quantity,
      quantity_kg=case when v_kg is null then null else p_accepted_quantity*v_kg end
  where id=v_lot.return_item_id;

  update public.logistics_mitra_retained_feed
  set quantity=v_retained
  where id=v_lot.id;

  return true;
end $$;

create or replace function public.logistics_correct_company_feed_movement_v1(
  p_id uuid,
  p_contract_assignment_id uuid,
  p_direction text,
  p_quantity numeric,
  p_transferred_on date,
  p_reference text default null
)
returns boolean
language plpgsql
security definer
set search_path=public
as $$
declare
  v_move public.logistics_company_feed_movements%rowtype;
  v_lot public.logistics_mitra_retained_feed%rowtype;
  v_balance numeric;
begin
  if not exists(select 1 from public.profiles p where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','LOGISTIK'))
  then raise exception 'Akses ditolak.'; end if;
  select * into v_move from public.logistics_company_feed_movements where id=p_id for update;
  if v_move.id is null then raise exception 'Pemindahan stok tidak ditemukan.'; end if;
  select * into v_lot from public.logistics_mitra_retained_feed where id=v_move.retained_feed_id for update;
  if v_lot.id is null then raise exception 'Stok asal tidak ditemukan.'; end if;

  if p_direction not in ('IN','OUT') then raise exception 'Arah pemindahan tidak valid.'; end if;
  if coalesce(p_quantity,0)<=0 then raise exception 'Jumlah harus lebih dari nol.'; end if;
  if p_transferred_on is null then raise exception 'Tanggal wajib.'; end if;
  if not exists(select 1 from public.logistics_contract_assignments a where a.id=p_contract_assignment_id and a.active)
  then raise exception 'Kandang/siklus tujuan tidak aktif.'; end if;

  select v_lot.quantity + coalesce(sum(case when m.direction='OUT' then m.quantity else -m.quantity end),0)
  into v_balance
  from public.logistics_company_feed_movements m
  where m.retained_feed_id=v_lot.id and m.id<>p_id;

  v_balance:=v_balance + case when p_direction='OUT' then p_quantity else -p_quantity end;
  if v_balance < -0.0001 then raise exception 'Koreksi membuat saldo stok BMS negatif.'; end if;

  update public.logistics_company_feed_movements
  set contract_assignment_id=p_contract_assignment_id,
      direction=p_direction,
      quantity=p_quantity,
      transferred_on=p_transferred_on,
      reference=nullif(trim(coalesce(p_reference,'')),'')
  where id=p_id;

  return true;
end $$;

create or replace function public.admin_delete_company_feed_movement_v1(p_id uuid)
returns boolean
language plpgsql
security definer
set search_path=public
as $$
declare
  v_move public.logistics_company_feed_movements%rowtype;
  v_lot public.logistics_mitra_retained_feed%rowtype;
  v_balance numeric;
  v_old jsonb;
begin
  if not exists(select 1 from public.profiles p where p.user_id=auth.uid() and p.active and p.role='ADMIN')
  then raise exception 'Hanya ADMIN yang boleh menghapus pemindahan stok.'; end if;
  select * into v_move from public.logistics_company_feed_movements where id=p_id for update;
  if v_move.id is null then raise exception 'Pemindahan stok tidak ditemukan.'; end if;
  select * into v_lot from public.logistics_mitra_retained_feed where id=v_move.retained_feed_id for update;
  v_old:=to_jsonb(v_move);

  select v_lot.quantity + coalesce(sum(case when m.direction='OUT' then m.quantity else -m.quantity end),0)
  into v_balance
  from public.logistics_company_feed_movements m
  where m.retained_feed_id=v_lot.id and m.id<>p_id;

  if v_balance < -0.0001 then
    raise exception 'Pemindahan ini tidak dapat dihapus karena stok berikutnya bergantung pada transaksi ini.';
  end if;

  delete from public.logistics_company_feed_movements where id=p_id;
  insert into public.audit_events(actor,action,table_name,record_id,old_data,new_data)
  values(auth.uid(),'DELETE_ADMIN','logistics_company_feed_movements',p_id::text,v_old,null);
  return true;
end $$;

create or replace function public.admin_delete_mitra_split_return_v1(p_retained_feed_id uuid)
returns boolean
language plpgsql
security definer
set search_path=public
as $$
declare
  v_lot public.logistics_mitra_retained_feed%rowtype;
  v_return jsonb;
  v_item jsonb;
begin
  if not exists(select 1 from public.profiles p where p.user_id=auth.uid() and p.active and p.role='ADMIN')
  then raise exception 'Hanya ADMIN yang boleh menghapus retur sebagian.'; end if;

  select * into v_lot from public.logistics_mitra_retained_feed where id=p_retained_feed_id for update;
  if v_lot.id is null then raise exception 'Retur sebagian tidak ditemukan.'; end if;

  if exists(select 1 from public.logistics_company_feed_movements m where m.retained_feed_id=v_lot.id)
  then raise exception 'Retur tidak dapat dihapus karena stok BMS sudah memiliki riwayat pemindahan. Hapus pemindahan terkait terlebih dahulu.'; end if;

  select to_jsonb(r) into v_return from public.logistics_returns r where r.id=v_lot.return_id;
  select to_jsonb(i) into v_item from public.logistics_return_items i where i.id=v_lot.return_item_id;

  delete from public.logistics_mitra_retained_feed where id=v_lot.id;
  delete from public.logistics_return_items where id=v_lot.return_item_id;
  if not exists(select 1 from public.logistics_return_items i where i.return_id=v_lot.return_id) then
    delete from public.logistics_returns where id=v_lot.return_id;
  end if;

  insert into public.audit_events(actor,action,table_name,record_id,old_data,new_data)
  values(auth.uid(),'DELETE_ADMIN','logistics_mitra_retained_feed',p_retained_feed_id::text,
    jsonb_build_object('retained_feed',to_jsonb(v_lot),'return',v_return,'return_item',v_item),null);
  return true;
end $$;

revoke all on function public.logistics_correct_mitra_split_return_v1(uuid,date,numeric,numeric,text,text) from public,anon;
revoke all on function public.logistics_correct_company_feed_movement_v1(uuid,uuid,text,numeric,date,text) from public,anon;
revoke all on function public.admin_delete_company_feed_movement_v1(uuid) from public,anon;
revoke all on function public.admin_delete_mitra_split_return_v1(uuid) from public,anon;
grant execute on function public.logistics_correct_mitra_split_return_v1(uuid,date,numeric,numeric,text,text) to authenticated;
grant execute on function public.logistics_correct_company_feed_movement_v1(uuid,uuid,text,numeric,date,text) to authenticated;
grant execute on function public.admin_delete_company_feed_movement_v1(uuid) to authenticated;
grant execute on function public.admin_delete_mitra_split_return_v1(uuid) to authenticated;
