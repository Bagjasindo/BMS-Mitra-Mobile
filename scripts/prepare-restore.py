"""Generate operator-only recovery SQL for a FRESH project, never overwrite production.
Usage: python scripts/prepare-restore.py protected-recovery.json protected-restore.sql
The SQL must run via psql as database owner, not via the application API.
"""
import json,os,sys
src,dst=sys.argv[1:]
p=json.load(open(src))
assert p['format']=='BMS_FULL_RECOVERY' and p['recovery_version']==1
assert len(p['tables'])==p['table_count']
for name in list(p['tables'])+list(p['auth']):assert name.replace('_','').isalnum()
body=json.dumps(p,ensure_ascii=False);tag='$bms_recovery$';assert tag not in body
sql="""\\set ON_ERROR_STOP on
BEGIN;
DO $guard$ DECLARE r record; n bigint; BEGIN
 IF EXISTS(SELECT 1 FROM auth.users) THEN RAISE EXCEPTION 'Restore requires a fresh project: auth users already exist'; END IF;
 FOR r IN SELECT tablename FROM pg_tables WHERE schemaname='public' LOOP
 EXECUTE format('SELECT count(*) FROM public.%I',r.tablename) INTO n;
 IF n>0 THEN RAISE EXCEPTION 'Restore requires all business tables empty: %',r.tablename; END IF;
 END LOOP;
END $guard$;
CREATE TEMP TABLE bms_restore_input(document jsonb);
"""
sql+='INSERT INTO bms_restore_input VALUES ('+tag+body+tag+'::jsonb);\n'
sql+="""SELECT private.bms_verify_recovery(document,'bms_restore_verify_prerestore') FROM bms_restore_input;
-- The verified clone includes all values and validated FKs before touching target tables.
SET LOCAL session_replication_role=replica;
DO $restore$ DECLARE r record; cols text; rows jsonb; BEGIN
 FOR r IN SELECT 'auth' s,key t,value v FROM bms_restore_input,jsonb_each(document->'auth')
 UNION ALL SELECT 'public',key,value FROM bms_restore_input,jsonb_each(document->'tables')
 UNION ALL SELECT 'private','bms_operation_receipts',document->'operation_receipts' FROM bms_restore_input LOOP
 SELECT string_agg(quote_ident(attname),',' ORDER BY attnum) INTO cols FROM pg_attribute WHERE attrelid=format('%I.%I',r.s,r.t)::regclass AND attnum>0 AND NOT attisdropped AND attgenerated='';
 EXECUTE format('INSERT INTO %I.%I (%s) OVERRIDING SYSTEM VALUE SELECT %s FROM jsonb_populate_recordset(NULL::%I.%I,$1)',r.s,r.t,cols,cols,r.s,r.t) USING r.v;
 END LOOP;
END $restore$;
SET LOCAL session_replication_role=origin;
DO $sequences$ DECLARE r record; seq text; maximum bigint; BEGIN
 FOR r IN SELECT table_schema,table_name,column_name FROM information_schema.columns WHERE table_schema='public' AND is_identity='YES' LOOP
 seq:=pg_get_serial_sequence(format('%I.%I',r.table_schema,r.table_name),r.column_name);
 EXECUTE format('SELECT max(%I) FROM %I.%I',r.column_name,r.table_schema,r.table_name) INTO maximum;
 PERFORM setval(seq,greatest(coalesce(maximum,1),1),maximum IS NOT NULL);
 END LOOP;
END $sequences$;
DROP SCHEMA bms_restore_verify_prerestore CASCADE;
COMMIT;
"""
fd=os.open(dst,os.O_WRONLY|os.O_CREAT|os.O_EXCL,0o600)
with os.fdopen(fd,'w') as f:f.write(sql)
print('Recovery SQL prepared for a fresh project. Contains confidential account hashes; keep private.')
