# Finance handoff — 2026-09-30

Scope: simple running cash flow and profit/loss. Do not require or invent opening balances. Do not delete or reclassify historical transactions automatically.

Implemented:
- Cash summary labelled Selisih Kas Periode; it is net movement for the selected dates.
- New RHPP Real input accepts actual receipt date and reference.
- BOP Produksi, BOP Umum and Perawatan Kandang have paid_by COMPANY/OWNER, reference inputs, duplicate-reference check within each room, and destination confirmation.
- Direct OWNER expenses remain in profit/loss but are excluded from company cash flow; shown separately in cash summary and marked in expense histories. This flag currently covers only these three expense tables, not supplier/expedition payments.
- Historical records default to COMPANY to retain existing results; this is not a verified claim about historical payment origin. Finance must review source evidence before changing payment origin.
- Salary-linked BOP entries must be corrected through source salary transactions for owner-paid changes.
- Existing max(uuid) runtime error in finance_cashflow_entries_v2 fixed using text aggregation and UUID cast.

Verification:
- JavaScript syntax passed.
- Database cash-flow and cycle-profit functions executed with authorised ADMIN context.
- Transactional tests: marking active BOP OWNER removes its amount from company cash out while leaving cycle profit unchanged; changing general expense OWNER to COMPANY adds cash out exactly once. All test mutations rolled back.
- Historical BOP remains 460 records / Rp395,092,815. No test records retained.

Outstanding data completeness:
- BOP Umum and barn_maintenance_costs were empty at verification. Profit totals therefore remain incomplete until finance reviews and inputs supported expenses.
- Reference duplicate check is per-room frontend validation, not a global unique constraint or full Excel reconciliation.
- Live signed-in browser flow has not been verified this turn.

Database SQL: sql/20260930_finance_simple_cash_owner_payment_origin.sql. Database migration history includes finance_simple_cash_owner_payment_origin and fix_finance_cashflow_mandiri_uuid_aggregation.
