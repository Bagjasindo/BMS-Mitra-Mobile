# Pemulihan BMS — build 2343

Sumber aplikasi dan schema ada di repository. `supabase/schema_current.sql` adalah snapshot schema tersinkron sampai audit hulu-hilir 2026-10-03; berisi 79 tabel public, 11 view, fungsi, trigger, indeks, RLS dan grant. Tidak berisi baris bisnis atau password. SQL patch `audit_*.sql` sudah diterapkan pada proyek aktif; jangan menjalankan semua SQL historis secara berurutan.

## Backup

ADMIN aktif membuka Arsip Data, mengisi password backup minimal 12 karakter, lalu **Simpan Backup Terenkripsi**. Simpan file `.bmsbackup` dan password di tempat aman yang terpisah. AES-256-GCM, PBKDF2-SHA256 250.000 iterasi; salah password/perubahan ciphertext ditolak. Backup mencakup 79 tabel public, akun/identitas/faktor MFA, serta hasil operasi idempotensi. Password pengguna berupa hash, tidak pernah password asli. Jangan membagikan file yang telah didekripsi.

Excel adalah arsip untuk pemeriksaan, bukan backup pemulihan akun. Snapshot harian database tetap pukul 02:00 WIB dan hanya mencakup data public. Salinan dalam database yang sama tidak cukup bila proyek hilang; unduh backup terenkripsi setelah perubahan penting dan simpan di luar proyek. Storage saat audit kosong; bila mulai menyimpan berkas, operator wajib menyertakan salinan objek Storage. Sesi/token login tidak dipulihkan; pengguna login ulang.

## Drill tanpa perubahan produksi

Jalankan sebagai operator database dalam transaksi yang diakhiri ROLLBACK:

```sql
BEGIN;
SELECT set_config('request.jwt.claim.sub', user_id::text, true)
FROM public.profiles WHERE role='ADMIN' AND active LIMIT 1;
SELECT private.bms_verify_recovery(public.bms_export_recovery_document(),
  'bms_restore_verify_drill');
ROLLBACK;
```

Fungsi operator menolak nama schema produksi atau schema yang sudah ada. Ia membangun tabel bertipe, memeriksa checksum dan setiap nilai akun/data, lalu membuat serta memvalidasi semua FK. Hasil drill 2026-10-01: PASS, 79 tabel dan 16 baris Auth. Bootstrap schema juga dibuat ulang, diisi seluruh data public, dan semua FK tervalidasi di schema terpisah, lalu dibatalkan.

## Pemulihan setelah kehilangan proyek

Hanya operator yang berwenang boleh menjalankan prosedur ini pada **proyek Supabase baru dan kosong**. Cocokkan versi managed Auth/Postgres; jangan menimpa proyek aktif.

1. Buat proyek baru, terapkan `supabase/schema_current.sql` melalui koneksi database pemilik. Extension pgcrypto pada schema `extensions` diperlukan; Supabase menyediakan schema managed `auth` dan `storage`. Aktifkan pg_cron dan buat kembali jadwal di bawah.
2. Dari terminal interaktif Node 24, jalankan `node scripts/decrypt-recovery.cjs input.bmsbackup protected-recovery.json`. Password tidak ditampilkan atau dikirim ke server.
3. Jalankan `python scripts/prepare-restore.py protected-recovery.json protected-restore.sql`. File keluaran mode 0600 berisi data sensitif. Jalankan melalui psql sebagai pemilik database. Guard SQL menolak jika Auth atau salah satu tabel public sudah berisi data. Seluruh pemulihan satu transaksi; kegagalan membatalkan semuanya.
4. Deploy kedua sumber `supabase/functions/*/index.ts`. `admin-create-bms-user`: JWT verification aktif. `bms-backup-download`: JWT verification tidak aktif, tetapi token backup diperiksa RPC server. Isi konfigurasi server melalui secrets proyek; jangan masukkan service key ke browser/repository.
5. Perbarui URL dan publishable key proyek pada sumber klien, publish aplikasi, lalu uji login baru tiap role, laporan dan transaksi uji sebelum mengalihkan pengguna. Auth URL, redirect, SMTP, paket/keamanan Auth, Storage/bucket dan secrets adalah konfigurasi layanan; tidak dipulihkan oleh SQL.
6. Hapus plaintext dan SQL pemulihan dari lingkungan operator setelah verifikasi. Simpan `.bmsbackup` yang terenkripsi.

Jadwal aktif yang harus dipulihkan:

```sql
SELECT cron.schedule('bms-daily-backup-0200-wib','0 19 * * *',
  'select bms_backup.create_daily_snapshot();');
SELECT cron.schedule('bms-daily-backup-token-0201-wib','1 19 * * *',
  'select bms_backup.create_download_token();');
```

**Batas verifikasi:** pemulihan data, akun, FK dan pembangunan schema sudah diuji. Belum dilakukan failover proyek baru, login GoTrue setelah bencana, penggantian secrets, atau pengiriman email dari proyek baru. Operator wajib menjalankan langkah 5 saat drill proyek penuh.
