-- RHPP REAL SOURCE LOCK
-- Date: 2026-09-29
-- Source of truth:
--   LOGISTIK  = Chick-In + Sapronak real
--   MARKETING = Panen real
--   RECORDING PPL = monitoring only, excluded from RHPP
--
-- This patch removes public.recordings from finance_rhpp_summary_v3
-- and keeps mortality/depletion derived from real Chick-In vs real Chick-Out.

do $$
declare d text;
begin
  select pg_get_functiondef(p.oid) into d
  from pg_proc p
  join pg_namespace n on n.oid=p.pronamespace
  where n.nspname='public'
    and p.proname='finance_rhpp_summary_v3'
  limit 1;

  d := replace(d,
'  rec_dep as (
    select r.contract_assignment_id,coalesce(sum(r.mortality+r.culling),0)::numeric birds
    from public.recordings r group by r.contract_assignment_id
  ),
','');

  d := replace(d,
'      ((ci.received-ci.doa)-coalesce(h.birds,0))::numeric implied_depletion_birds,
      coalesce(rd.birds,0)::numeric recorded_depletion_birds,
      (((ci.received-ci.doa)-coalesce(h.birds,0))-coalesce(rd.birds,0))::numeric depletion_variance_birds,
      case when (ci.received-ci.doa)>0 then (coalesce(rd.birds,0)/(ci.received-ci.doa))*100 else 0 end::numeric mortality_pct,',
'      ((ci.received-ci.doa)-coalesce(h.birds,0))::numeric implied_depletion_birds,
      ((ci.received-ci.doa)-coalesce(h.birds,0))::numeric recorded_depletion_birds,
      0::numeric depletion_variance_birds,
      case when (ci.received-ci.doa)>0 then (((ci.received-ci.doa)-coalesce(h.birds,0))/(ci.received-ci.doa))*100 else 0 end::numeric mortality_pct,');

  d := replace(d,
'    left join meat me on me.contract_assignment_id=a.id
    left join rec_dep rd on rd.contract_assignment_id=a.id',
'    left join meat me on me.contract_assignment_id=a.id');

  execute d;
end $$;

do $$
declare d text;
begin
  select pg_get_functiondef(p.oid) into d
  from pg_proc p
  join pg_namespace n on n.oid=p.pronamespace
  where n.nspname='public'
    and p.proname='finance_rhpp_summary_v5'
  limit 1;

  d := replace(d,
'      case
        when not x.active
          then greatest(coalesce(x.implied_depletion_birds,0),0)
        else 0
      end::numeric as effective_depletion_birds',
'      greatest(coalesce(x.implied_depletion_birds,0),0)::numeric as effective_depletion_birds');

  execute d;
end $$;
