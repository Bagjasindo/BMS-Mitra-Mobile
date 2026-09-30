# BMS — HANDOFF TUNGGAL TERBARU

Tanggal: 30 September 2026
Status: SUMBER LANJUTAN SATU-SATUNYA

## ATURAN UTAMA
- Semua handoff lama sudah dihapus dari folder `docs`.
- Jangan mengambil pekerjaan dari histori/handoff lama.
- Semua audit dan perbaikan sebelumnya dianggap PASS dan DIKUNCI.
- Jangan mengulang rekonsiliasi lama.
- Jangan mengulang input transaksi/data yang sudah ada.
- Jangan menghidupkan kembali daftar pending lama.
- Database/web saat ini adalah sumber kebenaran operasional.
- Jika ada temuan baru, hanya tindak lanjuti jika ditemukan dari Audit Hulu → Hilir saat ini.

## STATUS TERKUNCI — PASS
- UI global: PASS.
- Routing/menu per role: PASS.
- CRUD backend final: PASS.
- DELETE transaksi utama: ADMIN-only PASS.
- OWNER: read-only sesuai desain.
- PPL/Marketing/Logistik/Keuangan: alur yang sudah diuji sebelumnya tetap PASS.
- Guard siklus CLOSED: PASS pada audit terakhir.
- Formula `finance_cycle_profit_loss_v2`: mismatch 0.
- Formula laba/rugi global: diff 0.
- Arus kas pembelian stok vs invoice stok: sinkron pada smoke-check terakhir.
- Overpayment supplier/ekspedisi/Mandiri: 0 pada smoke-check terakhir.
- Test transactions yang sebelumnya dibersihkan tidak boleh dimunculkan lagi sebagai pending.
- Perbaikan Admin Arsip Data untuk `finance_reference_counters`: PASS.

## SATU-SATUNYA PEKERJAAN SELANJUTNYA
# AUDIT HULU → HILIR

Audit harus mengikuti aliran data nyata dari sumber sampai laporan akhir, bukan mengulang audit menu lama.

Urutan audit:
1. MASTER / HULU
   - Kandang
   - Kontrak
   - Item/Sapronak
   - Supplier/Pelanggan/Karyawan/ABK/PPL
   - Harga/standar performa
   - relasi master ke transaksi

2. INPUT OPERASIONAL
   - Logistik
   - PPL/Produksi
   - Marketing
   - Keuangan
   - Expedisi

3. ALIRAN ANTAR-MODUL
   - input sumber harus masuk ke tabel/ledger tujuan yang benar
   - referensi transaksi harus konsisten
   - tidak boleh ada input statis/palsu
   - tidak boleh ada double count
   - tidak boleh ada transaksi yang putus dari sumbernya
   - stok/aset/hutang/piutang/kas harus bergerak sistematis

4. RHPP / PRODUKSI
   - sumber DOC, pakan, OVK1, panen, recording, retur, sapronak luar, tambah daging
   - nilai kontrak vs aktual sesuai aturan
   - RHPP Real/koreksi mengikuti jalur resmi
   - BOP Produksi terpisah sesuai desain
   - Perawatan Kandang tidak dicampur ke siklus

5. KEUANGAN / HILIR
   - hutang supplier
   - piutang
   - pembayaran/penerimaan
   - arus kas
   - aset/stok
   - BOP Umum
   - Expedisi
   - laba/rugi kandang
   - laba/rugi global

6. OUTPUT AKHIR
   - Dashboard
   - laporan per role
   - laporan OWNER
   - cetak/export
   - angka output harus dapat ditelusuri kembali sampai transaksi sumber

## CARA KERJA AUDIT HULU → HILIR
- Audit dengan data live saat ini.
- Ikuti satu aliran transaksi dari sumber → proses → ledger → laporan.
- Jangan mengubah data hanya untuk testing bila tidak perlu.
- Bila perlu tes tulis, gunakan transaksi rollback/temporary dan pastikan tidak meninggalkan residue.
- Setiap temuan baru diberi status: PASS / BUG / FIXED.
- Jangan membuka ulang item yang sudah PASS kecuali perubahan baru menyentuh alurnya.
- Jangan memakai catatan historis sebagai bukti bahwa data sekarang masih belum masuk.
- Sebelum menyatakan data belum ada, cek database live terlebih dahulu.

## TITIK MULAI CHAT BERIKUTNYA
Perintah:
**"Lanjut BMS dari HANDOFF TUNGGAL TERBARU. Mulai Audit Hulu → Hilir. Jangan baca/ulang handoff lama karena semuanya sudah PASS."**


## PERUBAHAN TERBARU — ADMIN BUKA/TUTUP SIKLUS
- Menu baru: **Administrator → Buka/Tutup Siklus**.
- Alur: pilih Kandang → pilih Siklus → Buka/Tutup.
- Hanya ADMIN yang dapat menjalankan aksi.
- Membuka siklus hanya memengaruhi assignment kandang+siklus terpilih; siklus lain tetap terkunci.
- Sistem menolak membuka siklus lama jika kandang yang sama masih memiliki siklus aktif lain.
- Saat siklus MITRA dibuka, snapshot `rhpp_system_final` lama dilepas; saat ditutup kembali sistem memakai proses close resmi dan membuat snapshot final baru.
- Saat siklus MANDIRI dibuka, snapshot `production_mandiri_final` lama dilepas; saat ditutup kembali sistem memakai proses close resmi.
- Backend RPC: `admin_reopen_cycle_v1` dan `admin_reclose_cycle_v1`.
- Uji ADMIN buka→tutup dilakukan dengan transaksi rollback; data asli tetap CLOSED dan snapshot final tetap ada setelah rollback.
- Uji akses non-ADMIN: ditolak.
- Cache web saat ini: `main-1958.js?v=2248-admin-cycle-open-close`.


## PERUBAHAN TERBARU — ABK DIPINDAH KE CHICK-IN
- Buat Siklus tidak lagi meminta ABK/Populasi Awal.
- PPL memilih ABK dan membagi Populasi Awal saat Produksi/PPL → Chick-In / DOC Masuk.
- Total Populasi Awal ABK wajib sama dengan DOC In - DOC Mati Box.
- Penyimpanan Chick-In + pembagian ABK menggunakan RPC atomik `save_chick_in_with_abks_v1`.
- Relasi ABK tetap disimpan di `logistics_contract_assignment_abks`, yaitu sumber yang dibaca Liga ABK.
- Liga ABK tetap memakai `initial_birds` dari relasi tersebut untuk survival, IP, biaya DOC, dan perhitungan ABK.
- Uji rollback pada Baturuyuk: Chick-In 14.800, dua ABK @7.400, total relasi 14.800 PASS.
- Cache web: `main-1958.js?v=2251-chickin-abk-to-league`.


## AUDIT HULU → HILIR — STATUS 30 SEPTEMBER 2026
Audit live dilanjutkan tanpa mengubah data.

### PASS — Integritas Hulu / Operasional
- Master assignment → kandang: tidak ada orphan.
- Siklus MITRA → kontrak: tidak ada kontrak hilang.
- Tidak ada lebih dari satu siklus aktif pada kandang yang sama.
- Chick-In: tidak ada duplikat per assignment dan tidak ada barn mismatch.
- Pembagian ABK: tidak ada duplicate assignment+ABK.
- Randegan Siklus 2 sudah dikoreksi: Logistik DOC 8.000 = Chick-In 8.000 = total ABK 8.000, DOA 0, selisih 0.
- Bantrangsana Siklus 2: Chick-In 24.500 = total ABK 24.500.
- Logistik shipment, Panen, Recording, Marketing: tidak ditemukan mismatch barn/assignment pada pemeriksaan audit.
- Invoice stok vs total item: mismatch 0.
- Pembelian langsung vs assignment/barn: mismatch 0.
- Aset lokasi KANDANG tanpa barn: 0.

### PASS — RHPP / Laba Rugi
- Cicurug Siklus 2 sempat drift karena Tambah Daging Rp11.520.000 dibuat setelah snapshot CLOSED.
- Siklus sudah dibuka lalu ditutup kembali melalui jalur resmi.
- Setelah re-close: snapshot RHPP System Rp286.096.800 = live Rp286.096.800, selisih 0.
- Tambah Daging Cicurug Rp11.520.000 terpisah dari BOP; tidak double count.
- Laba/Rugi Cicurug Siklus 2: RHPP Real Rp250.161.212; BOP Produksi Rp93.662.864; Tambah Daging Rp11.520.000; Laba Bersih Rp144.978.348.
- Formula internal finance_cycle_profit_loss_v2: mismatch 0.
- Population balance RHPP live: tidak ditemukan unbalanced row pada audit.

### PASS — Keuangan / Hilir
- Supplier/Expedition/Mandiri payment orphan: 0.
- Payment nonpositive pada jalur yang diperiksa: 0.
- Hutang supplier live: 5 transaksi terbuka, total Rp36.440.000, pembayaran tercatat Rp0.
- Cashflow v4 agregat saat audit: masuk Rp1.982.526.613; keluar Rp855.777.277; net Rp1.126.749.336.
- Laba/Rugi Global saat audit:
  - Kandang operational profit Rp592.620.928
  - Expedition profit/loss Rp14.793.840
  - BOP Umum Rp205.323.659
  - Maintenance long term Rp0
  - Company profit/loss Rp402.091.109
  - hitung ulang selisih 0.

### PASS — Output Akhir
- Dashboard OWNER membaca sumber live (productionBase + recording + estimasi + final produksi + logistik + Liga ABK), tidak ditemukan angka KPI/Rupiah hard-code pada audit source.
- KPI produksi berjalan menggunakan data Chick-In, Recording, Panen live.
- Laporan OWNER bukan halaman dummy: menu OWNER meneruskan ke laporan asli Logistik, Marketing, Keuangan, Produksi, dan PPL.
- Print/PDF/Excel Produksi mengambil clone dari area laporan live yang sedang ditampilkan.
- Siklus ABK sekarang berinduk pada pembagian ABK saat Chick-In: pertama ikut = Siklus ABK 1, pindah kandang/ikut Chick-In berikutnya = Siklus ABK berikutnya; nomor siklus kandang tidak dijadikan nomor Siklus ABK.

### STATUS
Audit Hulu → Hilir yang diperiksa sampai Output Akhir: PASS.
Jangan ulang audit bagian di atas kecuali perubahan kode/data berikutnya menyentuh jalurnya.


## AUDIT KHUSUS LOGISTIK + PPL SETELAH REVISI FORM — 30 SEPTEMBER 2026
Status: PASS setelah hardening.

### LOGISTIK
- Menu/hak akses LOGISTIK tetap sesuai visibleTabs.
- Form Pengiriman edit memakai assignment asli transaksi; kandang tetap fixed saat edit.
- Qty draft dapat diedit inline; harga kontrak tetap dihitung dari assignment/kontrak terpilih.
- Riwayat Pengiriman mendukung filter Kandang + Siklus + Tanggal dan menampilkan semua hasil tanpa pagination.
- Smoke-test akun LOGISTIK pada Pengiriman Baturuyuk menggunakan transaksi rollback: edit nilai yang sama berhasil; qty 60 zak = 3.000 kg, harga Rp500.000/zak tetap benar.
- Tombol Hapus Pengiriman sekarang hanya tampil untuk ADMIN.
- RLS logistics_shipments DELETE diperketat menjadi ADMIN-only.
- Direct DELETE sebagai akun LOGISTIK diuji: 0 row terhapus.
- logistics_shipment_items DELETE tetap tersedia untuk LOGISTIK karena RPC save_logistics_shipment_atomic adalah SECURITY INVOKER dan perlu mengganti child rows saat edit.

### PPL
- Chick-In tetap menjadi sumber pembagian ABK.
- Jika PPL memilih siklus aktif yang sudah memiliki Chick-In, form otomatis masuk mode Edit dan tidak lagi berhenti pada error duplikat.
- Baris Chick-In pada siklus CLOSED sekarang tampil Terkunci; Edit baru tersedia setelah Administrator membuka siklus.
- Liga ABK menampilkan Populasi Awal sebagai read-only dari pembagian Chick-In; tombol lama Simpan Populasi Awal di Liga ABK dihapus.
- Pakan dan Panen ABK tetap berjalan dari relasi ABK yang dibentuk saat Chick-In.
- Smoke-test akun PPL Burhanudin pada Baturuyuk menggunakan rollback: Chick-In 14.800, DOA 0, ABK 7.400 + 7.400 = 14.800 PASS.
- Tombol/akses DELETE Chick-In non-admin ditutup di backend; RLS chick_ins DELETE menjadi ADMIN-only.
- Direct DELETE sebagai akun PPL diuji: 0 row terhapus.
- RLS logistics_contract_assignment_abks DELETE juga diperketat ADMIN-only.

### CACHE / SOURCE
- Frontend commit: 01c731e0830381bda8252056966e14bd7f44bcb1
- Cache: main-1958.js?v=2253-logistics-ppl-form-hardening
- Cache commit: 26075b0f90fc0f07f5c7f156556c894eeb9a5011
- SQL hardening: sql/20260930_logistics_ppl_form_hardening.sql
- SQL commit: 7c7d6389e269fb168a82fef6cbbf3a4d22acd4c9


## AUDIT ULANG PENUH HULU → HILIR + FLOW FREEZE — 30 SEPTEMBER 2026
Tujuan: verifikasi ulang kesiapan operasi tanpa mengubah alur bisnis yang sudah PASS.

### HASIL AUDIT DATA LIVE
- 21 pemeriksaan integritas utama: seluruhnya 0 masalah.
- Assignment missing barn: 0.
- MITRA missing contract: 0.
- Multiple active cycle per barn: 0.
- Duplicate Chick-In per assignment: 0.
- Chick-In barn mismatch: 0.
- Duplicate ABK link: 0.
- ABK vs Chick-In mismatch: 0.
- Shipment/Recording/Harvest/Marketing barn mismatch: 0.
- Invalid shipment/harvest quantity: 0.
- Recording sebelum Chick-In: 0.
- Marketing amount mismatch: 0.
- Stock invoice vs item mismatch: 0.
- Direct purchase barn mismatch: 0.
- Asset KANDANG missing barn: 0.
- Supplier/Expedition/Mandiri nonpositive payment: 0.

### RHPP / KEUANGAN / HILIR
- Closed missing RHPP snapshot: 0.
- RHPP snapshot drift: 0.
- RHPP Chick-In drift: 0.
- RHPP harvest drift: 0.
- RHPP population unbalanced: 0.
- Formula Laba/Rugi kandang mismatch: 0.
- Formula Laba/Rugi Global diff: Rp0.
- Tambah Daging yang terduplikasi ke BOP: 0.
- Cashflow audit tetap: masuk Rp1.982.526.613; keluar Rp855.777.277; net Rp1.126.749.336.
- Hutang supplier terbuka: 5 transaksi; Rp36.440.000.
- Company P/L saat audit: Rp402.091.109.

### ROLE / WRITE / DELETE SMOKE TEST — SELURUHNYA ROLLBACK
- LOGISTIK: Edit berhasil, Delete 0.
- PPL: Edit berhasil, Delete 0.
- MARKETING: Edit berhasil, Delete 0.
- KEUANGAN: Edit berhasil, Delete 0.
- OWNER: Edit 0, Delete 0 (read-only).
- Tidak ada residue transaksi test.

### BUG DITEMUKAN DAN FIXED SAAT AUDIT ULANG
Policy DELETE lama masih membolehkan role operasional menghapus beberapa transaksi utama. Diperketat ADMIN-only tanpa mengubah jalur input/edit:
- BOP
- Sapronak Luar
- Retur Mitra / Retur Luar
- Panen Marketing
- Tambah Daging
- Panen ABK
- Estimasi
- Recording
- Kunjungan
Policy Chick-In / Pengiriman utama / ABK link sudah lebih dulu diperketat pada audit khusus LOGISTIK+PPL.

### HARDENING RPC ANON
- finance_pay_mandiri_supplier_atomic
- log_user_activity
- production_feed_stock_as_of
Akses EXECUTE dari PUBLIC/anon dicabut; authenticated tetap diizinkan.
Advisor setelah hardening tidak lagi menunjukkan warning anon SECURITY DEFINER untuk fungsi tersebut.

### SECURITY ADVISOR YANG TERSISA
- 69 warning generic authenticated SECURITY DEFINER: RPC aplikasi memang digunakan oleh user login; audit definisi menunjukkan terdapat mekanisme pemeriksaan auth/user/role.
- 2 tabel internal RLS tanpa policy: langsung tidak dapat diakses lewat Data API; dipakai sebagai internal state.
- Leaked Password Protection Supabase masih disabled; ini setting keamanan Auth, bukan alur bisnis aplikasi.

### FLOW FREEZE — DIKUNCI
Mulai titik ini, seluruh alur bisnis yang sudah PASS dianggap FROZEN:
- Master → Siklus → Logistik → Chick-In/ABK → Produksi/PPL → Marketing → RHPP → Keuangan → Laba/Rugi → Dashboard/Laporan.
- Jangan mengubah formula, sumber data, relasi, snapshot, trigger, RPC, tabel tujuan, atau hak role yang sudah PASS tanpa temuan BUG nyata dari data live.
- Revisi normal berikutnya dibatasi pada:
  1. tampilan/UI/tema,
  2. menu riwayat/filter/pencarian,
  3. penyeragaman layout/form input,
  4. label/keterangan/UX,
  selama tidak mengubah sumber data dan alur bisnis yang sudah PASS.
- Jika revisi UI/form menyentuh submit handler, wajib smoke-test rollback agar alur backend tidak berubah.

### FILE / COMMIT
- SQL re-audit hardening: sql/20260930_full_reaudit_hardening.sql
- Commit SQL: 6284703b03481c2b178b5d7dea298b981240a4ab


## REPO CLEANUP + PASS BASELINE LOCK — 30 SEPTEMBER 2026
- Audit struktur repo main dilakukan setelah full re-audit PASS.
- File dokumentasi lama yang sudah redundant dan tidak dipakai aplikasi dihapus:
  - `AUDIT_ISOLASI_ESTIMASI_LIGA_ABK_20260929.md`
- `docs/` tetap hanya berisi handoff tunggal `BMS_HANDOFF_CURRENT.md`.
- File SQL di `sql/` dan `supabase/` dipertahankan karena merupakan jejak migrasi, guard, snapshot, recovery, dan audit database; jangan dianggap file sampah hanya karena tidak dipanggil frontend.
- Source operasional utama tetap:
  - `index.html`
  - `main-1958.js`
  - `style.css`
  - `assets/`
  - `docs/BMS_HANDOFF_CURRENT.md`
  - SQL/migration history yang relevan.
- Baseline PASS akan dikunci pada branch `locked-pass-2026-09-30`.
- Branch baseline tersebut adalah titik rollback/freeze. Revisi berikutnya dilakukan di `main` dan tidak boleh memindahkan/mengubah branch baseline.
- Alur bisnis FLOW FREEZE tetap berlaku. Revisi normal hanya UI/menu riwayat/filter/penyeragaman form/label tanpa mengubah backend PASS.


## UI SAFETY — GLOBAL SUBMIT GUARD — 30 SEPTEMBER 2026
Status: PASS / UI-only; tidak mengubah alur bisnis/backend.

- Semua form transaksi berbasis submit memakai pengaman global anti-double submit.
- Saat submit pertama berjalan, submit kedua dari klik/Enter ditolak sampai proses selesai.
- Tombol submit menampilkan status langsung:
  - `Sedang menyimpan...`
  - `Tersimpan ✓`
  - `Gagal — coba lagi`
- Pesan submit tidak lagi bergantung pada notifikasi global di bagian atas halaman.
- Form filter/search/history dikecualikan dari submit guard supaya UX pencarian tetap normal.
- Baseline backend/alur PASS tetap tidak berubah.
- Frontend commit anti-double submit: `fc00ceb63ea90cbcc9fe2cdb9b4b60ccfb9b7884`
- Frontend commit feedback tombol: `56fbb4c09117f2dd61ed4b529c0ea96abb1f08a0`
- Cache: `main-1958.js?v=2255-button-submit-feedback`
- Cache commit: `46e05319a833a04f13f380e62a05573a57acf542`
