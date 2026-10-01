-- A16: preserve the existing permissive OR semantics, with one policy per action.
SET LOCAL search_path='';
CREATE TEMP TABLE bms_policy_before ON COMMIT DROP AS SELECT * FROM pg_policies WHERE schemaname='public';
DO $$
DECLARE r record; v_cmd text; v_using text; v_check text; v_n integer; v_sql text;
BEGIN
  IF EXISTS(SELECT 1 FROM pg_temp.bms_policy_before WHERE permissive<>'PERMISSIVE' OR NOT roles<@ARRAY['public','authenticated']::name[]) THEN
    RAISE EXCEPTION 'Unexpected policy roles/type; review before consolidation.';
  END IF;
  FOR r IN SELECT tablename,policyname FROM pg_temp.bms_policy_before LOOP
    EXECUTE format('DROP POLICY %I ON public.%I',r.policyname,r.tablename);
  END LOOP;
  FOR r IN SELECT DISTINCT tablename FROM pg_temp.bms_policy_before LOOP
    FOREACH v_cmd IN ARRAY ARRAY['SELECT','INSERT','UPDATE','DELETE'] LOOP
      SELECT count(*),string_agg('('||coalesce(qual,'true')||')',' OR ' ORDER BY policyname),
        string_agg('('||coalesce(with_check,qual,'true')||')',' OR ' ORDER BY policyname)
      INTO v_n,v_using,v_check FROM pg_temp.bms_policy_before WHERE tablename=r.tablename AND cmd IN ('ALL',v_cmd);
      IF v_n=0 THEN CONTINUE; END IF;
      v_using:=replace(v_using,'auth.uid()','(SELECT auth.uid())');
      v_check:=replace(v_check,'auth.uid()','(SELECT auth.uid())');
      v_sql:=format('CREATE POLICY %I ON public.%I FOR %s TO authenticated','bms_'||lower(v_cmd),r.tablename,v_cmd);
      IF v_cmd IN ('SELECT','UPDATE','DELETE') THEN v_sql:=v_sql||' USING ('||v_using||')'; END IF;
      IF v_cmd IN ('INSERT','UPDATE') THEN v_sql:=v_sql||' WITH CHECK ('||v_check||')'; END IF;
      EXECUTE v_sql;
    END LOOP;
  END LOOP;
END $$;
DO $$
DECLARE r record; cols text; v_index text;
BEGIN
  FOR r IN SELECT k.oid,k.conrelid,k.conname,k.conkey,c.relname
    FROM pg_constraint k JOIN pg_class c ON c.oid=k.conrelid JOIN pg_namespace n ON n.oid=c.relnamespace
    WHERE n.nspname='public' AND k.contype='f' AND NOT EXISTS(
      SELECT 1 FROM pg_index i WHERE i.indrelid=k.conrelid AND i.indisvalid AND i.indpred IS NULL
        AND (i.indkey::smallint[])[0:cardinality(k.conkey)-1]=k.conkey
    )
  LOOP
    SELECT string_agg(quote_ident(a.attname),',' ORDER BY x.ord) INTO cols FROM unnest(r.conkey) WITH ORDINALITY x(attnum,ord) JOIN pg_attribute a ON a.attrelid=r.conrelid AND a.attnum=x.attnum;
    v_index:='bms_fk_'||left(r.relname,25)||'_'||substr(md5(r.conname),1,12);
    EXECUTE format('CREATE INDEX IF NOT EXISTS %I ON public.%I (%s)',v_index,r.relname,cols);
  END LOOP;
END $$;
