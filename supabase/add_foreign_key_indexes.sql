-- Adds covering indexes for foreign keys reported by Supabase database advisor.
create index if not exists idx_advance_payments_advance_id on public.advance_payments(advance_id);
create index if not exists idx_advances_employee_id on public.advances(employee_id);
create index if not exists idx_bop_cycle_id on public.bop(cycle_id);
create index if not exists idx_contract_bonuses_contract_id on public.contract_bonuses(contract_id);
create index if not exists idx_cycles_abk_id on public.cycles(abk_id);
create index if not exists idx_cycles_ppl_id on public.cycles(ppl_id);
create index if not exists idx_expeditions_cycle_id on public.expeditions(cycle_id);
create index if not exists idx_harvests_cycle_id on public.harvests(cycle_id);
create index if not exists idx_recordings_feed_item_id on public.recordings(feed_item_id);
create index if not exists idx_rhpp_estimates_created_by on public.rhpp_estimates(created_by);
create index if not exists idx_rhpp_estimates_cycle_id on public.rhpp_estimates(cycle_id);
create index if not exists idx_rhpp_real_created_by on public.rhpp_real(created_by);
create index if not exists idx_supplies_created_by on public.supplies(created_by);
create index if not exists idx_supplies_cycle_id on public.supplies(cycle_id);
create index if not exists idx_supplies_item_id on public.supplies(item_id);
create index if not exists idx_visits_cycle_id on public.visits(cycle_id);
