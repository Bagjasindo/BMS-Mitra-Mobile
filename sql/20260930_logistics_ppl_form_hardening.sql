-- 2026-09-30
-- Harden revised LOGISTIK + PPL flows.
-- Main transaction DELETE is ADMIN-only.
-- logistics_shipment_items DELETE remains available to LOGISTIK because
-- save_logistics_shipment_atomic (security invoker) replaces child rows on edit.

drop policy if exists logistics_shipments_delete on public.logistics_shipments;
create policy logistics_shipments_delete
on public.logistics_shipments
for delete
to authenticated
using ((select private.my_bms_role())='ADMIN'::public.bms_role);

drop policy if exists chick_delete on public.chick_ins;
create policy chick_delete
on public.chick_ins
for delete
to authenticated
using ((select private.my_bms_role())='ADMIN'::public.bms_role);

drop policy if exists lcaa_delete on public.logistics_contract_assignment_abks;
create policy lcaa_delete
on public.logistics_contract_assignment_abks
for delete
to authenticated
using ((select private.my_bms_role())='ADMIN'::public.bms_role);
