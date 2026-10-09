# BMS Mitra Mobile — Status Audit Berkelanjutan

**Audit terbaru:** 2026-10-09 (WIB)  
**Repository:** `bagjasindo/BMS-Mitra-Mobile`, branch `main`  
**Target:** Build 2386-classic-restored  
**Database:** Supabase project `mqqrfhwqgcpkjeaasdsr`  
**Metode audit ini:** pembacaan kode/dokumen GitHub, query SELECT dan advisor Supabase. **Tidak melakukan transaksi uji, mutasi database, ataupun mengubah aplikasi.** File ini adalah catatan audit, bukan sertifikat PASS end-to-end.

## Cara menggunakan catatan di chat berikutnya
1. Baca `AUDIT_STATUS.md` lalu `AUDIT_HULU_HILIR_LOCK_20261003.md` dan `LOCKED_BUSINESS_RULES.md`.
2. Periksa commit terbaru. Gunakan temuan PASS di bawah sebagai baseline **pada tanggal dan cakupan yang tercantum**.
3. Jangan mengulang seluruh audit tanpa adanya perubahan relevan, insiden, atau permintaan eksplisit; lakukan pengujian dampak pada bagian yang berubah.
4. Status **PASS pengguna**, **PASS query live**, **PASS test otomatis**, dan **BELUM DIUJI** tidak boleh dicampur.
5. Jangan mengubah tema Desktop klasik, alur kerja pengguna, SOP peran, data historis, atau aturan bisnis yang terkunci tanpa persetujuan.
6. Setelah perubahan baru, tambahkan hasil audit, tanggal, jenis pengujian, dan bukti/commit di dokumen ini.

## 1. Hasil PASS TERBATAS — Database live (SELECT, 2026-10-09)
| Pemeriksaan | Hasil | Status |
|---|---:|---|
| RLS pada seluruh tabel basis data `public` | 81 dari 81 aktif | **PASS (cakupan RLS enablement)** |
| Duplikasi `finance_expedition_invoices.invoice_number` | 0 | **PASS** |
| Orphan `finance_expedition_invoice_items` → invoice/trip | 0 | **PASS** |
| Orphan `finance_expedition_payments` → invoice | 0 | **PASS** |
| Kandang dengan lebih dari satu assignment aktif (`logistics_contract_assignments`) | 0 | **PASS** |
| Recording mortalitas/culling/feed_kg negatif (`recordings`) | 0 | **PASS** |
| Quantity/quantity_kg pengiriman negatif (`logistics_shipment_items`) | 0 | **PASS** |

Catatan: RLS ENABLED **bukan** bukti seluruh kebijakan keamanan sudah benar; tidak ada duplikasi/orphan **bukan** bukti seluruh perhitungan keuangan konsisten.

## 2. Temuan terbuka — jangan tandai PASS
### Keamanan Supabase advisor (2026-10-09)
- **37 WARN** `authenticated_security_definer_function_executable`: perlu review pemeriksaan peran/objek masing-masing RPC. Jangan mencabut izin `authenticated` secara massal.
- **1 WARN** `auth_leaked_password_protection`: opsi platform Auth memerlukan penanganan tersendiri.
- **4 INFO** `rls_enabled_no_policy`: evaluasi apakah sengaja deny-by-default untuk tabel internal.
- Delapan fungsi `SECURITY DEFINER` yang sebelumnya callable oleh `anon` **sudah ditutup izin anon** dan akses `authenticated` tetap aktif (perbaikan 2026-10-09, diverifikasi query dan security advisor). Ini bukan bukti pengujian transaksi per akun.

### Performa Supabase advisor (2026-10-09)
- **13 WARN** `multiple_permissive_policies`: evaluasi biaya query dan cakupan policy, jangan menggabungkan policy tanpa regresi izin.
- **14 INFO** `no_primary_key` (snapshot/rollback `private` pada advisor sebelumnya).
- **81 INFO** `unused_index`; jangan hapus indeks otomatis.
- `unindexed_foreign_keys` sudah hilang setelah indeks `finance_cash_request_items(request_id)` ditambahkan (2026-10-09).

### Belum cukup bukti untuk PASS end-to-end
- Fungsi transaksi penuh **setiap peran** (ADMIN, OWNER, KEUANGAN, LOGISTIK, MARKETING, PPL) sedang diuji pengguna secara bertahap; belum ada matriks per-fitur/per-peran terarsip.
- Pencocokan seluruh angka **Arus Kas, Piutang/Hutang, RHPP, dan Laba Rugi Global** dengan transaksi sumber belum dijalankan ulang dalam audit ini.
- Tidak ada pengujian load 1.000–10.000 transaksi, pemulihan backup terbaru, atau test browser langsung pada audit ini.
- Tidak ada hasil aktual `npm run check` / `npm run test:browser` yang dijalankan pada audit ini. Isi test dan file workflow sudah ditinjau; ini **BUKAN PASS eksekusi CI saat ini**.

## 3. PASS yang dilaporkan pengguna, bukan hasil audit kode otomatis
Pada 2026-10-09, pengguna melaporkan **8/8 PASS** untuk daftar maksimal 10 baris, pencarian, filter tanggal/status (jika ada), pagination, reset, kontrol sesuai hak akses, Cetak/PDF/Excel, dan kesetaraan Desktop/HP. Catatan: hasil berlaku untuk skenario yang diuji, **tidak berarti setiap tabel di seluruh modul sudah 100% tersertifikasi**.

## 4. Dokumen baseline sebelumnya
`AUDIT_HULU_HILIR_LOCK_20261003.md` mencatat audit build 2340 sebagai `OPERATIONAL PASS — LOCKED`. **Jangan menganggap ini otomatis PASS build 2386.** Pastikan pengujian ulang hanya pada perubahan dan dependensi yang terdampak.

## 5. Pekerjaan berikutnya, tanpa merusak ritme kerja
1. Arsipkan PASS bertahap dari masing-masing akun ke matriks role × fitur, lengkap dengan tanggal dan versi.
2. Audit read-only guard objek/peran untuk 37 RPC privileged dan 13 grup policy yang ditandai advisor; prioritaskan temuan yang memiliki dampak keamanan nyata.
3. Validasi pencocokan transaksi sumber → laporan Arus Kas → laba rugi → RHPP per siklus, tanpa data uji atau pembetulan diam-diam.
4. Jalankan `npm run check`, `npm run test:browser`, dan uji alur peran di lingkungan uji sebelum klaim PASS menyeluruh.
5. Jangan ubah database/kode tanpa temuan terverifikasi dan uji dampak; jangan ulang tugas yang telah benar-benar diverifikasi di baseline relevan.

**Aturan status:** `PASS` hanya untuk pemeriksaan yang dijalankan dan terbukti; `PASS TERBATAS` untuk subset; `BELUM DIUJI` untuk sisa; `TEMUAN` untuk risiko yang masih memerlukan penyelesaian.
