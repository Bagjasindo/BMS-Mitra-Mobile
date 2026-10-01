-- Supabase migration 20261001102332: force_idempotent_write_gateway_and_remove_direct_rpc_access
-- Force every allowlisted write through the idempotent gateway.
ALTER TABLE private.bms_rpc_allowlist
  ALTER COLUMN function_oid TYPE oid
  USING function_oid::oid;

CREATE OR REPLACE FUNCTION public.bms_execute_operation(
  p_operation_id uuid,
  p_action text,
  p_params jsonb DEFAULT '{}'::jsonb
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path=''
AS $$
DECLARE
  v_actor uuid:=auth.uid();
  v_hash text;
  v_saved private.bms_operation_receipts%rowtype;
  v_function record;
  v_args text:='';
  v_result jsonb;
  v_name text;
  v_type text;
  i integer;
  v_expr text;
BEGIN
  IF v_actor IS NULL OR NOT EXISTS(
    SELECT 1 FROM public.profiles
    WHERE user_id=v_actor AND active
  ) THEN
    RAISE EXCEPTION 'Akses ditolak. Profil aktif diperlukan.' USING ERRCODE='42501';
  END IF;

  IF p_operation_id IS NULL OR p_action IS NULL
     OR jsonb_typeof(p_params) IS DISTINCT FROM 'object' THEN
    RAISE EXCEPTION 'Identitas operasi dan parameter tidak valid.' USING ERRCODE='22023';
  END IF;

  v_hash:=encode(extensions.digest(p_action||':'||p_params::text,'sha256'),'hex');
  PERFORM pg_advisory_xact_lock(
    hashtextextended('BMS-OP:'||v_actor::text||':'||p_operation_id::text,0)
  );

  SELECT * INTO v_saved
  FROM private.bms_operation_receipts
  WHERE actor=v_actor AND operation_id=p_operation_id;

  IF FOUND THEN
    IF v_saved.request_hash<>v_hash THEN
      RAISE EXCEPTION 'Identitas operasi sudah digunakan dengan data berbeda.'
        USING ERRCODE='22023';
    END IF;
    RETURN v_saved.result;
  END IF;

  SELECT p.oid,p.proname,p.proargnames,p.proargtypes,p.pronargs,n.nspname
    INTO v_function
  FROM private.bms_rpc_allowlist a
  JOIN pg_proc p ON p.oid=a.function_oid
  JOIN pg_namespace n ON n.oid=p.pronamespace
  WHERE a.action=p_action
    AND n.nspname='public'
    AND NOT EXISTS(
      SELECT 1 FROM jsonb_object_keys(p_params) k
      WHERE NOT k=ANY(p.proargnames[1:p.pronargs])
    )
    AND NOT EXISTS(
      SELECT 1 FROM generate_series(1,p.pronargs-p.pronargdefaults) ix
      WHERE NOT p_params ? p.proargnames[ix]
    )
  ORDER BY p.pronargs
  LIMIT 1;

  IF v_function.oid IS NULL THEN
    RAISE EXCEPTION 'Operasi tidak diizinkan atau parameter tidak lengkap.'
      USING ERRCODE='42501';
  END IF;

  FOR i IN 1..v_function.pronargs LOOP
    v_name:=v_function.proargnames[i];
    IF NOT p_params ? v_name THEN CONTINUE; END IF;
    v_type:=format_type(v_function.proargtypes[i-1],NULL);
    IF v_type IN ('json','jsonb') THEN
      v_expr:=format('(NULLIF($1->%L,''null''::jsonb))::%s',v_name,v_type);
    ELSIF (SELECT typelem<>0 FROM pg_type WHERE oid=v_function.proargtypes[i-1]) THEN
      v_expr:=format(
        '(CASE WHEN $1->%L=''null''::jsonb THEN NULL ELSE ARRAY(SELECT jsonb_array_elements_text($1->%L))::%s END)',
        v_name,v_name,v_type
      );
    ELSE
      v_expr:=format('($1->>%L)::%s',v_name,v_type);
    END IF;
    v_args:=v_args||CASE WHEN v_args='' THEN '' ELSE ',' END
      ||format('%I => %s',v_name,v_expr);
  END LOOP;

  PERFORM set_config('bms.operation_id',p_operation_id::text,true);
  EXECUTE format(
    'SELECT to_jsonb(f) FROM %I.%I(%s) f',
    v_function.nspname,v_function.proname,v_args
  )
  INTO v_result
  USING p_params;

  INSERT INTO private.bms_operation_receipts(
    actor,operation_id,request_hash,action,result
  )
  VALUES(
    v_actor,p_operation_id,v_hash,p_action,coalesce(v_result,'null'::jsonb)
  );

  RETURN v_result;
END
$$;

REVOKE ALL ON FUNCTION public.bms_execute_operation(uuid,text,jsonb)
  FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.bms_execute_operation(uuid,text,jsonb)
  TO authenticated;

DO $$
DECLARE r record;
BEGIN
  FOR r IN
    SELECT p.oid::regprocedure AS signature
    FROM private.bms_rpc_allowlist a
    JOIN pg_proc p ON p.oid=a.function_oid
  LOOP
    EXECUTE format('REVOKE ALL ON FUNCTION %s FROM PUBLIC, anon, authenticated', r.signature);
  END LOOP;
END
$$;


-- Supabase migration 20261001102415: route_remaining_business_writes_through_idempotent_gateway
INSERT INTO private.bms_rpc_allowlist(function_oid,action)
SELECT p.oid,p.proname
FROM pg_proc p
JOIN pg_namespace n ON n.oid=p.pronamespace
WHERE n.nspname='public'
  AND p.proname=ANY(ARRAY[
    'admin_reopen_production_atomic',
    'finance_save_abk_advance_atomic',
    'logistics_send_warehouse_stock_atomic',
    'save_production_abk_harvest_atomic',
    'save_production_abk_result_atomic'
  ])
ON CONFLICT(function_oid) DO UPDATE SET action=excluded.action;

DO $$
DECLARE r record;
BEGIN
  FOR r IN
    SELECT p.oid::regprocedure AS signature
    FROM private.bms_rpc_allowlist a
    JOIN pg_proc p ON p.oid=a.function_oid
    WHERE p.proname=ANY(ARRAY[
      'admin_reopen_production_atomic',
      'finance_save_abk_advance_atomic',
      'logistics_send_warehouse_stock_atomic',
      'save_production_abk_harvest_atomic',
      'save_production_abk_result_atomic'
    ])
  LOOP
    EXECUTE format('REVOKE ALL ON FUNCTION %s FROM PUBLIC, anon, authenticated', r.signature);
  END LOOP;
END
$$;
