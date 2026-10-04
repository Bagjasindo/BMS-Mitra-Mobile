"""Build a reviewed schema snapshot from pg_catalog metadata, never row data.
Usage: python scripts/build-schema.py audit-post-catalog.json [--verify]
Verification output is isolated and rolls back all changes.
"""
import json,sys,re
from collections import defaultdict
p=json.load(open(sys.argv[1])); verify='--verify' in sys.argv
mapping={'public':'bms_bootstrap_verify_20261001','private':'bms_bootstrap_private_20261001','bms_backup':'bms_bootstrap_backup_20261001'} if verify else {}
def q(s):return '"'+s.replace('"','""')+'"'
def lit(s):return "'"+s.replace("'","''")+"'"
def ns(s):return mapping.get(s,s)
def table(s,t):return q(ns(s))+'.'+q(t)
def rewrite(s):
 for a,b in mapping.items():s=re.sub(r'\b'+a+r'\.',b+'.',s)
 return s
out=['-- BMS schema snapshot 2026-10-03, build 2343. No business rows or credentials.','-- Fresh Supabase project only. Managed auth/storage schemas must already exist.','BEGIN;','SET LOCAL check_function_bodies = off;']
for s in ['private','bms_backup']+(['public'] if verify else []):out.append('CREATE SCHEMA IF NOT EXISTS '+q(ns(s))+';')
for e in p['enums']:
 out.append('CREATE TYPE '+table('public',e['name'])+' AS ENUM ('+', '.join(map(lit,e['values']))+');')
groups=defaultdict(list)
for c in p['columns']:groups[(c['schema'],c['table'])].append(c)
for (s,t),cols in groups.items():
 lines=[]
 for c in cols:
  v=q(c['name'])+' '+rewrite(c['type'])
  if c['generated']:v+=' GENERATED ALWAYS AS ('+rewrite(c['default'])+') STORED'
  elif c['identity']:v+=' GENERATED '+('ALWAYS' if c['identity']=='a' else 'BY DEFAULT')+' AS IDENTITY'
  elif c['default']:v+=' DEFAULT '+rewrite(c['default'])
  if c['not_null']:v+=' NOT NULL'
  lines.append(v)
 out.append('CREATE TABLE '+table(s,t)+' (\n  '+',\n  '.join(lines)+'\n);')
for f in p['functions']:out.append(rewrite(f['definition']).rstrip()+';')
for v in p['views']:out.append('CREATE VIEW '+table('public',v['name'])+' WITH (security_invoker = true) AS '+rewrite(v['definition']))
for typ in ['p','u','c','x','f']:
 for c in p['constraints']:
  if c['type']==typ and not (verify and typ=='f'):out.append('ALTER TABLE '+table(c['schema'],c['table'])+' ADD CONSTRAINT '+q(c['name'])+' '+rewrite(c['definition'])+';')
for i in p['indexes']:out.append(rewrite(i['definition'])+';')
for t in p['triggers']:out.append(rewrite(t['definition'])+';')
for s,t in groups:out.append('ALTER TABLE '+table(s,t)+' ENABLE ROW LEVEL SECURITY;')
for c in p['policies']:
 if (c['schemaname'],c['tablename']) not in groups:continue
 v='CREATE POLICY '+q(c['policyname'])+' ON '+table(c['schemaname'],c['tablename'])+' AS '+c['permissive']+' FOR '+c['cmd']+' TO '+', '.join(q(r) if r!='public' else 'PUBLIC' for r in c['roles'])
 if c['qual']:v+=' USING ('+rewrite(c['qual'])+')'
 if c['with_check']:v+=' WITH CHECK ('+rewrite(c['with_check'])+')'
 out.append(v+';')
for s in ['public','private','bms_backup']:
 out.append('REVOKE ALL ON ALL TABLES IN SCHEMA '+q(ns(s))+' FROM PUBLIC, anon, authenticated;')
 out.append('REVOKE ALL ON ALL FUNCTIONS IN SCHEMA '+q(ns(s))+' FROM PUBLIC, anon, authenticated, service_role;')
for s in ['public','private']:out.append('GRANT USAGE ON SCHEMA '+q(ns(s))+' TO authenticated, service_role;')
for g in p['grants']:out.append('GRANT '+g['privilege_type']+' ON '+table(g['table_schema'],g['table_name'])+' TO '+q(g['grantee'])+';')
for f in p['functions']:
 # pg_get_function_identity_arguments includes names accepted by GRANT.
 sig=table(f['schema'],f['name'])+'('+rewrite(f['args'])+')'
 for key,role in [('anon_execute','anon'),('authenticated_execute','authenticated'),('service_execute','service_role')]:
  if f[key]:out.append('GRANT EXECUTE ON FUNCTION '+sig+' TO '+role+';')
out.append('GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA '+q(ns('public'))+' TO authenticated, service_role;')
out.append('INSERT INTO '+table('private','bms_rpc_allowlist')+'(function_oid,action) SELECT p.oid::regprocedure,p.proname FROM pg_proc p JOIN pg_namespace n ON n.oid=p.pronamespace WHERE n.nspname='+lit(ns('public'))+' AND p.proname=ANY(ARRAY['+', '.join(map(lit,p['actions']))+']) ON CONFLICT DO NOTHING;')
if verify:
 # Validate that every public table restores all typed values; auth managed references remain intact.
 out.append('DO $verify$ DECLARE c record; names text; BEGIN FOR c IN SELECT tablename FROM pg_tables WHERE schemaname=\'public\' LOOP SELECT string_agg(quote_ident(attname),\',\' ORDER BY attnum) INTO names FROM pg_attribute WHERE attrelid=(\'public.\'||quote_ident(c.tablename))::regclass AND attnum>0 AND NOT attisdropped AND attgenerated=\'\'; EXECUTE format(\'ALTER TABLE bms_bootstrap_verify_20261001.%I DISABLE TRIGGER USER\',c.tablename); EXECUTE format(\'INSERT INTO bms_bootstrap_verify_20261001.%I (%s) OVERRIDING SYSTEM VALUE SELECT %s FROM public.%I\',c.tablename,names,names,c.tablename); END LOOP; END $verify$;')
 # enum values need cast when restoring enum columns across isolated types.
 out[-1]=out[-1].replace('SELECT %s FROM public.%I','SELECT %s FROM public.%I') # replaced below using per-table inserts
 out.pop()
 for (s,t),cols in groups.items():
  if s!='public':continue
  cs=[c for c in cols if not c['generated']]; names=', '.join(q(c['name']) for c in cs)
  vals=', '.join(q(c['name'])+'::text::'+rewrite(c['type']) if c['type'].startswith('public.') else q(c['name']) for c in cs)
  out.extend(['ALTER TABLE '+table(s,t)+' DISABLE TRIGGER USER;','INSERT INTO '+table(s,t)+' ('+names+') OVERRIDING SYSTEM VALUE SELECT '+vals+' FROM '+q(s)+'.'+q(t)+';'])
 for c in p['constraints']:
  if c['type']=='f':out.append('ALTER TABLE '+table(c['schema'],c['table'])+' ADD CONSTRAINT '+q(c['name'])+' '+rewrite(c['definition'])+';')
 out.append('SELECT count(*) AS restored_tables FROM pg_tables WHERE schemaname='+lit(ns('public'))+';')
 out.append('ROLLBACK;')
else:out.append('COMMIT;')
path='repair/verify-bootstrap.sql' if verify else 'supabase/schema_current.sql'
open(path,'w').write('\n\n'.join(out)+'\n');print(path,len(out))
