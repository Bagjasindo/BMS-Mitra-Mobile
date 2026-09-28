-- Safe Expedition trip/invoice correction and deletion.
create or replace function public.finance_correct_expedition_trip_v1(
  p_trip_id uuid,
  p_trip_date date,
  p_mts_sj text,
  p_rr text,
  p_driver text,
  p_vehicle text,
  p_zone text,
  p_trip_price numeric,
  p_additional numeric default 0,
  p_deduction numeric default 0,
  p_notes text default null,
  p_destinations jsonb default '[]'::jsonb
)
returns boolean
language plpgsql
security definer
set search_path=public
as $$
declare
  v_line jsonb;
  v_no integer:=0;
  v_destination_id uuid;
  v_destination_name text;
  v_cargo text;
  v_qty numeric;
  v_unit text;
  v_total_qty numeric:=0;
  v_first_destination text;
  v_legacy_cargo text;
  v_invoice_id uuid;
  v_other_total numeric;
  v_paid numeric;
  v_new_total numeric;
begin
  if not exists(select 1 from public.profiles p where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','LOGISTIK'))
  then raise exception 'Akses ditolak.'; end if;
  if not exists(select 1 from public.finance_expedition_trips t where t.id=p_trip_id) then raise exception 'Trip tidak ditemukan.'; end if;
  if p_trip_date is null then raise exception 'Tanggal trip wajib.'; end if;
  if nullif(trim(p_driver),'') is null or nullif(trim(p_vehicle),'') is null or nullif(trim(p_zone),'') is null then raise exception 'Sopir, kendaraan, dan rute wajib.'; end if;
  if p_trip_price is null or p_trip_price<0 or coalesce(p_additional,0)<0 or coalesce(p_deduction,0)<0 then raise exception 'Nilai trip tidak valid.'; end if;
  if p_destinations is null or jsonb_typeof(p_destinations)<>'array' or jsonb_array_length(p_destinations)=0 then raise exception 'Minimal satu tujuan wajib.'; end if;

  for v_line in select value from jsonb_array_elements(p_destinations) loop
    v_no:=v_no+1;
    v_destination_id:=nullif(v_line->>'destination_id','')::uuid;
    v_destination_name:=nullif(trim(v_line->>'destination_name'),'');
    v_cargo:=nullif(trim(v_line->>'cargo'),'');
    v_qty:=nullif(v_line->>'qty','')::numeric;
    v_unit:=nullif(trim(v_line->>'unit'),'');
    if v_destination_name is null then raise exception 'Tujuan baris % wajib.',v_no; end if;
    if v_qty is not null and v_qty<0 then raise exception 'Qty baris % tidak valid.',v_no; end if;
    if v_no=1 then v_first_destination:=v_destination_name; end if;
    v_total_qty:=v_total_qty+coalesce(v_qty,0);
    v_legacy_cargo:=concat_ws(' • ',v_legacy_cargo,
      trim(concat(coalesce(v_destination_name,''),' - ',coalesce(v_cargo,''),
        case when v_qty is not null then ' '||trim(to_char(v_qty,'FM999999990.##')) else '' end,
        case when v_unit is not null then ' '||v_unit else '' end)));
  end loop;

  v_new_total:=p_trip_price+coalesce(p_additional,0)-coalesce(p_deduction,0);
  select ii.invoice_id into v_invoice_id from public.finance_expedition_invoice_items ii where ii.trip_id=p_trip_id limit 1;
  if v_invoice_id is not null then
    select coalesce(sum(t.trip_price+t.additional-t.deduction),0)
      into v_other_total
    from public.finance_expedition_invoice_items ii
    join public.finance_expedition_trips t on t.id=ii.trip_id
    where ii.invoice_id=v_invoice_id and ii.trip_id<>p_trip_id;
    select coalesce(sum(p.amount),0) into v_paid from public.finance_expedition_payments p where p.invoice_id=v_invoice_id;
    if v_other_total+v_new_total < v_paid-0.0001 then
      raise exception 'Koreksi trip membuat total invoice lebih kecil dari pembayaran yang sudah diterima Rp %.',v_paid;
    end if;
  end if;

  update public.finance_expedition_trips
  set trip_date=p_trip_date,mts_sj=nullif(trim(p_mts_sj),''),rr=nullif(trim(p_rr),''),
      driver=trim(p_driver),vehicle=trim(p_vehicle),zone=trim(p_zone),
      destination=v_first_destination,cargo=v_legacy_cargo,total_qty=v_total_qty,
      trip_price=p_trip_price,additional=coalesce(p_additional,0),deduction=coalesce(p_deduction,0),
      notes=nullif(trim(coalesce(p_notes,'')),'')
  where id=p_trip_id;

  delete from public.finance_expedition_trip_destinations where trip_id=p_trip_id;
  v_no:=0;
  for v_line in select value from jsonb_array_elements(p_destinations) loop
    v_no:=v_no+1;
    insert into public.finance_expedition_trip_destinations(
      trip_id,line_no,destination_id,destination_name,cargo,qty,unit,notes,created_by
    ) values(
      p_trip_id,v_no,nullif(v_line->>'destination_id','')::uuid,trim(v_line->>'destination_name'),
      nullif(trim(v_line->>'cargo'),''),nullif(v_line->>'qty','')::numeric,
      nullif(trim(v_line->>'unit'),''),nullif(trim(v_line->>'notes'),''),auth.uid()
    );
  end loop;
  return true;
end $$;

create or replace function public.admin_delete_expedition_trip_v1(p_trip_id uuid)
returns boolean language plpgsql security definer set search_path=public as $$
declare v_old jsonb;
begin
  if not exists(select 1 from public.profiles p where p.user_id=auth.uid() and p.active and p.role='ADMIN')
  then raise exception 'Hanya ADMIN yang boleh menghapus trip.'; end if;
  if exists(select 1 from public.finance_expedition_invoice_items ii where ii.trip_id=p_trip_id)
  then raise exception 'Trip sudah masuk invoice. Hapus/koreksi invoice terlebih dahulu.'; end if;
  select to_jsonb(t) into v_old from public.finance_expedition_trips t where t.id=p_trip_id;
  if v_old is null then raise exception 'Trip tidak ditemukan.'; end if;

  delete from public.finance_expedition_bop where trip_id=p_trip_id;
  delete from public.finance_expedition_trip_destinations where trip_id=p_trip_id;
  delete from public.finance_expedition_trips where id=p_trip_id;

  insert into public.audit_events(actor,action,table_name,record_id,old_data,new_data)
  values(auth.uid(),'DELETE_ADMIN','finance_expedition_trips',p_trip_id::text,v_old,null);
  return true;
end $$;

create or replace function public.finance_correct_expedition_invoice_v1(
  p_invoice_id uuid,
  p_invoice_date date,
  p_due_date date,
  p_customer_name text,
  p_customer_address text,
  p_trip_ids uuid[],
  p_notes text default null
)
returns boolean language plpgsql security definer set search_path=public as $$
declare v_paid numeric; v_total numeric;
begin
  if not exists(select 1 from public.profiles p where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','LOGISTIK'))
  then raise exception 'Akses ditolak.'; end if;
  if not exists(select 1 from public.finance_expedition_invoices i where i.id=p_invoice_id)
  then raise exception 'Invoice tidak ditemukan.'; end if;
  if p_invoice_date is null then raise exception 'Tanggal invoice wajib.'; end if;
  if nullif(trim(p_customer_name),'') is null then raise exception 'Pelanggan wajib.'; end if;
  if p_trip_ids is null or cardinality(p_trip_ids)=0 then raise exception 'Minimal satu trip wajib.'; end if;

  if exists(
    select 1 from unnest(p_trip_ids) x(id)
    left join public.finance_expedition_trips t on t.id=x.id
    where t.id is null
  ) then raise exception 'Ada trip yang tidak ditemukan.'; end if;

  if exists(
    select 1 from public.finance_expedition_invoice_items ii
    where ii.trip_id=any(p_trip_ids) and ii.invoice_id<>p_invoice_id
  ) then raise exception 'Ada trip yang sudah masuk invoice lain.'; end if;

  select coalesce(sum(t.trip_price+t.additional-t.deduction),0) into v_total
  from public.finance_expedition_trips t where t.id=any(p_trip_ids);
  select coalesce(sum(p.amount),0) into v_paid from public.finance_expedition_payments p where p.invoice_id=p_invoice_id;
  if v_total < v_paid-0.0001 then raise exception 'Total invoice baru lebih kecil dari pembayaran yang sudah diterima Rp %.',v_paid; end if;

  update public.finance_expedition_invoices
  set invoice_date=p_invoice_date,due_date=p_due_date,customer_name=trim(p_customer_name),
      customer_address=nullif(trim(coalesce(p_customer_address,'')),''),
      notes=nullif(trim(coalesce(p_notes,'')),'')
  where id=p_invoice_id;

  delete from public.finance_expedition_invoice_items where invoice_id=p_invoice_id;
  insert into public.finance_expedition_invoice_items(invoice_id,trip_id)
  select p_invoice_id,x from unnest(p_trip_ids) x;
  return true;
end $$;

create or replace function public.admin_delete_expedition_invoice_v1(p_invoice_id uuid)
returns boolean language plpgsql security definer set search_path=public as $$
declare v_old jsonb;
begin
  if not exists(select 1 from public.profiles p where p.user_id=auth.uid() and p.active and p.role='ADMIN')
  then raise exception 'Hanya ADMIN yang boleh menghapus invoice.'; end if;
  if exists(select 1 from public.finance_expedition_payments p where p.invoice_id=p_invoice_id)
  then raise exception 'Invoice sudah memiliki pembayaran. Hapus pembayaran terlebih dahulu.'; end if;
  select to_jsonb(i) into v_old from public.finance_expedition_invoices i where i.id=p_invoice_id;
  if v_old is null then raise exception 'Invoice tidak ditemukan.'; end if;
  delete from public.finance_expedition_invoice_items where invoice_id=p_invoice_id;
  delete from public.finance_expedition_invoices where id=p_invoice_id;
  insert into public.audit_events(actor,action,table_name,record_id,old_data,new_data)
  values(auth.uid(),'DELETE_ADMIN','finance_expedition_invoices',p_invoice_id::text,v_old,null);
  return true;
end $$;

revoke all on function public.finance_correct_expedition_trip_v1(uuid,date,text,text,text,text,text,numeric,numeric,numeric,text,jsonb) from public,anon;
revoke all on function public.admin_delete_expedition_trip_v1(uuid) from public,anon;
revoke all on function public.finance_correct_expedition_invoice_v1(uuid,date,date,text,text,uuid[],text) from public,anon;
revoke all on function public.admin_delete_expedition_invoice_v1(uuid) from public,anon;
grant execute on function public.finance_correct_expedition_trip_v1(uuid,date,text,text,text,text,text,numeric,numeric,numeric,text,jsonb) to authenticated;
grant execute on function public.admin_delete_expedition_trip_v1(uuid) to authenticated;
grant execute on function public.finance_correct_expedition_invoice_v1(uuid,date,date,text,text,uuid[],text) to authenticated;
grant execute on function public.admin_delete_expedition_invoice_v1(uuid) to authenticated;
