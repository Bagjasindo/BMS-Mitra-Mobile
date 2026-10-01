# HANDOFF CURRENT — BMS Mitra Mobile

Tanggal checkpoint: 2026-10-01
Branch: main
Repo: Bagjasindo/BMS-Mitra-Mobile

## Titik kerja resmi

Checkpoint ini menggantikan checkpoint ikon PWA sebelumnya. Lanjutan pekerjaan dimulai dari audit mendalam 18 temuan: 1 kritis, 4 tinggi, 11 sedang, 2 rendah.

## Status perbaikan audit

- Otorisasi profil aktif/null-safe: DITERAPKAN.
- Jalur perubahan role/user admin: hanya profil ADMIN aktif; self-demotion/deactivation ditolak.
- Validasi pembayaran dan overpayment: DITERAPKAN.
- Serialisasi transaksi pembayaran/concurrent write: DITERAPKAN.
- Pencegahan double-submit/retry ganda: DITERAPKAN melalui operation ID + receipt.
- Jejak koreksi/transaksi: trigger audit transaksi aktif.
- Ekspor seluruh data: DITERAPKAN secara catalogue-driven; verifikasi 79/79 tabel public.
- Backup harian: menggunakan sumber arsip lengkap yang sama.
- Full recovery: dokumen recovery terenkripsi di frontend dan verification restore tersedia untuk schema terisolasi.
- RLS public: aktif pada 79 tabel.
- Direct write RPC: DITUTUP. 61 RPC bisnis allowlisted tidak dapat dieksekusi langsung oleh authenticated/anon/PUBLIC; write resmi melalui public.bms_execute_operation().
- Lima write RPC yang sempat tertinggal sudah ditambahkan ke gateway: admin_reopen_production_atomic, finance_save_abk_advance_atomic, logistics_send_warehouse_stock_atomic, save_production_abk_harvest_atomic, save_production_abk_result_atomic.

## Verifikasi terakhir

- Complete archive: 79 live tables = 79 archived tables = 79 payload tables; checksum SHA-256 tersedia.
- Payment guard + transaction audit terpasang pada tabel pembayaran utama.
- Direct access allowlist: authenticated=0, anon=0, PUBLIC=0.
- Gateway: authenticated boleh execute; anon tidak.
- Build aplikasi: 1.0.2326.
- Regression suite di repo: 8 core tests termasuk lost-response idempotency, stable UUID retry, complete reads, XLSX, dan encrypted recovery.
- Perbaikan database audit awal tercatat pada migrasi 20261001071942 s.d. 20261001083959.
- Hardening lanjutan tercatat pada migrasi 20261001102332 dan 20261001102415.
- SQL reproduksi hardening disimpan di supabase/20261001_audit_write_gateway_hardening.sql.

## Catatan advisor

Peringatan SECURITY DEFINER yang tersisa terutama fungsi baca/report serta gateway/export yang memang perlu callable oleh authenticated dan memiliki guard role di dalam fungsi. Empat INFO RLS-no-policy adalah objek yang deny-by-default/private atau diakses melalui fungsi terkontrol.

Satu peringatan platform masih ada: Supabase Auth Leaked Password Protection disabled. Commit audit sebelumnya mencatat fitur built-in tersebut tidak diaktifkan karena keterbatasan plan; tidak dilakukan upgrade berbayar.

## Aturan lanjut

Jangan kembali ke histori audit/ikon lama kecuali ada regresi baru. Mulai pemeriksaan berikut dari checkpoint ini dan pertahankan data bisnis produksi; perubahan schema harus lewat migration dan perubahan kode harus dicatat di GitHub.
