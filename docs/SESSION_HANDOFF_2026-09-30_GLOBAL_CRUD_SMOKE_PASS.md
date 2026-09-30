# BMS AUDIT HANDOFF — 2026-09-30 18:xx WIB

## Scope
Completed only:
1. Global UI audit
2. Final CRUD/backend guard audit
3. Data/formula smoke-check

Do not repeat previously PASS role audits or old Excel reconciliation.

## Global UI
- visibleTabs vs routing: no visible tab without a render path.
- Read-only master tabs shown to PPL/MARKETING remain read-only by design.
- Found one real issue: Admin -> Arsip Data includes `finance_reference_counters`, but the table had RLS enabled with no SELECT policy, so full export could fail.
- Fixed live DB with ADMIN-only SELECT policy.
- SQL committed: `sql/20260930_finance_reference_counter_archive_read.sql`
- Commit: `b949e20fba6353f61986837dedb5193aaef87224`
- Verification: ADMIN sees 16 counter rows; OWNER sees 0.

## CRUD/backend final
- All 26 main transaction tables checked have `trg_admin_only_delete` / `private.admin_only_transaction_delete()`.
- Direct KEUANGAN DELETE against BOP was rejected with "Hanya ADMIN yang boleh menghapus transaksi."
- OWNER direct UPDATE against BOP returned no writable rows.
- PPL direct UPDATE against a closed recording returned no writable rows.
- OWNER can read finance cycle/global report functions.
- Public views checked use `security_invoker=true`.
- Security advisor still reports SECURITY DEFINER exposure warnings for existing RPCs. Spot-checked critical functions include explicit `auth.uid()` + role checks, so no functional privilege escalation was found in this audit.
- `finance_expedition_invoice_counters` and `production_feed_stock_adjustments` remain internal tables with RLS/no direct policies and no authenticated/anon table ACL; intentional.
- `finance_reference_counters` now has ADMIN SELECT only for archive export.

## Smoke-check data/formulas
Live DB checks:
- finance_cycle_profit_loss_v2 formula mismatch: 0
- finance_company_profit_loss_v2 global formula diff: 0
- stock invoices: 7
- BELI UNTUK STOK cashflow rows: 7
- stock invoice sum: Rp18.781.000
- stock cashflow sum: Rp18.781.000
- supplier overpaid: 0
- expedition overpaid: 0
- Mandiri overpaid: 0
- deleted test Toko bandung / invoice 9836-8346: 0
- deleted test IGM stock: 0
- deleted test shipment ref afqe: 0
- active cycles: 1

Important: one active cycle remains, so do not claim final global operational results for active-period SAP/production until the period is actually final.

## Result
Global UI + CRUD/backend + smoke-check: PASS after one ADMIN archive-read fix.
