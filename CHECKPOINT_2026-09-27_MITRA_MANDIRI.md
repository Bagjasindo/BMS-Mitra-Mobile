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


## Lanjutan 2026-09-27 — Penerimaan Penjualan Mandiri

Sudah dikerjakan pada branch `checkpoint-mandiri-rhpp-penerimaan-20260927`:

- Database live sudah memiliki `finance_mandiri_sales_receipts`, `finance_receive_mandiri_sale_atomic`, `production_mandiri_rhpp_summary`, dan `finance_cashflow_entries_v2`.
- Ditambahkan menu Keuangan **Penerimaan Penjualan Mandiri** untuk ADMIN dan KEUANGAN.
- Panen Mandiri dari Marketing otomatis muncul sebagai tagihan; tidak ada input ulang penjualan di Keuangan.
- Penerimaan mendukung pembayaran penuh atau sebagian.
- Sisa piutang dihitung otomatis per panen.
- Saat Keuangan menyimpan penerimaan, transaksi otomatis masuk **Arus Kas** melalui `finance_cashflow_entries_v2` dengan sumber `PENJUALAN MANDIRI`.
- Data penerimaan tidak diberi menu edit/hapus agar jejak transaksi keuangan tidak mudah diubah.
- Policy RLS penerimaan dioptimalkan menggunakan `(select auth.uid())`.
- `main-1958.js` sudah lolos pemeriksaan sintaks setelah perubahan.
- Asset version dinaikkan menjadi `2122-mandiri-receipts`.

### Status pengujian

Belum dapat dinyatakan PASS end-to-end dengan data nyata karena database live saat pemeriksaan belum memiliki siklus MANDIRI dan belum memiliki panen MANDIRI. Uji nyata yang masih diperlukan setelah ada satu siklus Mandiri:
Panen Mandiri → muncul di Penerimaan Keuangan → konfirmasi penuh/sebagian → Arus Kas → RHPP/Laporan Keuangan → Laba/Rugi Global.

Modul Mitra yang sudah PASS tidak diubah oleh pekerjaan ini.
