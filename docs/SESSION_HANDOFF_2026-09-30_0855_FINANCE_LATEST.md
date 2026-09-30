# SESSION HANDOFF — 2026-09-30 08:55 WIB — titik lanjut terbaru

## Wajib dibaca saat chat baru
Ini titik lanjut terbaru sesi keuangan. Baca file ini, docs/SESSION_HANDOFF_2026-09-30_BOP_RECONCILIATION.md, dan docs/SESSION_HANDOFF_2026-09-30_FINANCE.md. Ambil source terbaru branch main dan verifikasi database sebelum perubahan. Histori chat lama bukan sumber untuk mengembalikan data. Jangan memulai audit/import ulang yang sudah selesai.

Repository: Bagjasindo/BMS-Mitra-Mobile, branch main.
Source aplikasi: main-1958.js; loader index.html.
Supabase project: mqqrfhwqgcpkjeaasdsr.
Permintaan terakhir user: catat sampai titik ini di GitHub agar chat baru tidak kembali ke awal. Tidak ada instruksi baru untuk mengubah transaksi setelah audit.

## Perubahan paling terakhir: RHPP Real terlihat di Laba/Rugi
User: “RHPP real di laba rugi tidak ada harusnya kan ada biar jelas”.
Temuan: RHPP Real sebenarnya sudah dihitung oleh finance_cycle_profit_loss_v2, namun diberi label generik Pendapatan. Field RPC rhpp_real dipakai bersama: MITRA dari rhpp_real; MANDIRI dari penjualan/final Mandiri.
Perbaikan:
- financeBarnProfitLossPage: ringkasan terpisah RHPP Real Mitra dan Penjualan Mandiri; rincian dua kolom terpisah; kolom yang tidak berlaku memakai —.
- financeGlobalProfitLossPage: subtotal RHPP Real Mitra dan Penjualan Mandiri terpisah serta dua kolom rincian. Total pendapatan tetap gabungan.
- Tidak mengubah rumus laba, data transaksi, klasifikasi siklus, atau sumber nilai.
- Commit source: 80ac51890048d401828bc09964406b3735666b25.
- Commit loader: 1e322001defae886f88c71c888ed92660b2ed579.
- Cache loader: v=2222-rhpp-real-profit.
Verifikasi: node --check lolos; render fungsi Laba/Rugi Kandang dengan data simulasi MITRA/MANDIRI lolos, subtotal dipisahkan dan laba sama. Definisi RPC diperiksa. 5 RHPP Real database berjumlah Rp741.936.523. Panggilan RPC langsung tanpa konteks akun ditolak sesuai guard akses. Browser dengan sesi login pengguna belum diuji; jangan mengklaim pengujian end-to-end browser.

## Keputusan keuangan yang tetap berlaku
- Sederhana: Arus Kas berjalan + Laba/Rugi; owner tidak memberi saldo awal, jangan buat saldo awal fiktif. Tampilan kas memakai Selisih Kas Periode.
- Kamar terpisah: BOP Produksi per kandang/siklus; Perawatan/Perbaikan Kandang per kandang tanpa siklus; BOP Umum perusahaan; usaha Expedisi tersendiri.
- Mangdelon perbaikan masuk Perawatan/Perbaikan Kandang. Keterangan GROUP dibagi empat kandang dengan total tetap, bukan diduplikasi.
- Tambah Daging dan Sapronak tambahan terpisah dari BOP, mengurangi laba sesuai sumber; pembayaran dicatat sekali melalui pembayaran supplier.
- Jangan menghapus data web, mengubah dua Mandiri menjadi Mitra, membuat siklus Mandiri tambahan otomatis, atau mengulang input periode cocok.
- Kategori EKSPEDISI sudah dihapus dari pilihan BOP Produksi dan Excel migrasi, bukan dari modul usaha Expedisi/data historis. Pilihan BOP Produksi: OVK, TENAGA_KERJA, TRANSPORTASI, LISTRIK, GAS, AIR, SEKAM, SANITASI, OPERASIONAL, LAINNYA.
- Navigasi Logistik > Expedisi > Operasional: Data/Operasional. Keuangan > Keuangan Expedisi: Penerimaan, BOP, Perawatan, Laporan.
- Biaya paid_by OWNER pada bop/bop_outside/barn_maintenance_costs tetap biaya laba, tidak keluar kas perusahaan. Default data lama COMPANY bukan bukti sumber pembayaran. Supplier/Expedisi belum tercakup flag ini.
- 7 CLOSED dibuka untuk pencatatan BOP keuangan saja; produksi tetap CLOSED. ADMIN buka/kunci melalui RPC; KEUANGAN bisa mencatat saat dibuka. Jangan membuka produksi hanya untuk pencatatan.

## Status audit terakhir — belum semuanya masuk
Arsip DATA PETERNAKAN(2).rar diekstrak ulang: 15 XLSX; SHA256 2a6cb1663e28208fd2c82d575a93e2828b89704995e446f4ec3037843846c235.
Library source ID libfile_0b7788878e7c8191a680137e8cba85e0; user file ID file_0000000018c48207a893e95ce634f149.
7 periode cocok nominal per tanggal (BOP + daging), BUKAN PASS kategori menyeluruh:
Baturuyuk Juni, Randegan April/Juli, Cicurug Juni/Agustus, Bantrangsana Juni/Agustus.
Masih perlu:
1. Cicurug April operasional Rp69.766.536: belum pemetaan periode; jangan otomatis buat Mandiri ketiga.
2. Baturuyuk April Rp950.000: belum pemetaan periode; jangan invent siklus.
3. Baturuyuk Agustus lampu pilot dan pasang 7 September Rp50.000: sudah keluar BOP tetapi belum masuk Perawatan.
4. Tambah Daging sudah terpisah (4 pembelian). Pembayaran supplier belum tercatat (supplier_payments kosong). Jangan menyebut pasti belum dibayar di dunia nyata.
5. Randegan 15 Agustus sumber daging Rp3.800.000, web 382kg x Rp10.000 = Rp3.820.000. BOP lain tanggal sama dikurangi Rp20.000 sehingga total cocok. Ini perbedaan alokasi kategori, bukan total uang hilang. Perlu bukti harga/nilai atau instruksi mengikuti sumber sebelum koreksi.
6. Sapronak Mandiri final sudah masuk laba: Cicurug Juni Rp770.405.100; Randegan April Rp219.494.300. Rincian pembelian/alokasi/pembayaran belum ada. Jangan menggandakan biaya snapshot dengan detail baru.
7. Sumber SAP Cicurug Juni Rp776.242.600 vs RHPP gross Rp777.192.600, beda Rp950.000 sebelum retur Rp6.787.500. Web mengikuti RHPP net; perlu rekonsiliasi sumber.
8. Kasbon “sisa kasbon” 8 transaksi tanggal 28 September Rp24.700.000 sudah masuk, tetapi arus kas menganggap pengeluaran baru. Perlu konfirmasi apakah saldo pinjaman lama.
Tambahan sapronak Baturuyuk 25 September Rp14.700.000 sudah terpisah; lebih baru dari cutoff arsip operasional.
BOP terakhir 460 baris Rp395.092.815. Perawatan Kandang/BOP Umum kosong saat audit. Tidak ada transaksi keuangan diubah selama audit atau perbaikan label RHPP terakhir.

## Excel yang sudah dibuat
BMS_Pemindahan_Data_Lama.xlsx — Library ID libfile_15185ed917e081918227d37cfb1079e5, version 1.
Workbook migrasi keuangan: 283 transaksi sumber dipertahankan di Data Lama. Sheet input sengaja kosong agar kategori/periode dipilih berdasarkan bukti; jangan mengklaim data sudah dipindah otomatis.
Sheet input RHPP Real, BOP Produksi, Perawatan Kandang, BOP Umum, Penerimaan Mandiri, Pembayaran Supplier, Kasbon Karyawan, Bayar Kasbon, Penerimaan Expedisi, BOP Expedisi, Perawatan Expedisi, Perlu Ditentukan.
Total sumber masuk Rp3.355.326.333; keluar Rp2.964.490.025; selisih Rp390.836.308. Status SIAP DICEK hanya kelengkapan, bukan PASS web.
Workbook lama otomatis BMS_Pencatatan_Otomatis.xlsx juga ada (Library ID libfile_e3373cc5f8cc8191a70757ba1898b449); bukan audit kategori. VBA terpisah opsional, belum diuji runtime/ditanam ke xlsm.

## Cara melanjutkan
Baca current main dan handoff di atas; jawab user dari status ini. Bila diminta membereskan selisih, kerjakan berdasarkan bukti, pertahankan Mandiri/Mitra dan nominal total, verifikasi setelah perubahan. Jangan memperlakukan permintaan simpan handoff ini sebagai izin impor/hapus/mengubah transaksi.
