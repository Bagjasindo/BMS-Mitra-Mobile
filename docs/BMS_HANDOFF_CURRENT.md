# Pembaruan 2026-10-01 — audit repair build 2326

Perbaikan keamanan, pembayaran, idempotensi, audit, arsip, tanggal, XLSX, PWA dan modularisasi telah diterapkan. Entry klien sekarang `main-2321.js` dengan `bms-core.js`, `bms-data-config.js`, tujuh script aplikasi (entry + enam modul), dan `bms-start.js`; cache `bms-pwa-shell-2326-audit`. SDK lokal Supabase 2.57.0. `npm ci && npm run check` untuk syntax dan 8 uji.

Schema aktif: `supabase/schema_current.sql`. Pemulihan: `docs/BMS_RECOVERY_RUNBOOK.md`. Patch `audit_*.sql` sudah diterapkan ke database aktif. Tampilan dan logo resmi dipertahankan.

A12 belum PASS: leaked-password protection bawaan Supabase membutuhkan Pro, proyek masih Free. Belum mengaktifkan upgrade berbayar. Jangan menyatakan PASS 100%. Uji browser mencakup shell/login tanpa akun, konfirmasi, guard dan offline shell; pengujian role/data dilakukan melalui SQL terisolasi, bukan login nyata setiap pengguna.

---

## Catatan historis sebelum audit

# BMS CURRENT STATE — 2026-10-01

## SUMBER KEBENARAN
- Repository: `Bagjasindo/BMS-Mitra-Mobile`
- Branch: `main`
- Gunakan hanya current source pada branch `main`.
- Jangan gunakan histori chat lama sebagai acuan proyek.

## TITIK CURRENT
- Current latest commit sebelum handoff bersih ini: `4bf0b97e8ffcde6b4438438d6ae5d629303c0ad7`
- Cache JS aktif: `main-1958.js?v=2301-finance-history-filter-first`
- Cache CSS aktif: `style.css?v=2218-rhpp-exact-cetak`
- Source JS current blob: `671050c7d938373207634844eba1982cf1354685`
- Source CSS current blob: `854bd7c6a9bbab134a0a13fc3548d3d6834d5a2c`

## KONDISI TERAKHIR
- Print RHPP professional yang sudah diterapkan tetap dipertahankan.
- Tombol Simpan/Edit memakai feedback langsung pada tombol dan pengunci double-submit.
- Riwayat transaksi yang sudah direvisi memakai pola filter-first: awal tidak tampil, pilih filter, klik Tampilkan, Reset menyembunyikan kembali, tanpa pagination Sebelumnya/Selanjutnya.
- Area Keuangan sudah masuk revisi filter-first history pada current source.

## BATAS HANDOFF
- File ini hanya mencatat kondisi current sampai titik ini.
- Tidak memuat histori lama.
- Tidak memuat roadmap, daftar pekerjaan lanjutan, atau instruksi untuk melanjutkan revisi berikutnya.
