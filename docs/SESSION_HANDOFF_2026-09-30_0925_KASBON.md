# Latest finance checkpoint — 2026-09-30 after 09:20 WIB

Read together with 0855 handoff. Current database changes:
- Cicurug June remains MANDIRI. User authorised reopening to align AMIR July 14 transaction (174.5 kg): market_price_per_kg 19500 -> 19000, market_total_amount 3402750 -> 3315500. Existing price_per_kg/total_amount already matched RHPP. Receipt ID, amount 3315500 and date July 15 preserved. Period remains ACTIVE after administrator reopen; production_mandiri_final remains harvest_value 1005235250 and sapronak_cost 770405100. IMPORTANT: finance_cycle_profit_loss_v2 uses final snapshot only when inactive, so reopened period needs closing after corrections to retain final-cost reporting. Do not claim profit unchanged solely from unchanged final table.
- This price discrepancy is Rp87,250, NOT the unresolved Rp950,000 SAP-vs-RHPP gross discrepancy. Original sales worksheet row35 says 19500; RHPP I44 says 19000; receipt group 30274250 agrees with RHPP.
- Baturuyuk maintenance: 50000, September7, Lampu pilot dan pasang, PENGGANTIAN_KOMPONEN, barn-only (assignment null). Source Operasional row45, Check in Agustus 2026 BMS 2.xlsx. Reference MIG-BAT-20260907-PILOT; row 5ea8202b-f8c6-46b3-9f9d-3bf5a605d630. paid_by uses existing COMPANY default, payer not independently verified.

Kasbon authorised adjustment:
User confirmed September28 entries represent remaining old debt, not new cash advances. Source photos September28 15.38.42 and 15.42.33 inspected; Duda=Jayana, Emong=Kusman confirmed by user.
8 existing balances verified: Burhanudin 10700000; Gugun Gunawan 2000000; Maman Sunaman 4500000; Sahri 2500000; Toto 2000000; Jayana 1300000; Nandar 100000; Kusman 1600000. Total 24700000.
Migration advance_historical_balance_cashflow adds advances.is_historical_balance boolean NOT NULL default false. Only those eight confirmed rows marked true, with old/new audit_events. finance_cashflow_entries_v1 filters historical advances from KASBON cash out; v2 inherits. Debt balance/payment functions unchanged. New advances still cash out by default. No frontend selector yet.
Verification authorised ADMIN: debt balance remains 24700000; September28 KASBON cash out zero. Transactional 100000 payment test reduced Jayana to1200000 and generated cash in100000; rolled back, actual Jayana remains1300000.
Photo also contains Paris remaining1500000 and unidentified Piutang Karyawan (Upah Gemuk) remaining500000, absent from employees/advances; not created without identity clarification. Thus full photo total would be26700000 if both are separate valid debts. Ask for real account identity, especially Upah Gemuk. Do not assume these are already in24700000.
Outstanding other items from0855 continue unchanged. SQL committed sql/20260930_advance_historical_balance.sql.
