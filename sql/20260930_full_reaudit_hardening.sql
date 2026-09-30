-- 2026-09-30 Full re-audit hardening
-- Preserve all business flows; harden transaction DELETE and anonymous RPC access.

drop policy if exists bop_assignment_delete on public.bop;
create policy bop_assignment_delete on public.bop for delete to authenticated
using ((select private.my_bms_role())='ADMIN'::public.bms_role);

drop policy if exists external_shipments_delete on public.logistics_external_shipments;
create policy external_shipments_delete on public.logistics_external_shipments for delete to authenticated
using ((select private.my_bms_role())='ADMIN'::public.bms_role);

drop policy if exists logistics_returns_delete on public.logistics_returns;
create policy logistics_returns_delete on public.logistics_returns for delete to authenticated
using ((select private.my_bms_role())='ADMIN'::public.bms_role);

drop policy if exists external_returns_delete on public.logistics_external_returns;
create policy external_returns_delete on public.logistics_external_returns for delete to authenticated
using ((select private.my_bms_role())='ADMIN'::public.bms_role);

drop policy if exists marketing_contract_harvest_delete on public.marketing_contract_harvests;
create policy marketing_contract_harvest_delete on public.marketing_contract_harvests for delete to authenticated
using ((select private.my_bms_role())='ADMIN'::public.bms_role);

drop policy if exists marketing_external_meat_delete on public.marketing_external_meat_purchases;
create policy marketing_external_meat_delete on public.marketing_external_meat_purchases for delete to authenticated
using ((select private.my_bms_role())='ADMIN'::public.bms_role);

drop policy if exists prod_abk_delete on public.production_abk_results;
create policy prod_abk_delete on public.production_abk_results for delete to authenticated
using ((select private.my_bms_role())='ADMIN'::public.bms_role);

drop policy if exists prod_est_delete on public.production_estimates;
create policy prod_est_delete on public.production_estimates for delete to authenticated
using ((select private.my_bms_role())='ADMIN'::public.bms_role);

drop policy if exists recording_delete on public.recordings;
create policy recording_delete on public.recordings for delete to authenticated
using ((select private.my_bms_role())='ADMIN'::public.bms_role);

drop policy if exists visit_delete on public.visits;
create policy visit_delete on public.visits for delete to authenticated
using ((select private.my_bms_role())='ADMIN'::public.bms_role);

revoke execute on function public.finance_pay_mandiri_supplier_atomic(uuid,date,numeric,text,text,text) from public, anon;
grant execute on function public.finance_pay_mandiri_supplier_atomic(uuid,date,numeric,text,text,text) to authenticated;

revoke execute on function public.log_user_activity(text,text,text,jsonb) from public, anon;
grant execute on function public.log_user_activity(text,text,text,jsonb) to authenticated;

revoke execute on function public.production_feed_stock_as_of(uuid,date) from public, anon;
grant execute on function public.production_feed_stock_as_of(uuid,date) to authenticated;
