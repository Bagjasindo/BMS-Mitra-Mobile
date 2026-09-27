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
