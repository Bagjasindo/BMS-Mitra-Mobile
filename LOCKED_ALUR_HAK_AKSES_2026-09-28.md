# BMS MOBILE — BASELINE ALUR & HAK AKSES TERKUNCI
Tanggal kunci: 2026-09-28
Repo: Bagjasindo/BMS-Mitra-Mobile
Status: BASELINE OPERASIONAL TERKUNCI

Dokumen ini menjadi acuan utama agar alur kerja, hak akses, dan hubungan antar-modul yang sudah PASS tidak berubah-ubah tanpa keputusan eksplisit dari Bos.

## PRINSIP UTAMA
1. Jangan mengubah modul/menu yang sudah PASS kecuali ada perintah eksplisit.
2. Perubahan baru wajib menjaga alur yang sudah terkunci dan tidak boleh mencampur MITRA dengan MANDIRI.
3. Perubahan hak akses wajib mengikuti baseline ini.
4. Jika ada kebutuhan baru yang berpotensi mengubah baseline, buat sebagai tambahan terpisah terlebih dahulu.
5. Tidak boleh membuat data fake/test di live untuk membuktikan PASS.
6. CLOSED wajib dianggap final dan data operasional terkait harus terkunci.

## LOGIN & SESSION
- Login memakai Supabase Auth.
- Hanya profil aktif yang boleh masuk.
- Role akun berasal dari profiles.
- Akun nonaktif tidak boleh masuk ke aplikasi.
- Logout menghapus sesi aplikasi.

## ROLE TERKUNCI
### ADMIN
- Full control aplikasi.
- Master Data.
- Pembuatan siklus.
- Close Produksi.
- RHPP Sistem / History.
- Keuangan.
- Laporan.
- Arsip data.
- Pengaturan akun/role.

### LOGISTIK
- Siklus/kebutuhan logistik sesuai menu yang diberikan.
- Pengiriman.
- Pembelian Mandiri.
- Sapronak Luar.
- Retur.
- Expedisi operasional sesuai scope.
- Laporan Logistik.
- Tidak mengubah RHPP final.

### PPL
- Hanya assignment/kandang yang memang ditugaskan kepadanya.
- Chick-In pada assignment sendiri.
- Recording pada assignment sendiri.
- Kunjungan pada assignment sendiri.
- Estimasi pada assignment sendiri.
- Rekap Produksi / Laporan PPL pada assignment sendiri.
- Boleh melihat Panen hanya untuk assignment sendiri.
- RPC RHPP hanya boleh mengembalikan assignment milik PPL tersebut.
- Recording dan Estimasi hanya untuk monitoring/pembanding Produksi.
- Recording dan Estimasi TIDAK menjadi sumber nilai RHPP Final.

### MARKETING
- Panen Mitra dan Panen Mandiri dipisah.
- Tambah Daging terpisah.
- Penjualan sesuai alur Marketing.
- Marketing BOLEH membaca Estimasi Produksi sebagai gambaran panen.
- Marketing tidak mengubah RHPP final.

### KEUANGAN
- RHPP Real.
- BOP Produksi.
- Perawatan.
- Hutang Supplier.
- Pembayaran/Penerimaan sesuai modul.
- Kasbon/Cicilan.
- Arus Kas.
- Laporan Keuangan.
- Finance Mandiri.
- Finance Expedisi.
- Tidak mengubah data Produksi operasional.

### OWNER
- Dashboard dan laporan.
- Laba/Rugi Kandang.
- Laba/Rugi Global.
- Laporan Produksi/PPL/Marketing/Logistik/Keuangan/Expedisi sesuai menu read-only.
- Tidak menginput transaksi operasional.

## MITRA vs MANDIRI
### MITRA
- Wajib kontrak.
- Wajib Performance.
- Harga sesuai kontrak.
- RHPP Sistem / RHPP Real tetap jalur Mitra.
- Snapshot CLOSED Mitra di rhpp_system_final.

### MANDIRI
- Tanpa kontrak.
- Wajib pilih Performance template.
- Harga jual manual oleh Marketing.
- Pembelian Mandiri terpisah.
- Penerimaan penjualan dikonfirmasi Finance.
- Snapshot CLOSED Mandiri di production_mandiri_final.
- Tidak mencampur RHPP Real Mitra.

## PRODUKSI / RECORDING / ESTIMASI
- Recording = monitoring/pembanding.
- Estimasi = proyeksi/gambaran panen.
- Recording/Estimasi tidak boleh mengubah nilai RHPP final.
- Dashboard Produksi aktif memperhitungkan:
  Chick-In - deplesi recording - panen sampai recording terakhir.
- Performa Recording mengurangi panen sampai tanggal recording.
- Estimasi tanggal yang sama dengan panen memakai aturan existing:
  estimasi dianggap dibuat sebelum panen Marketing pada hari yang sama.

## RHPP TERKUNCI
- RHPP final tidak memakai Recording sebagai sumber effective depletion.
- Recording tetap tampil sebagai pembanding.
- Deplesi final saat Close Mitra memakai basis final Chick-In - total Panen.
- PPL hanya boleh melihat RHPP assignment miliknya sendiri.
- CLOSED historis tidak boleh ditulis ulang tanpa keputusan eksplisit.

## LOGISTIK / RETUR
- Pengiriman dan Retur tetap menu/alur terpisah.
- Retur Tambah Sapronak adalah stok retur perusahaan, bukan retur supplier.
- Retur stok perusahaan tidak mengurangi hutang supplier.
- Biaya keluar dari siklus asal saat masuk stok retur.
- Saat ditransfer ke kandang tujuan, biaya masuk ke siklus tujuan.

## KEUANGAN
- Arus Kas supplier berbasis pembayaran aktual, bukan nilai invoice saat transaksi.
- Hutang/biaya tetap terpisah dari kas keluar.
- Revenue accrual dan penerimaan kas tidak dicampur.
- Laba/Rugi Mandiri yang tampil sebagai operasional harus diberi label jelas jika belum mengurangi perawatan.
- Pembayaran pelanggan Mandiri mengalir ke cashflow melalui jalur Finance.

## EXPEDISI
- Pendapatan Expedisi.
- BOP Operasional Expedisi.
- Perawatan Expedisi.
- Laba/Rugi Expedisi = Pendapatan - BOP Operasional - Perawatan.

## LAPORAN GLOBAL
- Dasar global:
  laba kandang + laba Expedisi - BOP Umum.
- Tidak boleh double-count komponen yang sudah dibebankan di level kandang/Expedisi.
- Perubahan pada laporan bawahannya tidak boleh mengubah formula global tanpa keputusan eksplisit.

## STATUS AUDIT TERAKHIR
PASS:
- Login/session dan profil aktif.
- Integritas siklus.
- Chick-In.
- Panen.
- Snapshot CLOSED.
- Lock CLOSED.
- Laba/Rugi Kandang.
- Hutang Supplier.
- Cashflow.
- Laba/Rugi Expedisi.
- Laporan Global.
- PPL Panen sudah scoped ke assignment sendiri.
- RPC RHPP PPL sudah scoped ke assignment sendiri.
- Marketing baca Estimasi tetap diperbolehkan.
- Recording sudah dipisahkan dari RHPP Final.

PENDING HARDENING SECURITY TERPISAH:
- Supabase Leaked Password Protection belum aktif.
- production_ppl_directory() masih memiliki permission anon terlalu luas walau tes anon mengembalikan 0 row.

Catatan penting:
Pending hardening di atas TIDAK boleh menjadi alasan untuk mengubah alur bisnis/hak akses yang sudah terkunci di dokumen ini.

## ATURAN PERUBAHAN KE DEPAN
Setiap perubahan wajib:
1. Bandingkan dengan dokumen ini.
2. Jangan ubah PASS lama tanpa alasan dan persetujuan.
3. Jika perubahan perlu mengubah baseline, tulis dulu perubahan yang diusulkan dan dampaknya.
4. Setelah implementasi, audit regresi modul terkait.
5. Update dokumen ini hanya setelah perubahan disetujui dan benar-benar PASS.
