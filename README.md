# BMS Mitra Online

## Checkpoint 27 September 2026
- Audit alur utama selesai: Logistik, Marketing, Produksi/PPL, Keuangan, Expedisi, Owner.
- Laba/Rugi Kandang, Laba/Rugi Expedisi, dan Laba/Rugi Global sudah dipisahkan.
- Laporan Owner sudah disambungkan ke sumber data terkait.
- Layout cetak/PDF sudah dirapikan ke A4 portrait.
- Bagian/modul yang sudah PASS dianggap terkunci dan tidak diubah tanpa perintah khusus.

## Kondisi Repository
- Root repository hanya berisi file aplikasi aktif, aset resmi, README, dan folder migration/snapshot Supabase.
- File SQL Supabase dipertahankan sebagai riwayat perubahan dan referensi pemulihan; bukan file sampah.
- Tidak ada file sampah yang terbukti aman untuk dihapus pada audit checkpoint ini.

## Rencana Berikutnya
1. Backup bersih source GitHub dan snapshot Supabase ke PC lokal.
2. Uji singkat hasil backup dan pastikan file dapat dibuka kembali.
3. Siapkan domain resmi.
4. Hubungkan domain ke hosting aplikasi setelah DNS siap.
5. Uji HTTPS, login, Supabase, cetak/PDF, dan semua role melalui domain.
6. Setelah stabil, tetapkan domain sebagai alamat produksi resmi.

## Catatan Domain
- Target: domain resmi milik perusahaan, tanpa memindahkan database sebelum diperlukan.
- Source tetap dapat berada di GitHub Pages atau dipindahkan ke hosting lain bila dibutuhkan.
- Perubahan domain tidak mengubah data Supabase; yang berubah hanya alamat akses aplikasi dan konfigurasi hosting/DNS.
