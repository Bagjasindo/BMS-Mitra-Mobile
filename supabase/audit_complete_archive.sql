-- A06/A10: catalogue-driven data snapshot in one SQL statement.
CREATE OR REPLACE FUNCTION private.bms_archive_document() RETURNS jsonb
LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$
DECLARE r record; v_sql text:=''; v_tables jsonb; v_counts jsonb; v_schema text;
BEGIN
  FOR r IN SELECT c.relname FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace
    WHERE n.nspname='public' AND c.relkind='r' ORDER BY c.relname
  LOOP
    v_sql:=v_sql||CASE WHEN v_sql='' THEN '' ELSE ' UNION ALL ' END||format(
      'SELECT %L::text name,coalesce(jsonb_agg(to_jsonb(x) ORDER BY to_jsonb(x)),''[]''::jsonb) rows,count(*) n FROM public.%I x',r.relname,r.relname);
  END LOOP;
  EXECUTE 'SELECT jsonb_object_agg(name,rows),jsonb_object_agg(name,n) FROM ('||v_sql||') all_tables' INTO v_tables,v_counts;
  SELECT encode(extensions.digest(coalesce(string_agg(table_name||':'||column_name||':'||udt_name||':'||is_nullable,'|' ORDER BY table_name,ordinal_position),''),'sha256'),'hex') INTO v_schema
  FROM information_schema.columns WHERE table_schema='public';
  RETURN jsonb_build_object('format','BMS_DATA_ARCHIVE','format_version',1,'generated_at',now(),
    'table_count',(SELECT count(*) FROM jsonb_object_keys(v_tables)),'row_counts',v_counts,'schema_fingerprint',v_schema,
    'checksum',encode(extensions.digest(v_tables::text,'sha256'),'hex'),'tables',v_tables);
END $$;

REVOKE ALL ON FUNCTION private.bms_archive_document() FROM PUBLIC,anon,authenticated;
CREATE OR REPLACE FUNCTION public.bms_export_archive() RETURNS jsonb
LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$
BEGIN
 IF NOT EXISTS(SELECT 1 FROM public.profiles WHERE user_id=auth.uid() AND active AND role='ADMIN') THEN
  RAISE EXCEPTION 'Hanya Administrator aktif yang dapat mengekspor seluruh data.' USING ERRCODE='42501';
 END IF;
 RETURN private.bms_archive_document();
END $$;
REVOKE ALL ON FUNCTION public.bms_export_archive() FROM PUBLIC,anon;
GRANT EXECUTE ON FUNCTION public.bms_export_archive() TO authenticated;
CREATE OR REPLACE FUNCTION bms_backup.create_daily_snapshot() RETURNS uuid
LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$
DECLARE v_document jsonb; v_id uuid; v_date date:=(now() AT TIME ZONE 'Asia/Jakarta')::date;
BEGIN
 v_document:=private.bms_archive_document();
 INSERT INTO bms_backup.daily_snapshots(backup_date,table_count,row_counts,payload,checksum)
 VALUES(v_date,(v_document->>'table_count')::integer,v_document->'row_counts',v_document->'tables',v_document->>'checksum')
 ON CONFLICT(backup_date) DO UPDATE SET created_at=now(),table_count=excluded.table_count,row_counts=excluded.row_counts,payload=excluded.payload,checksum=excluded.checksum
 RETURNING id INTO v_id;
 RETURN v_id;
END $$;
REVOKE ALL ON FUNCTION bms_backup.create_daily_snapshot() FROM PUBLIC,anon,authenticated;
