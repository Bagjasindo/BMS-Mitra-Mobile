-- A02/A03/A05: enforce payment invariants inside the database for every write path.
CREATE OR REPLACE FUNCTION private.guard_payment_integrity() RETURNS trigger
LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$
DECLARE
  v_total numeric; v_other numeric; v_date date; v_source uuid;
  v_supplier uuid; v_assignment uuid; v_barn uuid; v_type text;
BEGIN
  IF TG_TABLE_NAME='supplier_payments' THEN
    IF TG_OP='UPDATE' AND (new.source_type,new.source_id) IS DISTINCT FROM (old.source_type,old.source_id) THEN
      RAISE EXCEPTION 'Sumber pembayaran tidak dapat dipindahkan.';
    END IF;
    v_source:=CASE WHEN TG_OP='DELETE' THEN old.source_id ELSE new.source_id END;
    v_type:=CASE WHEN TG_OP='DELETE' THEN old.source_type ELSE new.source_type END;
    PERFORM pg_advisory_xact_lock(hashtextextended(v_type||':'||v_source::text,0));
    IF v_type='SAPRONAK_LUAR' THEN
      SELECT supplier_id,contract_assignment_id,barn_id,shipment_date INTO v_supplier,v_assignment,v_barn,v_date
      FROM public.logistics_external_shipments WHERE id=v_source FOR UPDATE;
      SELECT coalesce(sum(quantity*purchase_unit_price),0) INTO v_total FROM public.logistics_external_shipment_items WHERE external_shipment_id=v_source;
    ELSIF v_type='TAMBAH_DAGING' THEN
      SELECT supplier_id,contract_assignment_id,barn_id,purchase_date,weight_kg*purchase_price_per_kg
      INTO v_supplier,v_assignment,v_barn,v_date,v_total FROM public.marketing_external_meat_purchases WHERE id=v_source FOR UPDATE;
    ELSIF v_type='BELI_PERALATAN' THEN
      SELECT supplier_id,barn_id,purchase_date,quantity*purchase_unit_price INTO v_supplier,v_barn,v_date,v_total
      FROM public.logistics_equipment_purchases WHERE id=v_source FOR UPDATE;
    ELSE RAISE EXCEPTION 'Sumber pembayaran tidak valid.'; END IF;
    IF TG_OP='DELETE' THEN RETURN old; END IF;
    IF v_supplier IS NULL OR (new.supplier_id,new.contract_assignment_id,new.barn_id) IS DISTINCT FROM (v_supplier,v_assignment,v_barn) THEN
      RAISE EXCEPTION 'Supplier dan tujuan harus sesuai dokumen sumber.';
    END IF;
    SELECT coalesce(sum(amount),0) INTO v_other FROM public.supplier_payments
    WHERE source_type=v_type AND source_id=v_source AND id IS DISTINCT FROM new.id;
    IF new.paid_on IS NULL OR new.paid_on<v_date THEN RAISE EXCEPTION 'Tanggal pembayaran sebelum dokumen sumber.'; END IF;
  ELSIF TG_TABLE_NAME='finance_mandiri_sales_receipts' THEN
    IF TG_OP='UPDATE' AND new.harvest_id IS DISTINCT FROM old.harvest_id THEN RAISE EXCEPTION 'Sumber penerimaan tidak dapat dipindahkan.'; END IF;
    v_source:=CASE WHEN TG_OP='DELETE' THEN old.harvest_id ELSE new.harvest_id END;
    SELECT total_amount,harvested_on INTO v_total,v_date FROM public.marketing_contract_harvests WHERE id=v_source FOR UPDATE;
    IF TG_OP='DELETE' THEN RETURN old; END IF;
    IF NOT EXISTS (SELECT 1 FROM public.marketing_contract_harvests h JOIN public.logistics_contract_assignments a ON a.id=h.contract_assignment_id WHERE h.id=v_source AND a.cycle_type='MANDIRI') THEN
      RAISE EXCEPTION 'Penjualan Mandiri tidak ditemukan.';
    END IF;
    SELECT coalesce(sum(amount),0) INTO v_other FROM public.finance_mandiri_sales_receipts WHERE harvest_id=v_source AND id IS DISTINCT FROM new.id;
    IF new.received_on IS NULL OR new.received_on<v_date THEN RAISE EXCEPTION 'Tanggal penerimaan sebelum panen.'; END IF;
  ELSIF TG_TABLE_NAME='finance_mandiri_supplier_payments' THEN
    IF TG_OP='UPDATE' AND new.purchase_id IS DISTINCT FROM old.purchase_id THEN RAISE EXCEPTION 'Sumber pembayaran tidak dapat dipindahkan.'; END IF;
    v_source:=CASE WHEN TG_OP='DELETE' THEN old.purchase_id ELSE new.purchase_id END;
    SELECT quantity*purchase_unit_price,purchase_date INTO v_total,v_date FROM public.logistics_mandiri_purchases WHERE id=v_source FOR UPDATE;
    IF TG_OP='DELETE' THEN RETURN old; END IF;
    SELECT coalesce(sum(amount),0) INTO v_other FROM public.finance_mandiri_supplier_payments WHERE purchase_id=v_source AND id IS DISTINCT FROM new.id;
    IF new.paid_on IS NULL OR new.paid_on<v_date THEN RAISE EXCEPTION 'Tanggal pembayaran sebelum pembelian.'; END IF;
  ELSIF TG_TABLE_NAME='advance_payments' THEN
    v_source:=CASE WHEN TG_OP='DELETE' THEN old.advance_id ELSE new.advance_id END;
    IF TG_OP='UPDATE' THEN
      PERFORM 1 FROM public.advances WHERE id IN (old.advance_id,new.advance_id) ORDER BY id FOR UPDATE;
    END IF;
    SELECT amount,advanced_on INTO v_total,v_date FROM public.advances WHERE id=v_source FOR UPDATE;
    IF TG_OP='DELETE' THEN RETURN old; END IF;
    SELECT coalesce(sum(amount),0) INTO v_other FROM public.advance_payments WHERE advance_id=v_source AND id IS DISTINCT FROM new.id;
    IF new.paid_on IS NULL OR new.paid_on<v_date THEN RAISE EXCEPTION 'Tanggal pembayaran sebelum kasbon.'; END IF;
  ELSIF TG_TABLE_NAME='finance_expedition_payments' THEN
    IF TG_OP='UPDATE' AND new.invoice_id IS DISTINCT FROM old.invoice_id THEN RAISE EXCEPTION 'Invoice pembayaran tidak dapat dipindahkan.'; END IF;
    v_source:=CASE WHEN TG_OP='DELETE' THEN old.invoice_id ELSE new.invoice_id END;
    PERFORM pg_advisory_xact_lock(hashtextextended('EXPEDISI-INVOICE:'||v_source::text,0));
    SELECT invoice_date INTO v_date FROM public.finance_expedition_invoices WHERE id=v_source AND status<>'VOID' FOR UPDATE;
    IF TG_OP='DELETE' THEN RETURN old; END IF;
    IF v_date IS NULL THEN RAISE EXCEPTION 'Invoice tidak ditemukan atau VOID.'; END IF;
    SELECT coalesce(sum(t.trip_price+t.additional-t.deduction),0) INTO v_total
    FROM public.finance_expedition_invoice_items i JOIN public.finance_expedition_trips t ON t.id=i.trip_id WHERE i.invoice_id=v_source;
    SELECT coalesce(sum(amount),0) INTO v_other FROM public.finance_expedition_payments WHERE invoice_id=v_source AND id IS DISTINCT FROM new.id;
    IF new.paid_on IS NULL OR new.paid_on<v_date THEN RAISE EXCEPTION 'Tanggal pembayaran sebelum invoice.'; END IF;
  ELSE RAISE EXCEPTION 'Tabel pembayaran tidak didukung.'; END IF;
  IF new.amount IS NULL OR new.amount<=0 OR new.amount IN ('NaN'::numeric,'Infinity'::numeric,'-Infinity'::numeric) THEN
    RAISE EXCEPTION 'Nominal pembayaran harus positif dan valid.';
  END IF;
  IF v_total IS NULL OR v_total<0 OR v_total IN ('NaN'::numeric,'Infinity'::numeric,'-Infinity'::numeric) THEN
    RAISE EXCEPTION 'Nilai dokumen sumber tidak valid.';
  END IF;
  IF v_other+new.amount>v_total+0.0001 THEN RAISE EXCEPTION 'Pembayaran melebihi sisa saldo Rp %.',greatest(0,v_total-v_other); END IF;
  RETURN new;
END $$;
REVOKE ALL ON FUNCTION private.guard_payment_integrity() FROM PUBLIC,anon,authenticated;
DROP TRIGGER IF EXISTS guard_advance_payment ON public.advance_payments;
DO $$ DECLARE v_table text; BEGIN
  FOREACH v_table IN ARRAY ARRAY['supplier_payments','finance_mandiri_sales_receipts','finance_mandiri_supplier_payments','advance_payments','finance_expedition_payments'] LOOP
    EXECUTE format('DROP TRIGGER IF EXISTS a_guard_payment_integrity ON public.%I',v_table);
    EXECUTE format('CREATE TRIGGER a_guard_payment_integrity BEFORE INSERT OR UPDATE OR DELETE ON public.%I FOR EACH ROW EXECUTE FUNCTION private.guard_payment_integrity()',v_table);
  END LOOP;
END $$;

CREATE OR REPLACE FUNCTION private.audit_transaction_change() RETURNS trigger
LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$
DECLARE v_old jsonb; v_new jsonb; v_key text; v_operation text:=nullif(current_setting('bms.operation_id',true),'');
BEGIN
  IF TG_OP IN ('UPDATE','DELETE') THEN v_old:=to_jsonb(old); END IF;
  IF TG_OP IN ('INSERT','UPDATE') THEN v_new:=to_jsonb(new); END IF;
  IF TG_OP='UPDATE' AND v_old=v_new THEN RETURN new; END IF;
  v_key:=coalesce(v_new->>'id',v_old->>'id',v_new->>'user_id',v_old->>'user_id');
  IF v_operation IS NOT NULL THEN
    IF v_new IS NOT NULL THEN v_new:=v_new||jsonb_build_object('_bms_operation_id',v_operation); END IF;
    IF v_old IS NOT NULL THEN v_old:=v_old||jsonb_build_object('_bms_operation_id',v_operation); END IF;
  END IF;
  INSERT INTO public.audit_events(actor,action,table_name,record_id,old_data,new_data)
  VALUES(auth.uid(),'DB_'||TG_OP,TG_TABLE_NAME,v_key,v_old,v_new);
  IF TG_OP='DELETE' THEN RETURN old; END IF;
  RETURN new;
END $$;
REVOKE ALL ON FUNCTION private.audit_transaction_change() FROM PUBLIC,anon,authenticated;
DO $$ DECLARE r record; BEGIN
  FOR r IN SELECT c.oid,c.relname FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace
    WHERE n.nspname='public' AND c.relkind='r'
      AND c.relname NOT IN ('audit_events','user_activity_logs','finance_reference_counters','finance_expedition_invoice_counters')
      AND NOT EXISTS (SELECT 1 FROM pg_trigger t JOIN pg_proc p ON p.oid=t.tgfoid WHERE t.tgrelid=c.oid AND NOT t.tgisinternal AND p.proname IN ('audit_master_change','audit_and_guard','audit_transaction_change'))
  LOOP
    EXECUTE format('CREATE TRIGGER z_audit_transaction_change AFTER INSERT OR UPDATE OR DELETE ON public.%I FOR EACH ROW EXECUTE FUNCTION private.audit_transaction_change()',r.relname);
  END LOOP;
END $$;


CREATE OR REPLACE FUNCTION public.finance_correct_advance_payment_v1(p_id uuid, p_advance_id uuid, p_paid_on date, p_amount numeric, p_method text, p_notes text DEFAULT NULL::text)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
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

  perform 1 from public.advances where id in (p_advance_id,(select advance_id from public.advance_payments where id=p_id)) order by id for update;
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
end $function$;

CREATE OR REPLACE FUNCTION public.finance_correct_mandiri_receipt_v1(p_id uuid, p_received_on date, p_amount numeric, p_method text, p_reference text DEFAULT NULL::text, p_notes text DEFAULT NULL::text)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
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

  select h.total_amount into v_total from public.marketing_contract_harvests h where h.id=v_harvest for update;
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
end $function$;

CREATE OR REPLACE FUNCTION public.finance_correct_mandiri_supplier_payment_v1(p_id uuid, p_paid_on date, p_amount numeric, p_method text, p_reference text DEFAULT NULL::text, p_notes text DEFAULT NULL::text)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
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
  from public.logistics_mandiri_purchases m where m.id=v_purchase for update;

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
end $function$;

CREATE OR REPLACE FUNCTION public.finance_save_supplier_payment_atomic(p_source_type text, p_source_id uuid, p_paid_on date, p_amount numeric, p_method text, p_reference text DEFAULT NULL::text, p_notes text DEFAULT NULL::text)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  v_row record; v_paid numeric; v_balance numeric; v_id uuid;
begin
  if not exists (
    select 1 from public.profiles p where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','KEUANGAN')
  ) then raise exception 'Akses ditolak.'; end if;
  if p_source_type not in ('SAPRONAK_LUAR','TAMBAH_DAGING','BELI_PERALATAN') then raise exception 'Sumber hutang supplier tidak valid.'; end if;
  if p_paid_on is null then raise exception 'Tanggal pembayaran wajib.'; end if;
  if coalesce(p_amount,0)<=0 then raise exception 'Nominal pembayaran harus lebih dari 0.'; end if;
  if p_method not in ('TUNAI','TRANSFER') then raise exception 'Metode pembayaran tidak valid.'; end if;

  perform pg_advisory_xact_lock(hashtextextended(p_source_type||':'||p_source_id::text,0));
  if p_source_type='SAPRONAK_LUAR' then
    select h.supplier_id,h.contract_assignment_id,h.barn_id,coalesce(sum(i.quantity*i.purchase_unit_price),0)::numeric total_amount
    into v_row from public.logistics_external_shipments h
    join public.logistics_external_shipment_items i on i.external_shipment_id=h.id
    where h.id=p_source_id group by h.supplier_id,h.contract_assignment_id,h.barn_id;
  elsif p_source_type='TAMBAH_DAGING' then
    select m.supplier_id,m.contract_assignment_id,m.barn_id,(m.weight_kg*m.purchase_price_per_kg)::numeric total_amount
    into v_row from public.marketing_external_meat_purchases m where m.id=p_source_id;
  else
    select e.supplier_id,null::uuid contract_assignment_id,e.barn_id,(e.quantity*e.purchase_unit_price)::numeric total_amount
    into v_row from public.logistics_equipment_purchases e where e.id=p_source_id;
  end if;

  if v_row.supplier_id is null then raise exception 'Transaksi sumber tidak ditemukan.'; end if;
  select coalesce(sum(p.amount),0)::numeric into v_paid from public.supplier_payments p
  where p.source_type=p_source_type and p.source_id=p_source_id;
  v_balance:=greatest(0,v_row.total_amount-v_paid);
  if p_amount>v_balance+0.0001 then raise exception 'Pembayaran melebihi sisa hutang. Sisa Rp %.',v_balance; end if;

  insert into public.supplier_payments(
    source_type,source_id,supplier_id,contract_assignment_id,barn_id,paid_on,amount,method,reference,notes,created_by
  ) values (
    p_source_type,p_source_id,v_row.supplier_id,v_row.contract_assignment_id,v_row.barn_id,
    p_paid_on,p_amount,p_method,nullif(trim(coalesce(p_reference,'')),''),
    nullif(trim(coalesce(p_notes,'')),''),auth.uid()
  ) returning id into v_id;
  return v_id;
end $function$;

CREATE OR REPLACE FUNCTION public.finance_correct_supplier_payment_v1(p_id uuid, p_paid_on date, p_amount numeric, p_method text, p_reference text DEFAULT NULL::text, p_notes text DEFAULT NULL::text)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare v_source_type text; v_source_id uuid; v_total numeric; v_other numeric;
begin
  if not exists (
    select 1 from public.profiles p where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','KEUANGAN')
  ) then raise exception 'Akses ditolak.'; end if;
  if p_method not in ('TRANSFER','TUNAI') then raise exception 'Metode tidak valid.'; end if;
  if coalesce(p_amount,0)<=0 then raise exception 'Nominal harus lebih dari 0.'; end if;

  select p.source_type,p.source_id into v_source_type,v_source_id from public.supplier_payments p where p.id=p_id;
  if v_source_id is null then raise exception 'Pembayaran supplier tidak ditemukan.'; end if;

  perform pg_advisory_xact_lock(hashtextextended(v_source_type||':'||v_source_id::text,0));
  if v_source_type='SAPRONAK_LUAR' then
    select coalesce(sum(i.quantity*i.purchase_unit_price),0)::numeric into v_total
    from public.logistics_external_shipment_items i where i.external_shipment_id=v_source_id;
  elsif v_source_type='TAMBAH_DAGING' then
    select (m.weight_kg*m.purchase_price_per_kg)::numeric into v_total
    from public.marketing_external_meat_purchases m where m.id=v_source_id;
  elsif v_source_type='BELI_PERALATAN' then
    select (e.quantity*e.purchase_unit_price)::numeric into v_total
    from public.logistics_equipment_purchases e where e.id=v_source_id;
  else raise exception 'Sumber pembayaran tidak valid.'; end if;

  select coalesce(sum(p.amount),0) into v_other from public.supplier_payments p
  where p.source_type=v_source_type and p.source_id=v_source_id and p.id<>p_id;
  if p_amount>greatest(0,v_total-v_other)+0.0001 then raise exception 'Nominal melebihi sisa hutang Rp %.',greatest(0,v_total-v_other); end if;

  update public.supplier_payments
  set paid_on=p_paid_on,amount=p_amount,method=p_method,
      reference=nullif(trim(coalesce(p_reference,'')),''),
      notes=nullif(trim(coalesce(p_notes,'')),'')
  where id=p_id;
  return true;
end $function$;
