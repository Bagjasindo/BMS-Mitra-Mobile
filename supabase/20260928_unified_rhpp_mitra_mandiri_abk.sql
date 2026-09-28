-- 2026-09-28
-- Unified final production source for MITRA + MANDIRI.
-- Keeps cycle identity visible but provides one cumulative source for reports.
-- Also allows assigned PPL to read RHPP final for their own MITRA cycles.

create or replace view public.production_cycle_final_unified
with (security_invoker=true)
as
select
  sf.contract_assignment_id,
  sf.barn_id,
  'MITRA'::text as cycle_type,
  a.performance_template_name,
  sf.id as final_id,
  sf.system_amount,
  sf.harvest_value,
  sf.sapronak_cost,
  sf.external_meat_cost,
  sf.bonus_ip,
  sf.bonus_fc,
  sf.bonus_depletion,
  sf.fcr_actual,
  sf.fcr_standard,
  sf.ip,
  sf.mortality_pct,
  sf.population_variance_birds,
  sf.closed_on,
  sf.created_at,
  sf.chick_in_birds,
  sf.total_harvest_birds,
  sf.total_harvest_kg,
  sf.avg_bw_kg,
  sf.weighted_age,
  sf.depletion_birds,
  sf.net_feed_kg,
  sf.main_doc_cost,
  sf.main_feed_cost,
  sf.main_ovk_cost,
  sf.main_other_cost,
  sf.main_return_cost,
  sf.external_sapronak_cost,
  sf.total_rhpp_cost,
  sf.base_profit,
  sf.bonus_ip_rate,
  sf.bonus_fc_rate,
  sf.bonus_depletion_rate,
  sf.profit_per_chick_in,
  sf.profit_per_harvested_bird,
  sf.std_bw_kg,
  sf.chick_in_date,
  null::text as source_reference
from public.rhpp_system_final sf
join public.logistics_contract_assignments a
  on a.id=sf.contract_assignment_id
where a.cycle_type='MITRA'

union all

select
  mf.contract_assignment_id,
  mf.barn_id,
  'MANDIRI'::text as cycle_type,
  a.performance_template_name,
  mf.contract_assignment_id as final_id,
  (coalesce(mf.harvest_value,0)-coalesce(mf.sapronak_cost,0))::numeric as system_amount,
  mf.harvest_value,
  mf.sapronak_cost,
  0::numeric as external_meat_cost,
  0::numeric as bonus_ip,
  0::numeric as bonus_fc,
  0::numeric as bonus_depletion,
  mf.fcr_actual,
  null::numeric as fcr_standard,
  mf.ip,
  case when coalesce(mf.chick_in_birds,0)>0
       then coalesce(mf.depletion_birds,0)/mf.chick_in_birds*100
       else 0 end::numeric as mortality_pct,
  0::numeric as population_variance_birds,
  mf.closed_on,
  mf.created_at,
  mf.chick_in_birds,
  mf.total_harvest_birds,
  mf.total_harvest_kg,
  mf.avg_bw_kg,
  mf.weighted_age,
  mf.depletion_birds,
  mf.net_feed_kg,
  null::numeric as main_doc_cost,
  null::numeric as main_feed_cost,
  null::numeric as main_ovk_cost,
  null::numeric as main_other_cost,
  0::numeric as main_return_cost,
  mf.sapronak_cost as external_sapronak_cost,
  mf.sapronak_cost as total_rhpp_cost,
  (coalesce(mf.harvest_value,0)-coalesce(mf.sapronak_cost,0))::numeric as base_profit,
  0::numeric as bonus_ip_rate,
  0::numeric as bonus_fc_rate,
  0::numeric as bonus_depletion_rate,
  case when coalesce(mf.chick_in_birds,0)>0
       then (coalesce(mf.harvest_value,0)-coalesce(mf.sapronak_cost,0))/mf.chick_in_birds
       else 0 end::numeric as profit_per_chick_in,
  case when coalesce(mf.total_harvest_birds,0)>0
       then (coalesce(mf.harvest_value,0)-coalesce(mf.sapronak_cost,0))/mf.total_harvest_birds
       else 0 end::numeric as profit_per_harvested_bird,
  null::numeric as std_bw_kg,
  ci.arrived_on as chick_in_date,
  mf.source_reference
from public.production_mandiri_final mf
join public.logistics_contract_assignments a
  on a.id=mf.contract_assignment_id
left join public.chick_ins ci
  on ci.contract_assignment_id=mf.contract_assignment_id
where a.cycle_type='MANDIRI';

grant select on public.production_cycle_final_unified to authenticated;

drop policy if exists rhpp_system_final_read on public.rhpp_system_final;

create policy rhpp_system_final_read
on public.rhpp_system_final
for select
to authenticated
using (
  exists (
    select 1
    from public.profiles p
    where p.user_id=(select auth.uid())
      and p.active
      and (
        p.role in ('ADMIN','KEUANGAN','OWNER')
        or (
          p.role='PPL'
          and exists (
            select 1
            from public.logistics_contract_assignments a
            where a.id=rhpp_system_final.contract_assignment_id
              and a.ppl_id=(select auth.uid())
          )
        )
      )
  )
);
