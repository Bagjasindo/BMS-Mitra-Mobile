# HANDOFF CURRENT — BMS Mitra Mobile

Tanggal checkpoint: **2026-10-03**  
Repository: **Bagjasindo/BMS-Mitra-Mobile**  
Branch: **main**  
Baseline aktif: **build 2343-recording-age-h1-after-arrival**  
Status: **PASS — DEPLOYED — LOCKED**

## SUMBER KEBENARAN

Gunakan **hanya kondisi source saat ini pada branch `main`**.

File ini adalah **satu-satunya handoff aktif**.  
Jangan memakai handoff lama, histori chat lama, checkpoint lama, percobaan lama, atau konsep yang sudah digantikan.

## STATUS APLIKASI SAAT INI

- Verify application: **PASS**
- GitHub Pages deployment: **PASS**
- PWA/cache aktif: **v2343-recording-age-h1-after-arrival**
- Browser Chromium smoke test: **PASS**
- Login shell: **PASS**
- Offline application shell: **PASS**
- Mobile viewport: **PASS**
- Double-submit guard: **PASS**
- Dead-code cleanup: **PASS**
- Audit hulu → hilir: **PASS**
- Operational baseline: **LOCKED**

## BUSINESS RULES LOCKED

Sumber aturan resmi:
- `LOCKED_BUSINESS_RULES.md`
- `AUDIT_HULU_HILIR_LOCK_20261003.md`
- `OWNER_CHANGE_CONTROL.md`

Aturan penting yang tetap berlaku:
- Hari DOC datang = Hari 0; Recording PPL Hari 1 dimulai H+1 setelah DOC datang.
- Dashboard Kandang Aktif dihitung setelah Chick-In.
- Pembagian ABK memakai jumlah DOC datang, tidak dikurangi Mati Box.
- Rekap Produksi PPL memakai Liga ABK; CLOSED historis tanpa Liga memakai snapshot final nyata.
- MANDIRI tetap memakai **Kontrak Acuan Penilaian**.
- Tambah Daging ikut performa RHPP dan memakai harga kontrak berdasarkan BW.
- Tambah Sapronak/Pakan Tambahan berada di luar RHPP kontrak.
- Nilai RHPP kontrak dihitung terlebih dahulu, lalu biaya perusahaan dikurangkan.
- Nilai NULL/tidak tersedia pada cetak tidak boleh dipalsukan menjadi 0.
- Identitas dokumen resmi memakai Master Data Perusahaan.
- Tidak boleh ada data SIMULASI/DUMMY/PLACEHOLDER/TEST pada hasil cetak resmi.

## DATA & DATABASE

- Public tables: **79**
- RLS enabled: **79/79**
- Semua tabel public mempunyai primary key.
- Tidak ada policy anon/public yang membuka INSERT/UPDATE/DELETE.
- Tidak ada dua siklus aktif pada kandang yang sama.
- Tidak ada Chick-In ganda.
- Tidak ada mismatch pembagian ABK terhadap DOC datang.
- Tidak ada orphan ABK link/result.
- Tidak ada CLOSED cycle tanpa snapshot final.
- Tidak ada orphan shipment/return/invoice utama yang diaudit.
- Data produksi utama yang diaudit valid.

## BACKUP & RECOVERY

- Backup harian 02:00 WIB: **aktif**
- Download token 02:01 WIB: **aktif**
- Snapshot terbaru saat audit: **79 tabel + checksum**
- Recovery metadata: **build 2340**
- `supabase/schema_current.sql`: sinkron dengan baseline bisnis saat ini
- Runbook: `docs/BMS_RECOVERY_RUNBOOK.md`

## SECURITY

Status operasional aplikasi: **PASS**.

Satu hardening platform yang belum aktif:
- **Supabase Auth Leaked Password Protection = disabled**

Ini diterima pada kondisi plan saat ini dan tidak dianggap blocker operasional aplikasi.

## CHANGE CONTROL — WAJIB

**Tidak boleh ada perubahan apa pun tanpa izin eksplisit Owner.**

Permintaan berikut hanya berarti read-only:
- cek
- audit
- lihat
- analisa
- cari masalah

Jika ditemukan masalah:
1. laporkan temuan,
2. jelaskan dampak,
3. tunggu izin Owner,
4. baru boleh mengubah kode/database,
5. setelah perubahan wajib Verify application PASS.

Yang memerlukan izin Owner:
- kode
- UI/UX
- database
- RLS/policy/function/trigger
- workflow/CI
- PWA/cache
- cetak/PDF/Excel
- backup/recovery
- refactor/cleanup/optimasi
- perubahan business rule

`.github/CODEOWNERS` menetapkan `@Bagjasindo` untuk seluruh repository.

## GUARD OTOMATIS

Setiap perubahan wajib melewati:
- syntax/unit checks
- locked business rule tests
- audit-lock tests
- Chromium browser smoke test
- GitHub Verify application

Build yang gagal Verify **tidak boleh dianggap siap operasi**.

## TITIK LANJUT RESMI

Mulai hanya dari checkpoint ini.

Jangan membuka kembali histori lama sebagai dasar kerja.  
Jangan menghidupkan kembali dead code, fallback lama, atau aturan yang sudah digantikan.  
Jangan melakukan perbaikan otomatis tanpa izin Owner.

**CURRENT STATE: PASS — DEPLOYED — LOCKED.**
