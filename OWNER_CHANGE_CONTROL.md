# BMS Mobile — OWNER CHANGE CONTROL

Status: **LOCKED**

Mulai baseline audit 2026-10-03 / build 2340:

## Aturan Utama
Tidak boleh ada perubahan pada aplikasi tanpa persetujuan eksplisit Owner terlebih dahulu.

Yang termasuk perubahan dan wajib minta izin:
- kode JavaScript / CSS / HTML
- database schema, function, trigger, policy, RLS
- workflow / CI / deploy
- PWA / service worker / cache version
- UI / UX / tema / ikon
- logika bisnis
- hak akses / role
- laporan / cetak / PDF / Excel
- backup / restore / recovery
- refactor / cleanup / optimasi
- penghapusan dead code
- perubahan migration / seed / snapshot schema

## Yang Boleh Tanpa Mengubah Kode
- audit read-only
- pengecekan status build/deploy
- pengecekan data tanpa mutasi
- penjelasan / dokumentasi hasil audit
- pencarian penyebab masalah tanpa commit

## Prosedur Perubahan
1. Temukan masalah.
2. Jelaskan temuan ke Owner.
3. Minta persetujuan eksplisit.
4. Baru lakukan perubahan.
5. Jalankan Verify application.
6. Pastikan locked business rules tetap PASS.
7. Catat commit dan hasil deploy.

## Larangan
- Jangan menganggap kata “cek”, “audit”, “lihat”, atau “analisa” sebagai izin mengubah kode.
- Jangan melakukan “perbaikan otomatis” hanya karena ditemukan warning.
- Jangan mengubah konsep bisnis yang sudah LOCKED tanpa persetujuan eksplisit Owner.
- Jangan mengubah data historis agar terlihat sesuai.
- Jangan menghapus guard hanya untuk membuat test PASS.

Owner approval adalah syarat sebelum perubahan apa pun.
