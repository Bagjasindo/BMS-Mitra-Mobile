-- A10: portable account/data recovery export, exclusively for active ADMIN.
-- The frontend encrypts this document before creating any download.
ALTER FUNCTION private.bms_archive_document() STABLE;
ALTER FUNCTION public.bms_export_archive() STABLE;
CREATE OR REPLACE FUNCTION public.bms_export_recovery_document() RETURNS jsonb
LANGUAGE plpgsql STABLE SECURITY DEFINER SET search_path='' AS $$
DECLARE v_document jsonb; v_auth jsonb:='{}'::jsonb; v_rows jsonb; v_table text;
BEGIN
  IF NOT EXISTS(SELECT 1 FROM public.profiles WHERE user_id=auth.uid() AND active AND role='ADMIN') THEN
    RAISE EXCEPTION 'Hanya Administrator aktif yang dapat membuat backup pemulihan.' USING ERRCODE='42501';
  END IF;
  v_document:=private.bms_archive_document();
  FOREACH v_table IN ARRAY ARRAY['users','identities','mfa_factors'] LOOP
    EXECUTE format('SELECT coalesce(jsonb_agg(to_jsonb(x) ORDER BY to_jsonb(x)),''[]''::jsonb) FROM auth.%I x',v_table) INTO v_rows;
    v_auth:=v_auth||jsonb_build_object(v_table,v_rows);
  END LOOP;
  RETURN v_document||jsonb_build_object('format','BMS_FULL_RECOVERY','recovery_version',1,
    'auth',v_auth,'operation_receipts',(SELECT coalesce(jsonb_agg(to_jsonb(x) ORDER BY to_jsonb(x)),'[]'::jsonb) FROM private.bms_operation_receipts x),
    'application_build','2326','auth_checksum',encode(extensions.digest(v_auth::text,'sha256'),'hex'));
END $$;
REVOKE ALL ON FUNCTION public.bms_export_recovery_document() FROM PUBLIC,anon;
GRANT EXECUTE ON FUNCTION public.bms_export_recovery_document() TO authenticated;

-- Operator-only restore drill. It cannot target production or overwrite a schema.
CREATE OR REPLACE FUNCTION private.bms_verify_recovery(p_document jsonb,p_target_schema text) RETURNS jsonb
LANGUAGE plpgsql SET search_path='' AS $$
DECLARE r record; v_rows jsonb; v_cols text; v_select text; v_expected bigint; v_actual bigint;
  v_restored bigint:=0; v_auth_count bigint:=0; v_fk text; v_source regclass; v_name text;
BEGIN
  IF p_target_schema !~ '^bms_restore_verify_[a-z0-9_]+$' OR EXISTS(SELECT 1 FROM pg_namespace WHERE nspname=p_target_schema) THEN
    RAISE EXCEPTION 'Pemulihan uji harus memakai skema baru bms_restore_verify_*.';
  END IF;
  IF p_document->>'format'<>'BMS_FULL_RECOVERY' OR p_document->>'recovery_version'<>'1'
    OR p_document->>'checksum' IS DISTINCT FROM encode(extensions.digest((p_document->'tables')::text,'sha256'),'hex')
    OR p_document->>'auth_checksum' IS DISTINCT FROM encode(extensions.digest((p_document->'auth')::text,'sha256'),'hex') THEN
    RAISE EXCEPTION 'Format atau checksum backup tidak valid.';
  END IF;
  IF (SELECT count(*) FROM jsonb_object_keys(p_document->'tables'))<>(SELECT count(*) FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace WHERE n.nspname='public' AND c.relkind='r') THEN
    RAISE EXCEPTION 'Cakupan tabel backup berbeda dari schema aplikasi.';
  END IF;
  EXECUTE format('CREATE SCHEMA %I',p_target_schema);
  EXECUTE format('REVOKE ALL ON SCHEMA %I FROM PUBLIC,anon,authenticated',p_target_schema);
  FOR r IN
    SELECT 'public'::text source_schema,key source_name,key target_name,value rows FROM jsonb_each(p_document->'tables')
    UNION ALL SELECT 'auth',key,'auth_'||key,value FROM jsonb_each(p_document->'auth')
    UNION ALL SELECT 'private','bms_operation_receipts','bms_operation_receipts',p_document->'operation_receipts'
  LOOP
    IF r.source_schema='auth' AND r.source_name NOT IN ('users','identities','mfa_factors') THEN RAISE EXCEPTION 'Tabel Auth tidak didukung.'; END IF;
    v_source:=format('%I.%I',r.source_schema,r.source_name)::regclass;
    EXECUTE format('CREATE TABLE %I.%I (LIKE %s INCLUDING ALL)',p_target_schema,r.target_name,v_source);
    EXECUTE format('ALTER TABLE %I.%I ENABLE ROW LEVEL SECURITY',p_target_schema,r.target_name);
    EXECUTE format('REVOKE ALL ON %I.%I FROM PUBLIC,anon,authenticated',p_target_schema,r.target_name);
    SELECT string_agg(quote_ident(attname),',' ORDER BY attnum) INTO v_cols FROM pg_attribute WHERE attrelid=v_source AND attnum>0 AND NOT attisdropped AND attgenerated='';
    EXECUTE format('INSERT INTO %I.%I (%s) OVERRIDING SYSTEM VALUE SELECT %s FROM jsonb_populate_recordset(NULL::%I.%I,$1)',p_target_schema,r.target_name,v_cols,v_cols,p_target_schema,r.target_name) USING r.rows;
    v_expected:=jsonb_array_length(r.rows);
    EXECUTE format('SELECT count(*) FROM %I.%I',p_target_schema,r.target_name) INTO v_actual;
    IF v_actual<>v_expected THEN RAISE EXCEPTION 'Jumlah baris tidak sesuai: %',r.target_name; END IF;
    EXECUTE format('SELECT coalesce(jsonb_agg(to_jsonb(x) ORDER BY to_jsonb(x)),''[]''::jsonb) FROM %I.%I x',p_target_schema,r.target_name) INTO v_rows;
    IF v_rows<>r.rows THEN RAISE EXCEPTION 'Nilai data tidak sesuai: %',r.target_name; END IF;
    IF r.source_schema='public' THEN v_restored:=v_restored+1; END IF;
    IF r.source_schema='auth' THEN v_auth_count:=v_auth_count+v_actual; END IF;
  END LOOP;
  -- Restore and validate every FK between restored business/account tables.
  FOR r IN SELECT k.conname,c.relname,n.nspname,pg_get_constraintdef(k.oid) definition FROM pg_constraint k
    JOIN pg_class c ON c.oid=k.conrelid JOIN pg_namespace n ON n.oid=c.relnamespace
    WHERE k.contype='f' AND (n.nspname='public' OR (n.nspname='auth' AND c.relname IN ('users','identities','mfa_factors')))
  LOOP
    v_fk:=replace(replace(replace(r.definition,'auth.users',quote_ident(p_target_schema)||'.auth_users'),'auth.identities',quote_ident(p_target_schema)||'.auth_identities'),'auth.mfa_factors',quote_ident(p_target_schema)||'.auth_mfa_factors');
    v_fk:=replace(v_fk,'REFERENCES public.','REFERENCES '||quote_ident(p_target_schema)||'.');
    v_name:=CASE WHEN r.nspname='auth' THEN 'auth_' ELSE '' END||r.relname;
    EXECUTE format('ALTER TABLE %I.%I ADD CONSTRAINT %I %s',p_target_schema,v_name,r.conname,v_fk);
  END LOOP;
  RETURN jsonb_build_object('passed',true,'public_tables',v_restored,'auth_rows',v_auth_count,'account_values_verified',true,'foreign_keys_verified',true);
END $$;
REVOKE ALL ON FUNCTION private.bms_verify_recovery(jsonb,text) FROM PUBLIC,anon,authenticated;
