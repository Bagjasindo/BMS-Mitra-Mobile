# BMS MOBILE — CHAT HANDOFF 2026-10-05

## Kata kunci chat baru
**LANJUT BMS — BACA HANDOFF_CHAT_NEXT_20261005.md**

Repo: `Bagjasindo/BMS-Mitra-Mobile`  
Branch: `main`

## ATURAN OWNER — WAJIB
1. Jika owner mengatakan **cek / audit / lihat / analisa**, tindakan adalah **READ-ONLY**. Jangan mengubah source code, database, UI, workflow, PWA, data, atau business rule.
2. Perubahan hanya setelah persetujuan eksplisit seperti **kerjakan / perbaiki / silakan diperbaiki / lanjutkan**.
3. Jika scope ambigu, jelaskan scope dan minta konfirmasi sebelum perubahan.
4. Jangan membuat data palsu, dummy, transaksi uji, atau mengubah histori agar cocok dengan UI.
5. Jaga data bisnis existing. CLOSED tetap terkunci sesuai business rule.
6. Jangan menyatakan PASS/100%/deployed tanpa verifikasi aktual.
7. Gunakan current repo + live DB sebagai keadaan aktual; handoff lama dapat tertinggal.

## SOURCE OF TRUTH
Periksa terutama:
- `HANDOFF_CURRENT.md`
- `LOCKED_BUSINESS_RULES.md`
- `AUDIT_HULU_HILIR_LOCK_20261003.md`
- `OWNER_CHANGE_CONTROL.md`
- `.github/CODEOWNERS`
- `tests/locked-business-rules.test.cjs`
- `tests/audit-lock.test.cjs`
- `.github/workflows/verify.yml`
- `supabase/schema_current.sql`
- `docs/BMS_RECOVERY_RUNBOOK.md`
- `main-2321.js`
- seluruh `modules/*.js`

## BUSINESS RULE PENTING
- Kandang ACTIVE setelah Chick-In.
- ABK berdasarkan DOC diterima; Mati Box terpisah.
- Rekap Produksi PPL bersumber Liga ABK; histori CLOSED tanpa Liga memakai final snapshot nyata.
- MANDIRI memakai referensi kontrak.
- Print/PDF/Excel harus autentik; unavailable = `-`, bukan nol/dummy.
- RHPP ABK/OVK unavailable bukan 0.
- Tambah Daging: performa RHPP memakai harga kontrak BW; hutang/biaya supplier memakai **harga beli aktual**.
- Tambah Sapronak/Pakan Tambahan di luar kontrak/FCR/IP/sapronak; biaya perusahaan dipotong setelah RHPP kontrak.
- DOC datang = Day 0; Recording Day 1 = H+1.

## KONDISI/PERUBAHAN TERBARU YANG HARUS DIPERTAHANKAN
- Dashboard global lintas role untuk monitoring read-only.
- Estimasi mulai umur 23 hari.
- Dashboard membedakan umur aktual vs recording terakhir.
- Keuangan dapat melihat Laba/Rugi Global.
- Menu hutang dibedakan: **Hutang Supplier Mitra** dan **Hutang Supplier Mandiri**.
- Expedisi: **Keuangan Kas Jalan → Logistik melengkapi SJ/MTS pada transaksi yang sama**; jangan duplikasi trip.
- Aksi berulang di mobile icon-only; desktop tetap teks.
- Delete lintas role: role pemilik transaksi ACTIVE sesuai allowlist; CLOSED ditolak. Jangan melemahkan CLOSED.
- Perawatan Kandang dipisahkan dari Upah ABK Produksi; Tenaga Kerja Perawatan bukan Upah ABK.
- Export Excel memakai formatter global.
- PWA sebelum pekerjaan Form Pengajuan Kas: `2355-global-excel-layout`.
- Form Pengajuan Kas versi awal sudah dibuat; PWA: `2356-cash-request-form`.

## FORM PENGAJUAN KAS — SUDAH DIKUNCI OWNER
Modul ini berada di Keuangan dan merupakan **CATATAN/DOKUMEN ADMINISTRATIF BERDIRI SENDIRI 100%**.

### TIDAK BOLEH TERHUBUNG KE REALISASI
Tidak ada posting/relasi realisasi otomatis ke:
- BOP Produksi
- BOP Umum
- BOP Kantor
- Kasbon
- Arus Kas
- Hutang
- RHPP
- Laba/Rugi
- transaksi realisasi keuangan lainnya

Istilah **BOP Umum** dan **BOP Kantor** di form hanya kelompok catatan pengajuan, bukan transaksi BOP.

Database awal:
- `finance_cash_requests`
- `finance_cash_request_items`

Akses: **ADMIN dan KEUANGAN**.

## KOREKSI FORM YANG SUDAH DISETUJUI OWNER — BELUM SELESAI DIIMPLEMENTASIKAN
Versi awal saat ini memakai satu baris = pilih Kandang/Proyek + uraian. Itu harus direfactor menjadi:

### 1 KELOMPOK → BANYAK RINCIAN
Jenis kelompok:
1. **Kandang**
2. **BOP Umum**
3. **BOP Kantor**
4. **Proyek/Lainnya**

Aturan:
- Kandang dipilih **sekali** per kelompok, kemudian dapat mempunyai banyak rincian `Uraian | Jumlah | Keterangan`.
- Jangan memilih kandang yang sama berulang pada setiap rincian.
- BOP Umum dipilih sekali lalu banyak rincian.
- BOP Kantor dipilih sekali lalu banyak rincian.
- Proyek/Lainnya dapat mengisi nama proyek/kelompok sendiri lalu banyak rincian.
- Satu Form Pengajuan Kas boleh berisi beberapa kelompok.
- UI harus mempunyai konsep **Tambah Kelompok** dan di dalam kelompok **Tambah Rincian**.
- Total pengajuan = seluruh rincian seluruh kelompok.
- Data/draft lama harus tetap kompatibel dan tidak dirusak.

Contoh:
KANDANG BATURUYUK
- Semen — Rp500.000
- Pasir — Rp300.000
- Upah tukang — Rp700.000
- Kabel — Rp250.000

## DOKUMEN/HISTORI
- Kop mengambil Master Data Perusahaan, bukan dummy.
- Nomor pengajuan, tanggal, perihal, kelompok, Uraian/Jumlah/Keterangan, dan total.
- Histori tetap tersedia.
- Lihat/Cetak dan Excel tetap tersedia; cetak browser dapat dipakai Save as PDF.
- Excel mengikuti formatter global.
- Form ini tetap tidak memposting ke BOP/realisasi.

## STATUS TEPAT SAAT HANDOFF
Pekerjaan refactor sudah dimulai dengan audit current `financeCashRequestPage()` di `modules/bms-finance.js`, tetapi **kode refactor kelompok → banyak rincian belum ditulis/commit** pada titik handoff ini.

Current function yang ditemukan masih:
- `window.__cashRequestDraft` berupa array baris flat.
- Dropdown masih bertuliskan Kandang/Proyek.
- Setiap baris menyimpan `group_name, description, amount, remarks`.
- Riwayat menghitung total dari `finance_cash_request_items`.
- Save membuat header `finance_cash_requests` lalu detail `finance_cash_request_items`.
- Tidak ada posting BOP dari fungsi ini.

## TUGAS PERTAMA CHAT BARU
1. Baca file handoff ini dan current repo.
2. Audit current `main` sebelum mengubah.
3. Pastikan live DB sesuai jika diperlukan.
4. Lanjutkan **hanya** refactor Form Pengajuan Kas menjadi **kelompok → banyak rincian** sesuai aturan owner.
5. Jangan mengubah modul lain di luar kebutuhan langsung form/PWA.
6. Pertahankan kompatibilitas data existing.
7. Setelah implementasi, audit UI → penyimpanan → histori → cetak/Excel → PWA tanpa membuat transaksi bisnis palsu.
8. Jangan menganggap pekerjaan selesai sampai benar-benar diverifikasi.

## CATATAN GAP VERSI AWAL
Versi awal belum mempunyai Edit draft existing dan belum mempunyai workflow DIAJUKAN. Jangan diam-diam menambahkan workflow baru tanpa persetujuan owner. Fokus handoff saat ini hanya refactor struktur kelompok/rincian yang sudah disetujui.
