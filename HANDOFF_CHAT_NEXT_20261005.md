# BMS MOBILE — SINGLE CURRENT HANDOFF — 2026-10-05

## Kata kunci chat baru
**LANJUT BMS — BACA HANDOFF_CHAT_NEXT_20261005.md**

Repo: `Bagjasindo/BMS-Mitra-Mobile`
Branch: `main`

## ATURAN OWNER — WAJIB
1. **cek / audit / lihat / analisa = READ-ONLY**. Jangan mengubah source, DB, UI, workflow, PWA, data, atau business rule.
2. Perubahan hanya jika owner eksplisit mengatakan **kerjakan / perbaiki / lanjutkan / silakan diperbaiki**.
3. Jangan membuat data palsu/dummy/transaksi uji.
4. Jangan merusak bagian yang sudah PASS. CLOSED tetap terkunci.
5. Gunakan current `main` + live DB sebagai keadaan aktual. Jangan mengandalkan histori lama.
6. Jawaban ke owner singkat, jelas, padat.

## SOURCE OF TRUTH SAAT INI
- **File ini adalah satu-satunya handoff operasional.**
- `LOCKED_BUSINESS_RULES.md`
- `AUDIT_HULU_HILIR_LOCK_20261003.md`
- `OWNER_CHANGE_CONTROL.md`
- `.github/CODEOWNERS`
- `tests/locked-business-rules.test.cjs`
- `tests/audit-lock.test.cjs`
- `.github/workflows/verify.yml`
- `supabase/schema_current.sql`
- `docs/BMS_RECOVERY_RUNBOOK.md`
- current source di `main`.

## BUSINESS RULE PENTING — PERTAHANKAN
- Kandang ACTIVE setelah Chick-In.
- ABK berdasarkan DOC diterima; Mati Box terpisah.
- Rekap Produksi PPL bersumber Liga ABK; histori CLOSED tanpa Liga memakai final snapshot nyata.
- MANDIRI memakai referensi kontrak.
- Print/PDF/Excel autentik; unavailable = `-`, bukan nol/dummy.
- RHPP ABK/OVK unavailable bukan 0.
- Tambah Daging: RHPP memakai harga kontrak BW; hutang/biaya supplier memakai harga beli aktual.
- Tambah Sapronak/Pakan Tambahan di luar kontrak/FCR/IP/sapronak; biaya perusahaan dipotong setelah RHPP kontrak.
- DOC datang = Day 0; Recording Day 1 = H+1.
- Dashboard global lintas role monitoring read-only.
- Estimasi mulai umur 23 hari.
- Dashboard membedakan umur aktual vs recording terakhir.
- Keuangan dapat melihat Laba/Rugi Global.
- Hutang Supplier Mitra dan Hutang Supplier Mandiri terpisah.
- Expedisi: Keuangan Kas Jalan → Logistik melengkapi SJ/MTS pada transaksi yang sama; jangan duplikasi trip.
- Mobile aksi berulang icon-only; desktop tetap teks.
- Delete transaksi ACTIVE sesuai allowlist role; CLOSED ditolak.
- Perawatan Kandang terpisah dari Upah ABK Produksi.
- Export Excel memakai formatter global.

## FORM PENGAJUAN KAS — CURRENT LOCK
- Modul Keuangan; akses ADMIN dan KEUANGAN.
- Catatan/dokumen administratif **berdiri sendiri**.
- Tidak posting/terhubung ke realisasi BOP Produksi/BOP Umum/BOP Kantor, Kasbon, Arus Kas, Hutang, RHPP, Laba/Rugi, atau transaksi realisasi lain.
- Database: `finance_cash_requests` + `finance_cash_request_items`.
- Struktur current sudah **1 kelompok → banyak rincian**.
- Jenis kelompok: **Kandang, BOP Umum, BOP Kantor, Proyek/Lainnya**.
- Satu form boleh beberapa kelompok.
- Tiap kelompok mempunyai banyak `Uraian | Jumlah | Keterangan`.
- Kandang dipilih sekali per kelompok.
- Ada **Tambah Kelompok** dan **Tambah Rincian**.
- Histori, Lihat/Cetak, Excel tetap tersedia.
- Kop dokumen dari Master Data Perusahaan.
- Belum menambahkan workflow baru/Edit draft diam-diam.

## PERBAIKAN TERAKHIR — SUDAH DITERAPKAN
1. **Mobile Form Pengajuan Kas**
   - Khusus HP, rincian tidak lagi tabel melebar.
   - Rincian tampil vertikal: Uraian → Jumlah → Keterangan → Aksi.
   - Desktop dipertahankan.
   - File tambahan: `mobile-form-responsive.css`.
   - Perlindungan responsif form HP hanya presentasi; tidak mengubah handler, permission, DB, atau jalur transaksi.
2. **Format Jumlah Pengajuan Kas**
   - Khusus Form Pengajuan Kas.
   - Tampilan mengikuti Indonesia, contoh `1.000.000,00`.
   - Nilai untuk penyimpanan/perhitungan tetap numerik.
   - **Jangan globalkan formatter ini**, karena form lain sudah PASS format Indonesia.
3. PWA/cache sudah dinaikkan untuk membawa perubahan tersebut.

## LOCK PERUBAHAN TERAKHIR
- Jangan mengubah form lain yang sudah PASS.
- Jangan mengglobalkan formatter Pengajuan Kas.
- Jangan mengubah desktop hanya untuk memperbaiki HP.
- Jangan mengubah jalur kode/business logic jika masalah hanya UI responsif.
- Sebelum perubahan berikutnya, pahami current source terkait terlebih dahulu.

## STATUS TITIK HANDOFF
Current `main` setelah:
- refactor Pengajuan Kas kelompok → banyak rincian;
- perbaikan layout vertikal khusus HP;
- format jumlah Pengajuan Kas Indonesia;
- refresh PWA/cache.

**Mulai pekerjaan berikutnya dari titik ini. Jangan kembali ke status handoff/refactor lama.**
