-- 2026-09-30
-- Global UI / CRUD audit fix:
-- Admin -> Arsip Data exports finance_reference_counters.
-- Keep the table hidden from every non-admin role and do not grant direct writes.

drop policy if exists finance_reference_counters_admin_read
on public.finance_reference_counters;

create policy finance_reference_counters_admin_read
on public.finance_reference_counters
for select
to authenticated
using (private.my_bms_role() = 'ADMIN'::public.bms_role);
