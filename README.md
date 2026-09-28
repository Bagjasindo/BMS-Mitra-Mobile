# BMS Mitra Online

## Garis Ketat RHPP Real
- **Sumber RHPP Real hanya Logistik dan Marketing.**
- **Logistik menjadi sumber Chick-In dan seluruh sapronak real: pengiriman, retur, tambah sapronak, transfer/alih barang, dan nilai biayanya.**
- **Marketing menjadi sumber panen real: Chick-Out/ekor panen, berat, harga, nilai panen, serta tambah daging bila ada.**
- **Mortalitas/Deplesi RHPP dihitung dari data real Chick-In Logistik dibanding Chick-Out/Panen Marketing.**
- **Recording PPL hanya monitoring operasional/produksi dan tidak boleh masuk, mengubah, mengoreksi, atau menjadi pembanding RHPP Real.**
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

