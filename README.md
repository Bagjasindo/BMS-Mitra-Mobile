# BMS Mitra Online

## Garis Ketat RHPP Real
- **Recording PPL hanya untuk monitoring operasional/produksi dan bukan sumber data RHPP Real.**
- **Data Recording PPL dilarang dipakai untuk menghitung atau mengoreksi Mortalitas/Deplesi, Chick-In, Chick-Out, FCR, IP, nilai panen, biaya, bonus, laba, atau komponen RHPP Real lainnya.**
- **RHPP Real harus bersumber dari data transaksi/final yang memang ditetapkan untuk RHPP, bukan dari data monitoring PPL.**
- Perubahan kode, SQL, view, RPC, laporan, atau rekonsiliasi yang membuat Recording PPL memengaruhi RHPP Real dianggap melanggar aturan ini dan tidak boleh diterapkan tanpa instruksi eksplisit Administrator.

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

## Tambahan Mitra / Mandiri
- Pembuatan siklus sekarang memilih **Mitra** atau **Mandiri**.
- Mitra tetap memakai kontrak dan harga panen otomatis dari kontrak.
- Mandiri tidak memakai kontrak, tetapi tetap wajib memilih **Performa BMS / Performa Bounty** sebagai acuan Produksi/PPL; Logistik memakai **Pembelian Mandiri** dengan harga beli aktual dan pembagian langsung ke beberapa kandang.
- Sisa jumlah pembelian yang belum dibagi tercatat sebagai sisa gudang pada transaksi pembelian.
- Marketing memiliki **Master Pelanggan**; Panen Mandiri memilih pelanggan dan harga jual diinput manual.
- Produksi/PPL, recording, BOP, dan struktur kandang tetap memakai alur yang sudah ada.
- Laba/Rugi Kandang dan Laba/Rugi Global membaca Mitra dan Mandiri dalam laporan yang sama tanpa mencampur rumus sumber pendapatannya.

