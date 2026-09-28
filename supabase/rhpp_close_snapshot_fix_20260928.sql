-- RHPP close snapshot fix 2026-09-28
-- Applied to Supabase project mqqrfhwqgcpkjeaasdsr.
-- Purpose:
-- 1) mortality comes from PPL recordings, never Chick-In minus Chick-Out;
-- 2) Close Mitra freezes recorded depletion;
-- 3) Close Mandiri freezes mortality_pct;
-- 4) unified closed view reads the frozen mortality field;
-- 5) unified view executes with caller permissions (security_invoker).

begin;

do $$
declare d text;
begin
  select pg_get_functiondef(p.oid) into d
  from pg_proc p join pg_namespace n on n.oid=p.pronamespace
  where n.nspname='public' and p.proname='finance_rhpp_summary_v5'
  limit 1;

  d := replace(
    d,
    'case
        when not x.active
          then greatest(coalesce(x.implied_depletion_birds,0),0)
        else 0
      end::numeric as effective_depletion_birds',
    'greatest(coalesce(x.recorded_depletion_birds,0),0)::numeric as effective_depletion_birds'
  );
  execute d;
end $$;

do $$
declare d text;
begin
  select pg_get_functiondef(p.oid) into d
  from pg_proc p join pg_namespace n on n.oid=p.pronamespace
  where n.nspname='public' and p.proname='admin_close_production_atomic'
  limit 1;

  d := replace(
    d,
    'greatest(v.chick_in_birds-v.total_harvest_birds,0),v.net_feed_kg',
    'greatest(coalesce(v.recorded_depletion_birds,0),0),v.net_feed_kg'
  );
  execute d;
end $$;

alter table public.production_mandiri_final
  add column if not exists mortality_pct numeric;

update public.production_mandiri_final
set mortality_pct = case
  when coalesce(chick_in_birds,0)>0
    then coalesce(depletion_birds,0)/chick_in_birds*100
  else 0
end
where mortality_pct is null;

alter table public.production_mandiri_final
  alter column mortality_pct set default 0;

do $$
declare d text;
begin
  select pg_get_functiondef(p.oid) into d
  from pg_proc p join pg_namespace n on n.oid=p.pronamespace
  where n.nspname='public' and p.proname='admin_close_mandiri_cycle_atomic'
  limit 1;

  d := replace(
    d,
    'avg_bw_kg,weighted_age,net_feed_kg,fcr_actual,ip,',
    'avg_bw_kg,weighted_age,net_feed_kg,fcr_actual,ip,mortality_pct,'
  );
  d := replace(
    d,
    'coalesce(s.net_feed_kg,0),coalesce(s.fcr_actual,0),coalesce(s.ip,0),',
    'coalesce(s.net_feed_kg,0),coalesce(s.fcr_actual,0),coalesce(s.ip,0),coalesce(s.mortality_pct,0),'
  );
  execute d;
end $$;

-- The live database view was recreated with mf.mortality_pct as the Mandiri source.
-- Keep the view as security invoker so underlying RLS is honored.
alter view public.production_cycle_final_unified set (security_invoker = true);

commit;
