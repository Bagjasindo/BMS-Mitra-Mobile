# CHECKPOINT 2026-09-27 — Mitra / Mandiri

Status terakhir sebelum pindah chat:

- Backup branch dibuat: `backup-2026-09-27-mitra-mandiri-checkpoint`.
- Jangan hapus versi/file lama dulu.
- Fitur Mitra/Mandiri sudah mulai ditambahkan:
  - Jenis siklus: MITRA / MANDIRI.
  - Pembelian Mandiri multi-kandang.
  - Master Pelanggan.
  - Panen Mandiri dengan harga jual manual.
  - Laporan Logistik/Marketing/Keuangan/Owner mulai membaca tipe siklus.
- Data lama tetap bertipe MITRA.
- Smoke test database Mandiri dilakukan dengan transaksi rollback; data tes tidak tersisa.

## Koreksi penting yang masih PENDING

Mandiri **tetap harus memakai Performa** untuk acuan produksi / laporan harian PPL.

Pilihan Performa yang tersedia:
- Performa BMS
- Performa Bounty

Aturan final yang disepakati:
- MITRA = wajib Kontrak + wajib pilih Performa.
- MANDIRI = tanpa Kontrak, tetapi tetap wajib pilih Performa BMS atau Performa Bounty.
- Performa Mandiri hanya untuk acuan produksi/PPL; harga jual Mandiri tetap manual dan tidak berasal dari kontrak.

## Instruksi kerja berikutnya

1. Koreksi form Buat Siklus agar MANDIRI tetap menampilkan dan mewajibkan pilihan Performa.
2. Koreksi validasi database supaya MANDIRI menyimpan `performance_template_name` tanpa `master_contract_id`.
3. Pastikan laporan harian PPL/produksi membaca Performa yang dipilih pada siklus Mandiri.
4. Jangan mengubah modul yang sudah PASS selain bagian yang diperlukan untuk koreksi ini.
5. Jangan hapus file/versi lama sebelum audit ulang selesai.


---

# CHECKPOINT LANJUTAN 2026-09-27 — MAIN LIVE

**Gunakan bagian ini sebagai baseline kerja berikutnya. Jangan mulai ulang audit dari awal.**

## Aturan yang tetap dikunci
- Jangan mengubah modul/menu yang sudah PASS kecuali diperlukan.
- Jangan memasukkan data trial/fake ke database live.
- Jangan hapus versi/file lama sebelum audit/backup.
- MITRA dan MANDIRI dipisahkan bila alurnya berbeda.
- MANDIRI tanpa kontrak, tetapi tetap wajib memakai Performance untuk Produksi/PPL.
- Harga jual Panen Mandiri tetap manual.
- Laba/rugi memakai nilai transaksi; Arus Kas memakai penerimaan/pembayaran aktual.

## Status data trial Mandiri
Audit live terakhir:
- Siklus Mandiri: 0
- Panen Mandiri: 0
- Penerimaan Penjualan Mandiri: 0
- Pembelian Mandiri: 0
- Alokasi Pembelian Mandiri: 0
- Master Pelanggan: 0
- Recording/Chick-In/BOP terkait Mandiri: 0

Tidak dilakukan DELETE tambahan karena data trial sudah kosong.

## Master Pelanggan
- Dikelola ADMIN.
- Berada di Master Data.
- MARKETING tidak mengelola Master Pelanggan.
- MARKETING tetap memilih pelanggan saat Panen Mandiri.

## Laba/Rugi Global
Mitra dan Mandiri sudah dipisahkan pada:
- Pendapatan
- BOP Produksi
- Biaya Sapronak
- Tambah Daging
- Laba/Rugi
Masing-masing memiliki subtotal Mitra, Mandiri, dan total.

## Keuangan Mandiri
Dikelompokkan dalam submenu khusus:
1. Piutang Penjualan
2. Penerimaan Penjualan
3. Hutang Supplier
4. Pembayaran Supplier
5. Laporan Mandiri

Status:
- Piutang Penjualan: tersedia/read-only.
- Penerimaan Penjualan: tersedia; penuh/sebagian; sisa piutang otomatis.
- Penerimaan masuk ke Arus Kas sebagai PENJUALAN MANDIRI.
- Hutang Supplier Mandiri: tampilan sumber pembelian sudah dipisah, ledger pembayaran belum final.
- Pembayaran Supplier Mandiri: belum diaktifkan penuh agar tidak bercampur dengan ledger lama.
- Laporan Mandiri: dipisah dari Mitra.
- VOID/koreksi transaksi keuangan Mandiri masih pending.

## Struktur Menu Keuangan
Di dalam Keuangan:
- Mitra
- Mandiri
- Umum / Operasional

## Struktur Menu Expedisi
Expedisi berdiri sendiri:
- Operasional
- Keuangan Expedisi
  - Pembayaran Expedisi
  - BOP Operasional Expedisi
  - Perawatan Expedisi
- Laporan
  - Laba/Rugi Expedisi

## Sidebar / Responsive
- Desktop sidebar: 270px.
- Label menu boleh wrap; tidak ellipsis.
- Mobile tetap 1 kolom/full-width.
- Breakpoint mobile tetap max-width:700px.
- Nama menu tetap lengkap, tidak disingkat menjadi "Exp".

## Asset live yang dipakai saat checkpoint ini
- HTML entrypoint: `index.html`
- JavaScript live: `main-1958.js?v=2127-finance-expedition-cleanup`
- CSS live: `style.css?v=2129-sidebar-270`

## Audit file lama / risiko kembali ke versi awal
Root branch `main` saat checkpoint ini hanya memiliki satu file aplikasi JS utama dan satu CSS utama:
- `main-1958.js`
- `style.css`
- `index.html`

Tidak ditemukan file JS/CSS versi lama lain di root yang ikut dipanggil oleh `index.html`.
`index.html` hanya memuat:
- `style.css?v=2129-sidebar-270`
- `main-1958.js?v=2127-finance-expedition-cleanup`

Artinya file lama yang masih ada di riwayat Git/branch backup tidak dapat membuat aplikasi live kembali ke versi awal kecuali seseorang secara sengaja mengubah `main` atau referensi asset di `index.html`.

## Titik lanjut berikutnya
Fokus berikutnya **bukan audit ulang**, tetapi:
1. Finalisasi Hutang Supplier Mandiri.
2. Finalisasi Pembayaran Supplier Mandiri.
3. Sambungkan pembayaran supplier Mandiri ke Kas Keluar tanpa double count.
4. Tambahkan VOID/koreksi transaksi keuangan dengan audit trail.
5. End-to-end test menggunakan data real.


---

## AUDIT PERHITUNGAN WEB 2026-09-28

Status: **AUDIT SAJA — temuan di bawah belum diperbaiki kecuali perbaikan kumulatif CLOSED yang sudah dilakukan sebelumnya.**

### Temuan Kritis
1. **Produksi PROSES salah menghitung deplesi/IP pada Laporan Produksi dan Rekap Produksi PPL.**
   - Cabang PROSES masih memakai `mortBirds = Chick-In - Chick-Out`.
   - `Chick-Out` pada siklus berjalan hanya jumlah panen, sehingga ayam yang masih hidup di kandang ikut dianggap deplesi.
   - Data live saat audit: Chick-In 14.800, deplesi recording 2.278, panen 6.762.
   - Rumus web lama akan membaca deplesi 8.038, sehingga survival/IP siklus berjalan salah.
   - Perbaikan yang benar: untuk PROSES gunakan mortality+culling dari recording dan metrik performa berjalan berbasis populasi/BW recording, bukan hanya hasil panen.

2. **Arus Kas Sapronak Luar bukan cash basis.**
   - `finance_cashflow_entries_v1` memasukkan seluruh nilai SAPRONAK LUAR sebagai KELUAR pada tanggal pengiriman.
   - Pembayaran supplier aktual di `supplier_payments` tidak menjadi sumber kas keluar.
   - Data live saat audit: invoice Sapronak Luar Rp 14.700.000; pembayaran supplier tercatat Rp 0.
   - Artinya Arus Kas web saat ini tetap mencatat Rp 14.700.000 kas keluar walaupun menurut ledger pembayaran aplikasi belum ada kas keluar.
   - Tambah Daging memakai pola yang sama.

3. **Close Mandiri tidak membuat snapshot produksi final.**
   - Web aktif memanggil `admin_close_mandiri_cycle_atomic`.
   - RPC itu hanya mengubah assignment menjadi `active=false`; tidak menulis `rhpp_system_final`.
   - Laporan Produksi/Rekap CLOSED mengandalkan snapshot `rhpp_system_final` agar angka final terkunci.
   - Saat Mandiri nanti benar-benar dipakai dan di-Close, laporan CLOSED berisiko jatuh ke rumus data berjalan dan tidak konsisten.
   - Belum berdampak sekarang karena audit terakhir tidak ada siklus Mandiri live.

### Temuan Tinggi
4. **Estimasi setelah panen sebagian mempunyai rumus preview yang berbeda dengan rumus tersimpan/riwayat.**
   - Preview FCR memakai pakan / biomassa sisa estimasi saja.
   - Riwayat memakai pakan / (panen sebelumnya + biomassa sisa).
   - Preview keuangan juga hanya menghitung proyeksi sisa, sedangkan saat Simpan pendapatan memasukkan panen aktual sebelumnya.
   - Data live: ada 10 estimasi yang dibuat setelah panen sebagian.
   - Jadi preview sebelum Simpan dapat berbeda dari hasil yang kemudian tampil di riwayat.

5. **Retur Sapronak Luar belum mengurangi hutang supplier / biaya secara konsisten.**
   - `finance_supplier_payables_v1` menghitung tagihan dari nilai pengiriman awal tanpa mengurangi retur.
   - `finance_cycle_profit_loss_v2` juga tidak langsung mengurangi `logistics_external_returns`; hanya membaca transfer retur antar assignment.
   - Saat audit tidak ada retur external live, jadi belum berdampak pada angka sekarang, tetapi akan salah saat retur supplier dipakai.

### Temuan Sedang / Definisi
6. **Label Dashboard IP CLOSED tidak sesuai rumus.**
   - Nilai Dashboard menghitung ulang IP gabungan seluruh CLOSED.
   - Subtitle masih mengatakan “rata-rata tertimbang RHPP closed”.
   - Dengan data audit: IP gabungan ≈ 398,89 sedangkan rata-rata tertimbang IP per siklus ≈ 399,66.
   - Nilai 398,89 valid sebagai “IP Gabungan Produksi Closed”; label perlu disesuaikan.

7. **Laporan Keuangan Mandiri menampilkan laba operasional sebelum perawatan.**
   - Perhitungan `Penjualan - BOP - Sapronak - Tambah Daging` benar sebagai laba operasional.
   - Di baris tabel label hanya “Laba/Rugi”, sehingga bisa disangka laba bersih setelah perawatan.
   - Bukan kesalahan aritmetika, tetapi istilah perlu diperjelas.

### Area yang saat audit tidak menunjukkan kesalahan aritmetika utama
- Panen Marketing: total = Kg × Harga/Kg; Mitra mengambil harga kontrak berdasarkan BW, Mandiri manual.
- Pembelian Mandiri: total = jumlah × harga satuan; distribusi tidak boleh melebihi pembelian.
- Expedisi: nilai trip = harga trip + tambahan − potongan; invoice/piutang/pembayaran konsisten.
- Laba/Rugi Expedisi: pendapatan − BOP operasional − perawatan.
- Laba/Rugi Global: laba kandang + laba operasional Expedisi − perawatan kandang − perawatan Expedisi − BOP umum; tidak ditemukan double-count utama.
- RHPP Mitra web aktif memakai `finance_rhpp_summary_v5` dan Close Mitra memakai `admin_close_production_atomic` berbasis v5.
- Fungsi legacy `save_rhpp_final_atomic` masih ada di database tetapi tidak ditemukan dipanggil oleh JS aktif.

### Urutan koreksi yang direkomendasikan
1. Rumus Produksi PROSES.
2. Close Mandiri + snapshot final.
3. Arus Kas Supplier berdasarkan pembayaran aktual.
4. Estimasi setelah panen sebagian.
5. Retur Sapronak Luar terhadap hutang dan biaya.
6. Koreksi label/istilah Dashboard dan laporan.


---

## IMPLEMENTASI 3 TEMUAN KRITIS 2026-09-28

Status: **SUDAH DIKERJAKAN — hanya 3 poin audit, modul PASS lain tidak diubah.**

### 1. Produksi PROSES
- Laporan Produksi dan Rekap Produksi PPL tidak lagi memakai `Chick-In - Chick-Out` sebagai deplesi siklus berjalan.
- Deplesi PROSES sekarang berasal dari kumulatif `recordings.mortality + recordings.culling`.
- Populasi hidup berjalan = Chick-In - Deplesi Recording - Panen yang sudah terjadi.
- FCR/IP berjalan memakai pakan terpakai Recording dan biomassa gabungan: panen yang sudah terjadi + ayam hidup berdasarkan BW recording terakhir.
- CLOSED tetap memakai snapshot final dan tidak diubah.
- Data live verifikasi: Chick-In 14.800; deplesi recording 2.278; panen 6.762; populasi hidup 5.760. Angka 8.038 tidak lagi dipakai sebagai deplesi.

### 2. Arus Kas Supplier
- `finance_cashflow_entries_v1()` tidak lagi mengakui seluruh SAPRONAK LUAR/TAMBAH DAGING sebagai Kas Keluar pada tanggal transaksi.
- Kas Keluar supplier sekarang hanya berasal dari `supplier_payments` pada `paid_on`.
- Hutang/biaya transaksi tetap terpisah dan perhitungan laba-rugi tidak diubah.
- Verifikasi live saat implementasi: nilai invoice Sapronak Luar Rp14.700.000 dan pembayaran supplier Rp0; hasil Arus Kas supplier juga Rp0.

### 3. Close Mandiri Snapshot
- Dibuat tabel khusus `production_mandiri_final`, terpisah dari `rhpp_system_final` Mitra.
- `admin_close_mandiri_cycle_atomic` sekarang:
  1. validasi ADMIN;
  2. validasi MANDIRI aktif;
  3. validasi Performance terpilih;
  4. validasi Chick-In dan Panen;
  5. hitung ringkasan produksi Mandiri;
  6. simpan snapshot produksi final Mandiri;
  7. baru mengubah siklus menjadi CLOSED.
- Laporan Produksi dan Rekap Produksi PPL membaca snapshot Mitra + snapshot Mandiri sesuai jenis siklus.
- Tidak ada data Mandiri live saat implementasi, sehingga tidak dibuat data test/fake.

### Asset live
- `main-1958.js?v=2132-audit-critical-fixes`

### Commit aplikasi
- `7da62ea426da94eb530d6a77c036a0f9cff17409` — Produksi PROSES + snapshot Mandiri pada laporan.
- `c9e2ee5708f6c1594d6191f21700ce85e60aac17` — refresh asset.

### Catatan advisor
- RLS dibuat untuk tabel snapshot Mandiri.
- Index `barn_id` dan `created_by` ditambahkan hanya pada tabel snapshot Mandiri baru.
- Warning SECURITY DEFINER yang terlihat adalah pola lama project dan tetap memakai pemeriksaan role internal; tidak dilakukan cleanup umum agar tidak menyentuh modul PASS.


---

## IMPLEMENTASI 4 TEMUAN SISA AUDIT 2026-09-28

Status: **SUDAH DIKERJAKAN — hanya titik audit terkait, modul PASS lain tidak diubah.**

### 1. Estimasi setelah panen sebagian
- Preview sekarang memakai panen aktual **sebelum tanggal estimasi** (`harvested_on < estimated_on`), sama dengan logika simpan/riwayat.
- FCR preview = total pakan / (biomassa panen aktual sebelumnya + biomassa sisa estimasi).
- IP preview memakai total projected birds dan total projected biomass yang sama dengan riwayat.
- Preview keuangan sekarang menampilkan:
  - Panen aktual sebelumnya
  - Proyeksi sisa panen
  - Total hasil panen estimasi
  - Biaya yang sama dengan nilai yang akan disimpan
- Saat edit estimasi lama, preview mengikuti snapshot feed/cost tersimpan agar tidak berubah diam-diam.

### 2. Retur Tambah Sapronak
Audit implementasi menemukan modul ini adalah **stok retur perusahaan**, bukan retur kembali ke supplier.
Karena itu:
- Hutang supplier **tidak dikurangi** oleh Retur Tambah Sapronak.
- Biaya siklus asal sekarang dikurangi saat barang masuk stok retur perusahaan.
- Saat stok retur dikirim ke kandang tujuan, biaya ditambahkan ke siklus tujuan.
- Tidak lagi terjadi double-out dari siklus asal.
- `finance_cycle_profit_loss_v2()` memakai:
  - pembelian luar
  - dikurangi stok retur dari siklus asal
  - ditambah transfer stok retur ke siklus tujuan
- Arus Kas tetap tidak berubah oleh perpindahan stok.

### 3. Dashboard IP CLOSED
- Label diubah dari `IP Kumulatif yang Close / rata-rata tertimbang RHPP closed`
  menjadi `IP Gabungan Produksi Closed`.
- Subtitle menjadi `gabungan seluruh snapshot produksi CLOSED`.
- Dashboard sekarang membaca snapshot CLOSED Mitra dari `rhpp_system_final` dan snapshot CLOSED Mandiri dari `production_mandiri_final`.

### 4. Laporan Keuangan Mandiri
- Angka tidak diubah.
- Label diperjelas menjadi `Laba Operasional (Sebelum Perawatan)`.
- Kolom tabel menjadi `Laba Operasional`.
- Keterangan menegaskan bahwa Perawatan Jangka Panjang belum dikurangkan pada angka operasional tersebut.

### Verifikasi
- Syntax JavaScript: OK.
- Fungsi laba/rugi siklus terverifikasi:
  - retur mengurangi biaya siklus asal;
  - transfer retur menambah biaya siklus tujuan;
  - hutang supplier tidak terpengaruh oleh stok retur perusahaan.
- Saat implementasi belum ada data Retur Tambah Sapronak live dan belum ada snapshot Mandiri live; tidak dibuat data fake/test.

### Asset live
- `main-1958.js?v=2133-audit-four-fixes`

### Commit
- `88bd1fe823bcda042fdd0db3198d3dedbcd6140d` — Estimasi, label Dashboard, label Mandiri.
- `5d1a6b45d39d2e2610ff352a15e819e862dbb035` — KPI CLOSED gabung snapshot Mitra + Mandiri.
- `2094ab1877e6b852702ad0e1fc1364118fbb2365` — refresh asset.


---

## AUDIT ULANG VERIFIKASI PASS 2026-09-28

Status: **BELUM 100% PASS — ditemukan 2 ketidakkonsistenan Produksi aktif.**
Audit ini tidak mengubah kode.

### PASS
- Syntax JS main: OK.
- Asset live: `2133-audit-four-fixes`.
- Close Mandiri snapshot: struktur tersedia dan RPC menulis ke `production_mandiri_final`.
- Arus Kas supplier: cash basis dari `supplier_payments`.
- Retur Tambah Sapronak: biaya keluar dari siklus asal dan masuk ke siklus tujuan saat transfer; hutang supplier tidak berubah.
- Dashboard label IP CLOSED sudah sesuai definisi.
- Laporan Mandiri sudah memakai label Laba Operasional.
- RPC utama Finance/RHPP/Expedisi berhasil dieksekusi tanpa error pada audit.

### TEMUAN 1 — Dashboard Produksi aktif setelah panen sebagian
`buildDashboardModel()` masih menghitung:
`population = initial - dead`
dan belum mengurangi panen yang sudah terjadi.

Data live:
- Chick-In 14.800
- Deplesi 2.278
- Panen 6.762
- Dashboard formula lama: 12.522
- Populasi hidup benar: 5.760

Akibat:
- Populasi Dashboard salah setelah panen sebagian.
- Biomassa/FCR/IP Dashboard aktif ikut bias.

### TEMUAN 2 — Performa Recording setelah panen sebagian
`recordingPplPage()` juga masih memakai:
`population = initial - cumulative_depletion`
tanpa mengurangi panen sampai tanggal recording.

Audit live menemukan 5 baris recording setelah panen sudah dimulai yang terdampak.

### CATATAN ESTIMASI
Enam estimasi memiliki panen Marketing pada tanggal yang sama.
Data tersimpan membuktikan estimasi dibuat **sebelum panen hari yang sama**:
- remaining_birds tersimpan cocok dengan formula panen `< estimated_on`, bukan `<= estimated_on`.

Namun handler pemilihan/edit Estimasi masih menghitung Sisa Ayam Real memakai panen `<= tanggal estimasi`.
Ini berpotensi menampilkan sisa yang terlalu kecil ketika membuka ulang tanggal yang sama setelah Marketing memasukkan panen hari itu.
Perlu disamakan menjadi `< estimated_on` untuk menjaga aturan existing “Estimasi sebelum panen Marketing pada tanggal yang sama”.

### Kesimpulan
Belum boleh ditandai 100% PASS sebelum:
1. Dashboard aktif mengurangi panen sebagian.
2. Performa Recording mengurangi panen sampai tanggal recording.
3. Sisa Ayam Real pada Estimasi memakai boundary tanggal yang konsisten dengan snapshot tersimpan.


---

## PERBAIKAN 3 TITIK PRODUKSI 2026-09-28

Status: **SUDAH DIKERJAKAN — hanya area Produksi, RHPP dan modul PASS lain tidak diubah.**

### 1. Dashboard Produksi aktif
- Populasi berjalan sekarang = Chick-In - deplesi recording - panen sampai recording terakhir.
- Data live verifikasi:
  - Chick-In 14.800
  - Deplesi 2.278
  - Panen 6.762
  - Populasi hidup benar 5.760
- Sebelumnya Dashboard membaca 12.522 karena panen belum dikurangkan.

### 2. Performa Recording
- Populasi pada setiap baris recording sekarang mengurangi panen sampai tanggal recording tersebut.
- Perhitungan ini hanya untuk monitoring/pembanding Produksi.
- Tidak digunakan untuk mengubah RHPP.

### 3. Estimasi
- Sisa Ayam Real pada Estimasi memakai panen dengan tanggal **lebih kecil dari** tanggal estimasi.
- Panen pada tanggal yang sama tidak dikurangkan karena aturan existing: Estimasi dibuat sebelum panen Marketing pada hari yang sama.
- Ini menjaga konsistensi dengan data Estimasi lama yang sudah tersimpan.

### Batas Integrasi
- Recording dan Estimasi adalah monitoring/pembanding Produksi.
- Estimasi tidak menjadi input RHPP.
- Perubahan ini tidak menyentuh fungsi RHPP, snapshot RHPP Mitra, Finance, Logistik, Marketing, atau Expedisi.

### Asset live
- `main-1958.js?v=2134-production-consistency`

### Commit
- `8113da32b1e9ad7b6235457785480fda8845e13b` — tiga perbaikan konsistensi Produksi.
- `e857e59c3e283fac84a2904da54dfaea4c36b10c` — refresh asset.


---

## AUDIT TOTAL LOGIN → LAPORAN GLOBAL 2026-09-28

Status: **BELUM 100% PASS — perhitungan utama PASS, tetapi ada blocker isolasi role dan definisi RHPP.**
Audit ini tidak mengubah kode aplikasi.

### PASS — Login / Session
- Login memakai Supabase Auth password.
- Profil wajib aktif sebelum masuk aplikasi.
- Profil user tidak duplikat dan tidak orphan.
- 8 akun aktif terpetakan: ADMIN 1, KEUANGAN 1, LOGISTIK 1, MARKETING 1, OWNER 2, PPL 2.
- Asset login BMS direferensikan dan CSS login tersedia.
- Cache main asset menggunakan versi `2134-production-consistency` dan no-store aktif.

### PASS — Integritas Siklus / Produksi
- Total siklus 8: 1 aktif, 7 CLOSED.
- MITRA tanpa kontrak: 0.
- MANDIRI memakai kontrak: 0.
- Siklus tanpa Performance: 0.
- CLOSED Mitra tanpa snapshot final: 0.
- CLOSED Mandiri tanpa snapshot final: 0.
- Snapshot final pada siklus aktif: 0.
- Duplicate Chick-In per assignment: 0.
- Chick-In invalid DOA/populasi: 0.
- Panen invalid: 0.
- Total panen mismatch Kg × Harga: 0.
- Trigger lock CLOSED tersedia pada Chick-In, Recording, Estimasi, Panen, Logistik, Retur, Tambah Daging, ABK result, Visits, dan child rows terkait.

### PASS — Keuangan / Laporan Global
- Overpayment Mandiri: 0.
- Supplier payment non-positive: 0.
- Laba/Rugi Kandang v2: identitas matematika mismatch 0.
- Hutang Supplier: negative balance 0; status mismatch 0.
- Expedisi: identitas Pendapatan − BOP − Perawatan mismatch 0.
- Laporan perusahaan/global: identity mismatch 0.
- Cashflow live: 201 entries; sumber supplier mengikuti payment actual.
- Global P/L yang diuji konsisten dengan Kandang + Expedisi − BOP Umum.

### BLOCKER 1 — Recording masih memengaruhi RHPP Final
Aturan terbaru: Recording hanya pembanding/monitoring dan tidak boleh menjadi sumber nilai RHPP final.
Namun `finance_rhpp_summary_v5()` saat ini memilih `recorded_depletion_birds` sebagai `effective_depletion_birds` bila Recording memiliki nilai.
Dampaknya:
- mortality_pct RHPP dipengaruhi Recording;
- IP RHPP dipengaruhi Recording;
- bonus IP / bonus depletion dapat dipengaruhi Recording;
- `admin_close_production_atomic()` menyimpan hasil v5 itu ke snapshot RHPP final.
Live: dari 7 CLOSED, ada 1 snapshot dengan selisih recorded-vs-implied sebesar maksimum 557 ekor.
Ini bertentangan dengan keputusan Bos bahwa Recording hanya pembanding.

### BLOCKER 2 — Kebocoran Panen antar-kandang untuk PPL
Policy `marketing_contract_harvest_read` memberi PPL SELECT tanpa `can_read_assignment()`.
Tes sebagai akun PPL asli:
- assignment yang boleh terlihat langsung: 5;
- Panen yang terlihat via RLS: 119 rows dari 8 assignment.
Artinya PPL dapat membaca Panen kandang lain melalui Data API walaupun UI melakukan filter.

### BLOCKER 3 — RPC RHPP PPL tidak scoped per assignment
`finance_rhpp_summary_v5()` adalah SECURITY DEFINER dan hanya memeriksa role, tidak membatasi PPL ke `ppl_id=auth.uid()`.
Tes sebagai PPL:
- assignment langsung terlihat: 5;
- RPC RHPP mengembalikan: 8 assignment.
Ini kebocoran antar-kandang.

### BLOCKER 4 — Marketing dapat membaca Estimasi Produksi
Policy `production_estimates` mengizinkan MARKETING membaca Estimasi.
Tes live sebagai Marketing:
- production_estimates terlihat: 13 rows.
Menu Estimasi tidak ada di Marketing dan scope kerja Marketing tidak membutuhkan data Estimasi Produksi.
Untuk isolasi role ketat, akses ini harus ditutup.

### SECURITY WARNINGS
Supabase Advisor masih melaporkan:
- 1 SECURITY DEFINER RPC executable oleh anon: `production_ppl_directory()`.
  Tes anon saat audit mengembalikan 0 row, jadi belum ada kebocoran live, tetapi permission tetap terlalu luas.
- SECURITY DEFINER authenticated warnings pada banyak RPC; sebagian memiliki role check internal.
  Yang terbukti bermasalah adalah scope PPL di `finance_rhpp_summary_v5()`.
- Leaked Password Protection Supabase Auth masih disabled.
- 2 counter tables RLS aktif tanpa policy; saat ini dipakai internal RPC, bukan UI langsung.

### ROUTING / UI
- 65 tab visible terpetakan.
- `harga_hidup` dan `bonus_kontrak` tidak memakai branch khusus karena dirender melalui generic module renderer; bukan route hilang.
- Role gating UI memakai `visibleTabs`; namun database RLS/RPC tetap harus menjadi sumber keamanan utama.

### Kesimpulan
Belum boleh diberi label 100% PASS sebelum minimal:
1. Pisahkan Recording dari perhitungan RHPP final sesuai keputusan terbaru.
2. Scope SELECT Panen PPL dengan assignment/PPL.
3. Scope `finance_rhpp_summary_v5()` untuk PPL ke assignment sendiri.
4. Tutup akses Marketing ke Estimasi Produksi jika mengikuti role matrix ketat.
5. Review warning login security (leaked-password protection dan anon execute) untuk target security 100%.
