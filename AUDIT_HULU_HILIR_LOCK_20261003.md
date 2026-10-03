# BMS Mobile — AUDIT HULU KE HILIR & OPERATIONAL LOCK

Tanggal audit: 2026-10-03  
Baseline aplikasi: **build 2340-dead-code-cleanup**  
Status: **OPERATIONAL PASS — LOCKED**

Dokumen ini mengunci baseline aplikasi setelah audit hulu-ke-hilir. Perubahan sesudah baseline ini wajib menjaga `LOCKED_BUSINESS_RULES.md` dan lulus seluruh Verify application.

## 1. Build / Deploy / PWA — PASS
- Build 2340 Verify application PASS.
- GitHub Pages deployment build 2340 PASS.
- Service worker menggunakan cache build 2340.
- Loader memiliki retry dan timeout yang aman.
- Browser smoke test sudah menjadi bagian wajib CI:
  - login shell termuat tanpa error,
  - cache aplikasi tersedia,
  - cache aplikasi lain tidak dihapus,
  - tombol password bekerja,
  - submit guard mencegah double-input,
  - shell dapat dimuat offline,
  - viewport mobile 390px tidak overflow.

## 2. Dead Code / Runtime — PASS
- Dead function/helper yang terbukti tidak digunakan telah dihapus.
- Query `production_feed_stock` fan-out yang hasilnya tidak digunakan telah dihapus.
- Scan statis terakhir: tidak ada fungsi/variabel sederhana yang hanya didefinisikan sekali tanpa pemakaian.
- `bms-start.js` dipertahankan karena merupakan bootstrap setelah seluruh modul selesai dimuat.

## 3. Business Rules — PASS / LOCKED
Seluruh LOCK-001 s/d LOCK-009 pada `LOCKED_BUSINESS_RULES.md` berlaku.
Guard otomatis ada di `tests/locked-business-rules.test.cjs`.

## 4. Produksi / PPL — PASS
- Dashboard Kandang Aktif tetap menunggu Chick-In.
- Pembagian ABK = DOC datang, bukan DOC datang dikurangi Mati Box.
- Tidak ada Chick-In ganda per assignment.
- Tidak ada mismatch total pembagian ABK terhadap DOC datang.
- Tidak ada duplicate result Liga ABK per assignment+ABK.
- Tidak ada orphan ABK link/result.
- Rekap Produksi PPL utama dari Liga ABK; CLOSED historis tanpa Liga ABK memakai snapshot final nyata.
- Tidak ada CLOSED cycle tanpa snapshot final.

## 5. Kontrak / RHPP — PASS
- MITRA aktif tidak ada yang kehilangan master contract.
- MANDIRI tidak ada yang kehilangan template performa.
- MANDIRI tetap memakai **Kontrak Acuan Penilaian** untuk pembanding yang adil.
- Tambah Daging ikut performa RHPP dan harga kontrak berdasarkan BW.
- Tambah Sapronak/Pakan Tambahan berada di luar RHPP kontrak.
- Nilai RHPP kontrak dihitung dulu, lalu biaya perusahaan dikurangkan.
- Close Produksi menyimpan hasil akhir setelah Tambah Daging + Tambah Sapronak.

## 6. Marketing / Logistik — PASS
- Tidak ada panen dengan ekor/kg tidak valid.
- Tidak ada Tambah Daging dengan berat/harga tidak valid.
- Tidak ada orphan shipment item.
- Tidak ada orphan return item.
- Guard harga Tambah Daging aktif di database.

## 7. Keuangan / Expedisi — PASS
- Tidak ada orphan invoice item Expedisi.
- Tidak ada orphan supplier payment.
- Jalur cetak tidak lagi mengarang nilai NULL sebagai 0.
- Identitas dokumen mengambil Master Data Perusahaan.
- Data SIMULASI / PLACEHOLDER / DUMMY / TEST tidak ditemukan pada transaksi utama yang diaudit.

## 8. Database Integrity / RLS — PASS
- 79/79 tabel public: RLS ENABLED.
- Semua tabel public mempunyai primary key.
- Tidak ada policy anon/public yang membuka INSERT/UPDATE/DELETE.
- Tidak ada dua siklus aktif pada kandang yang sama.
- Tidak ada orphan final production.
- Tidak ada recording dengan mortalitas/culling/pakan negatif.

## 9. Security Advisor — ACCEPTED WITH ONE PLATFORM HARDENING ITEM
Advisor Supabase masih menampilkan:
- 4 INFO `rls_enabled_no_policy`: tabel internal/counter/adjustment yang sengaja deny-by-default.
- 25 WARN SECURITY DEFINER callable oleh authenticated: fungsi yang diaudit memakai auth/role guard atau helper `private.my_bms_role()`; tidak dibuka untuk anon.
- **1 WARN: Leaked Password Protection disabled.** Ini adalah konfigurasi Supabase Auth platform, bukan kode/database migration. Connector yang tersedia tidak menyediakan mutasi setting Auth ini.

Baseline operasional tetap PASS. Namun status **platform security hardening 100%** baru boleh dinyatakan setelah Leaked Password Protection diaktifkan di Supabase Auth.

## 10. Performance Advisor — ACCEPTED
- INFO no-primary-key hanya pada tabel snapshot/rollback private, bukan tabel operasional public.
- Unused index advisor tidak dijadikan alasan menghapus index otomatis; aplikasi masih relatif baru dan index FK/operasional dipertahankan agar tidak merusak performa masa depan.

## 11. Logs — PASS UNTUK REQUEST APLIKASI
Dalam audit 24 jam:
- Edge requests: 2455 status 200, 80 status 204, 1 status 400.
- Satu 400 berasal dari percobaan login Auth password, bukan endpoint bisnis.
- Tidak ditemukan response 5xx pada edge request aplikasi.
- PostgREST mencatat timeout manager internal, tetapi tidak menghasilkan 5xx edge pada request aplikasi yang diaudit.

## 12. Backup / Recovery — PASS
- Cron backup harian 02:00 WIB aktif.
- Cron token download 02:01 WIB aktif.
- Snapshot 2026-10-03 terbentuk dengan 79 tabel dan checksum.
- Export recovery hanya executable oleh authenticated dan menolak anon; fungsi memvalidasi Administrator aktif.
- Metadata recovery live disinkronkan ke build 2340.
- `supabase/schema_current.sql` disinkronkan dengan guard Tambah Daging dan definisi RHPP final terbaru.
- `docs/BMS_RECOVERY_RUNBOOK.md` disinkronkan ke build 2340.

## 13. Automatic Lock Guards
CI `Verify application` wajib menjalankan:
1. syntax checks,
2. unit tests,
3. `locked-business-rules.test.cjs`,
4. `audit-lock.test.cjs`,
5. real Chromium browser smoke test.

Jika salah satu gagal, perubahan **tidak dianggap PASS**.

## LOCK RULE
Mulai baseline ini:
- Audit, refactor, cleanup, perubahan UI, atau optimasi **tidak boleh mengubah aturan bisnis LOCKED**.
- Jangan mengubah data historis untuk “menyesuaikan tampilan”.
- Jangan mengembalikan dead code/fallback palsu.
- Jangan menghapus guard RLS/RPC/recovery.
- Perubahan bisnis hanya boleh dilakukan setelah persetujuan eksplisit owner dan guard test ikut diperbarui.
