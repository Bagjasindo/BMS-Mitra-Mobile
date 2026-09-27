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
