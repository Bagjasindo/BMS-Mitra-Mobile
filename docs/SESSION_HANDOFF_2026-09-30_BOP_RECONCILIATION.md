# BOP access and archive reconciliation — 2026-09-30

Read current main and database; do not recreate periods or change Mandiri/Mitra from conversation history.

Closed financial recording access:
- ADMIN can open/lock BOP recording through admin_set_finance_bop_period_access. finance_bop_period_access is RLS protected; authenticated has SELECT only, mutations through checked administrator RPC.
- 7 existing CLOSED assignments have financial BOP access opened per user request. Production stays CLOSED. One active assignment unchanged. Other modules remain locked by guard_assignment_operation.
- Authenticated ADMIN open/lock and KEUANGAN insertion tests passed with rollback. 460 BOP / Rp395,092,815 unchanged; no retained test records.

Latest attachment DATA PETERNAKAN(2).rar was freshly extracted (15 XLSX), rather than relying on earlier extracted copies. Ten Check-in workbooks compared with live database.

Operating ledger totals by period (BOP + separated meat), compared by actual date:
- Baturuyuk June Rp29,838,996 matches.
- Randegan April Rp20,509,575 matches.
- Cicurug June Rp77,542,380 matches.
- Cicurug August Rp105,122,864 matches total, comprising BOP Rp93,602,864 and meat Rp11,520,000.
- Randegan July Rp41,062,000 matches total, comprising BOP Rp30,842,000 and meat Rp10,220,000; internal split needs review: archive meat on Aug15 is Rp3,800,000, while web uses 382kg * Rp10,000 = Rp3,820,000. Other BOP within the same day reduced Rp20,000, masking the category discrepancy in date totals.
- Bantrangsana June Rp54,725,730 and August Rp55,060,900 match.
- Baturuyuk August source Rp33,020,370 vs BOP Rp32,970,370: Sept7 lampu pilot dan pasang Rp50,000 excluded from BOP but maintenance table empty, therefore not recorded in maintenance.
- Cicurug April operating Rp69,766,536 (78 rows) has no matching assignment. Baturuyuk April Rp950,000 (9 rows) has no matching assignment. Do NOT automatically create another Mandiri cycle or reclassify these into existing periods. Historical mapping must be resolved.

Sapronak/payment state:
- Mandiri finals contain Cicurug June sapronak Rp770,405,100 and Randegan April Rp219,494,300. These are imported final summary values, not detailed purchase/payable records: logistics_mandiri_purchases/allocations currently empty.
- Additional outside sapronak Baturuyuk active Sept25: 35zak /1750kg at Rp420,000 per zak = Rp14,700,000, separate from BOP. This dated shipment is later than the archive operating ledger cutoff.
- Four separated meat purchases exist (Cicurug two, Randegan two), but supplier_payments table is empty. Cost is in profit while corresponding payment is not in cash flow. Do not invent paid status/dates; reconcile supporting payment evidence.
- Cicurug June archive SAP ledger credit Rp776,242,600 and RHPP J55 gross Rp777,192,600 differ Rp950,000 before the RHPP retur Rp6,787,500. Web final follows RHPP net Rp770,405,100. Source discrepancy needs review before detailed import.
- Eight advances on Sept28 totaling Rp24,700,000 have description sisa kasbon. Confirm whether historical opening debt balances rather than new cash advances; current cash flow treats them as new cash out. Do not assume they are wages or delete without evidence.
- BOP Umum and Perawatan Kandang currently empty. Thus verification cannot conclude only BOP Umum remains.

No financial transactions changed during reconciliation. Source records and web IDs privately retained in session scratch for further comparison.
