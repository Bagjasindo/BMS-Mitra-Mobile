-- A04: one committed result per actor/operation, including concurrent retries.
CREATE TABLE private.bms_operation_receipts (
  actor uuid NOT NULL,
  operation_id uuid NOT NULL,
  request_hash text NOT NULL,
  action text NOT NULL,
  result jsonb NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY(actor,operation_id)
);
ALTER TABLE private.bms_operation_receipts ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON private.bms_operation_receipts FROM PUBLIC,anon,authenticated;
CREATE TABLE private.bms_rpc_allowlist(function_oid regprocedure PRIMARY KEY,action text NOT NULL);
ALTER TABLE private.bms_rpc_allowlist ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON private.bms_rpc_allowlist FROM PUBLIC,anon,authenticated;

CREATE OR REPLACE FUNCTION public.bms_execute_operation(p_operation_id uuid,p_action text,p_params jsonb DEFAULT '{}'::jsonb)
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$
DECLARE v_actor uuid:=auth.uid(); v_hash text; v_saved private.bms_operation_receipts%rowtype;
  v_function record; v_args text:=''; v_result jsonb; v_name text; v_type text; i integer; v_expr text;
BEGIN
  IF v_actor IS NULL OR NOT EXISTS(SELECT 1 FROM public.profiles WHERE user_id=v_actor AND active) THEN
    RAISE EXCEPTION 'Akses ditolak. Profil aktif diperlukan.' USING ERRCODE='42501';
  END IF;
  IF p_operation_id IS NULL OR p_action IS NULL OR jsonb_typeof(p_params) IS DISTINCT FROM 'object' THEN
    RAISE EXCEPTION 'Identitas operasi dan parameter tidak valid.' USING ERRCODE='22023';
  END IF;
  v_hash:=encode(extensions.digest(p_action||':'||p_params::text,'sha256'),'hex');
  PERFORM pg_advisory_xact_lock(hashtextextended('BMS-OP:'||v_actor::text||':'||p_operation_id::text,0));
  SELECT * INTO v_saved FROM private.bms_operation_receipts WHERE actor=v_actor AND operation_id=p_operation_id;
  IF FOUND THEN
    IF v_saved.request_hash<>v_hash THEN RAISE EXCEPTION 'Identitas operasi sudah digunakan dengan data berbeda.' USING ERRCODE='22023'; END IF;
    RETURN v_saved.result;
  END IF;

  SELECT p.oid,p.proname,p.proargnames,p.proargtypes,p.pronargs,n.nspname
  INTO v_function FROM private.bms_rpc_allowlist a JOIN pg_proc p ON p.oid=a.function_oid::oid JOIN pg_namespace n ON n.oid=p.pronamespace
  WHERE a.action=p_action AND n.nspname='public' AND has_function_privilege('authenticated',p.oid,'EXECUTE')
    AND NOT EXISTS(SELECT 1 FROM jsonb_object_keys(p_params) k WHERE NOT k=ANY(p.proargnames[1:p.pronargs]))
    AND NOT EXISTS(SELECT 1 FROM generate_series(1,p.pronargs-p.pronargdefaults) ix WHERE NOT p_params ? p.proargnames[ix])
  ORDER BY p.pronargs LIMIT 1;
  IF v_function.oid IS NULL THEN RAISE EXCEPTION 'Operasi tidak diizinkan atau parameter tidak lengkap.' USING ERRCODE='42501'; END IF;

  FOR i IN 1..v_function.pronargs LOOP
    v_name:=v_function.proargnames[i];
    IF NOT p_params ? v_name THEN CONTINUE; END IF;
    v_type:=format_type(v_function.proargtypes[i-1],NULL);
    IF v_type IN ('json','jsonb') THEN
      v_expr:=format('(NULLIF($1->%L,''null''::jsonb))::%s',v_name,v_type);
    ELSIF (SELECT typelem<>0 FROM pg_type WHERE oid=v_function.proargtypes[i-1]) THEN
      v_expr:=format('(CASE WHEN $1->%L=''null''::jsonb THEN NULL ELSE ARRAY(SELECT jsonb_array_elements_text($1->%L))::%s END)',v_name,v_name,v_type);
    ELSE v_expr:=format('($1->>%L)::%s',v_name,v_type); END IF;
    v_args:=v_args||CASE WHEN v_args='' THEN '' ELSE ',' END||format('%I => %s',v_name,v_expr);
  END LOOP;
  PERFORM set_config('bms.operation_id',p_operation_id::text,true);
  EXECUTE format('SELECT to_jsonb(f) FROM %I.%I(%s) f',v_function.nspname,v_function.proname,v_args) INTO v_result USING p_params;
  INSERT INTO private.bms_operation_receipts(actor,operation_id,request_hash,action,result)
  VALUES(v_actor,p_operation_id,v_hash,p_action,coalesce(v_result,'null'::jsonb));
  RETURN v_result;
END $$;
REVOKE ALL ON FUNCTION public.bms_execute_operation(uuid,text,jsonb) FROM PUBLIC,anon;
GRANT EXECUTE ON FUNCTION public.bms_execute_operation(uuid,text,jsonb) TO authenticated;

INSERT INTO private.bms_rpc_allowlist(function_oid,action)
SELECT p.oid::regprocedure,p.proname FROM pg_proc p JOIN pg_namespace n ON n.oid=p.pronamespace WHERE n.nspname='public' AND p.proname=ANY(ARRAY['admin_cleanup_closed_bop_legacy_v1','admin_close_mandiri_cycle_atomic','admin_close_production_atomic','admin_correct_closed_abk_population_v1','admin_delete_abk_salary_v1','admin_delete_company_feed_movement_v1','admin_delete_expedition_invoice_v1','admin_delete_expedition_trip_bop_v1','admin_delete_expedition_trip_v1','admin_delete_mitra_split_return_v1','admin_delete_transaction_v1','admin_reclose_cycle_v1','admin_reopen_cycle_v1','admin_set_finance_bop_period_access','admin_update_bms_user','delete_mandiri_purchase_atomic','delete_production_abk_harvest_atomic','finance_correct_abk_salary_v1','finance_correct_advance_payment_v1','finance_correct_employee_advance_v1','finance_correct_expedition_invoice_v1','finance_correct_expedition_trip_op','finance_correct_expedition_trip_v1','finance_correct_mandiri_receipt_v1','finance_correct_mandiri_supplier_payment_v1','finance_correct_rhpp_real_v1','finance_correct_supplier_payment_v1','finance_create_expedition_invoice_atomic','finance_pay_mandiri_supplier_atomic','finance_post_expedition_bop_for_trip','finance_receive_mandiri_sale_atomic','finance_save_abk_salary_atomic','finance_save_asset_invoice_atomic','finance_save_employee_advance_atomic','finance_save_expedition_payment_atomic','finance_save_expedition_trip_atomic','finance_save_rhpp_real_atomic','finance_save_stock_invoice_atomic','finance_save_supplier_payment_atomic','lock_production_abk_basics_atomic','logistics_correct_company_feed_movement_v1','logistics_correct_mitra_split_return_v1','move_company_feed_atomic','save_chick_in_with_abks_v1','save_external_sapronak_atomic','save_external_sapronak_return_atomic','save_logistics_equipment_purchase_atomic','save_logistics_return_atomic','save_logistics_shipment_atomic','save_mandiri_purchase_atomic','save_mitra_split_return_atomic','save_production_abk_initial_population_atomic','save_production_estimate_atomic','save_recording_atomic','transfer_external_sapronak_return_atomic']);
