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
