# TITIK LANJUT TERBARU — 30 September 2026 sekitar10:15 WIB

## Baca ini pertama di chat baru
Repo Bagjasindo/BMS-Mitra-Mobile, branch main. Source main-1958.js, loader index.html cache2223-bop-office-scope. Supabase project mqqrfhwqgcpkjeaasdsr. Ambil current main dan baca database sebelum perubahan; jangan ulang import dari histori chat. User meminta menyimpan titik ini untuk lanjut chat biasa.

## Arahan user terkunci sesi ini
1. Nama kandang yang tertulis di uraian/catatan menjadi patokan utama tujuan; kode BMS hanya fallback jika tidak ada nama. Fallback BMS1Cicurug,2Baturuyuk,3Randegan,4Bantrangsana.
2. BOP Umum satu menu, jenis Kantor/Luar Kantor, kategori pendek. Seragam/jersey di Lainnya. Peringatan salah kamar sebelum simpan.
3. Seluruh6 rekap gaji adalah staf kantor, bukan gajiABK. Tanggal10 pada bulan gaji. ABK tetap di BOP Produksi. User mengizinkan revisi kemudian jika sumber berubah.
4. Indihome Cicurug masuk Perawatan Kandang tanpa siklus; user menolak pengaitan periode karena pembayaran rutin tidak selalu cocok siklus.
5. Upah Mangdelon dibagi rata4 kandang dengan catatan jelas, termasuk sumber yang tadinya menyebut satu kandang (instruksi khusus eksplisit). Total tidak digandakan.
6. Biaya angkut GROUP dibagi4. Pembelian bersama2 kandang pada batch terakhir dibagi rata ke2 kandang yang disebut, sesuai proposal dan instruksi lanjut user; catatan50% jelas.
7. Perawatan tetap berjalan meskipun tidak produksi/CLOSED, assignment null. Jangan mengubah Mandiri/Mitra.
8. Sisa kasbon adalah piutang lama; bukan pengeluaran baru tanggal28September. Duda=Jayana, Emong=Kusman.

## Kondisi database TERAKHIR terverifikasi
- bop_outside77 rows Rp200243659.
- barn_maintenance_costs171 rows Rp122690062, seluruh batch baru tanpa siklus.
- advance_balances8 rows Rp24700000; delapan advances.is_historical_balance=true; kas keluar KASBON Sept28=0. Pembayaran tetap mengurangi piutang dan tercatat cash in; test100000Jayana dibatalkan.
- Tidak berarti seluruh283transaksi Excel sudah dipindah. Sebagian source masih ditahan atau sudah tercatat melalui RHPP/rekap sumber lain.

## Batch masuk, jangan diulang
A. BOP Umum77 transaksi200243659: Gaji181534280(6); Insentif1132493(1); ATK154500(2); Konsumsi1113500(11); Langganan1332700(3); BBM4223186(33); Servis2362000(11); Pajak1951000(2); Sumbangan2800000(6); Lainnya3640000(2jersey). Referensi BB-id, uraian/tanggal asli di notes. SalaryMay sourceMay11 ->May10; SalaryJuly sourceMay10 ->July10. Scope assignments berdasarkan sifat biaya. Lihat0958 handoff.
B. Lampu pilotBaturuyuk Sept7 50000 referenceMIG-BAT-20260907-PILOT.
C. IndihomeCicurug May19 337440 referenceBB-64 categoryLAINNYA.
D. TransportGROUP9sources6470000 ->36rows1617500 per barn; BB140,165,174,201,203,204,231,255,285. CategoryLAINNYA, suffix1..4. DestinationPerawatan adalah keputusan implementasi yang dinarasikan, termasuk angkutpakan/prozen; perlu review bila user menghendaki jenis operasional berbeda. Lihat1000 handoff.
E. Mangdelon6sources8580000 ->24rows2145000 per barn; BB18,97,125,153,154,213. Original designation retained, explicit equal-allocation explanation. Lihat1005 handoff.
F. Material/repair92sources81943000 ->101rows. GROUP BB16,26,27 dibagi4. SubtotalCicurug41121300,Baturuyuk9205500,Randegan20089000,Bantrangsana11527200. Exact IDs in1010 handoff. No candidate BOP date+amount matches found; reference cross-room guards applied. This is not proof against all semantic duplicates from differently dated/aggregated source rows.
G. TERAKHIR6sources25309622 ->8rows, name overrides conflicting code:
- BB105June26 installationpowerBantrangsana1000000 ->Bantrangsana RENOVASI.
- BB113June30 materialRandegan527000 ->Randegan RENOVASI.
- BB118July3 materialRandegan4315000 ->Randegan RENOVASI.
- BB136July17 regulatornipelRandegan360622 ->Randegan PENGGANTIAN_KOMPONEN.
- BB173Aug2 fans/tarpaulin17107000 ->Baturuyuk8553500 refBB173-2 andRandegan8553500 refBB173-3, PERALATAN.
- BB178Aug2 batteriesCicurug/Randegan2000000 ->1000000 each refsBB178-1,-3, PENGGANTIAN_KOMPONEN.
Actual reference syntax is BB-173-2 etc (BB hyphen numeric hyphen suffix). Original dates/amounts/description/code and destination rule retained in notes. No prior duplicate refs; count/sum/destinations verified after commit.

## Source files
BMS_Pemindahan_Data_Lama.xlsx Librarylibfile_15185ed917e081918227d37cfb1079e5 version1,283dated source rows DataLama. Sourceoriginal BUKUBESARPTBMSPERIODE2026-2027(2).xlsx. Workbook itself not edited. Input sheets remain empty; database import independent. Do not claim workbook migration controlsPASS.
ArchiveDATA PETERNAKAN(2).rar Librarylibfile_0b7788878e7c8191a680137e8cba85e0, file_0000000018c48207a893e95ce634f149.15XLSX.
KasbonphotoLibrarylibfile_2b3697b4d378819199c82b11bb15caec andlibfile_4d67958ed7888191839537d78116e6b5 inspected. Paris1500000 andUpahGemuk500000 not created; user deferred.

## Code/schema changes
advances.is_historical_balance bool defaultfalse, v1cashflow excludes these from initial cashout; v2inherits. Migrationadvance_historical_balance_cashflow; SQLsql/20260930_advance_historical_balance.sql. UIselector for historicalbalance not implemented yet.
bop_outside.expense_scope nullabletext CHECKKANTOR/LUAR_KANTOR, newUIrequired. Migrationbop_general_office_scope; SQLsql/20260930_bop_general_office_scope.sql. Legacy unknownscope remainsnull. UIshortcategories,warnings,scopefilter; sixwarningtests/mockrender/syntax/database rollbacktests passed. Not signed-in end-to-end browser tested.
All historical expenses imported with existing paid_byCOMPANY default; payer not independently established. Do not claim verified company cash payments from this default alone.

## Important outstanding / next work
- Remaining source assets/newstockequipment, householdmixeditems, unclearusage and some transport not imported. Inspect originalsource before nextbatch; do not blanket turn allASSET intoexpense. Examplesstockdinamo4700000,newtank6100000,freezer7200000 andfreezerstand1098000.
- Name-over-code rule now governs future mappings; previous explicit four-way GROUP/Mangdelon allocation remains recorded as instructed. Review pastGROUP where uraiannamesonebarn if user wants latestname rule applied retroactively; no automatic undo.
- CicurugJune remainsMANDIRI but ACTIVE after userauthorised adminreopen forAMIRcorrection. IMPORTANT finance_cycle_profit_loss_v2 uses production_mandiri_final only ifinactive. Active period can omit finalsapronak770405100 because detailedpurchases are empty! Need review/closeaftercorrection when authorised; user previously said leaveoutstandingitems for now. Do not claim profit is correct merely because finalsnapshot unchanged. No closing performed in this session.
- AMIRJuly14 174.5kg existingRHPPprice19000,total3315500; marketprice19500 corrected19000 andmarkettotal3315500; receipt3315500 July15 preserved. This price difference87250 does NOT resolve sapronaksource950000.
- Original unresolvedSAPCicuruggross776242600 vsRHPPgross777192600 difference950000 remains. Webfinalnet770405100. Supplierpayments/tambahr肉 reconciliation andAprilperiodmapping from0855 remain deferred, not solved.
- Restore readable user-facing handoff/latest pointer if needed; sourcecurrentmain is authoritative.
