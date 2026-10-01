# BMS Mobile — Handoff Current State

> CHECKPOINT ONLY — 2026-10-01
>
> Catatan ini hanya memuat kondisi terakhir. Jangan membawa kembali histori/perbaikan lama kecuali diminta eksplisit.

## Status Saat Ini

PWA BMS Mobile sudah dapat dipasang sebagai aplikasi di Android/desktop dan dibuka tanpa address bar browser.

Masalah terakhir yang belum selesai adalah **icon PWA/Home Screen**.

## Masalah Icon Saat Ini

- Icon di Android sempat blank/putih.
- Percobaan icon sebelumnya tidak sesuai logo asli dan tidak boleh dipakai.
- Ada hasil icon yang terpotong / tidak proporsional di Home Screen.
- User sudah memberikan file icon final yang harus menjadi acuan:
  - `Neon BMS Chicken Emblem-512x512.png`
- Bentuk logo harus dipakai **persis sesuai file tersebut**.
- Jangan redesign.
- Jangan generate logo baru.
- Jangan mengubah ayam, atap, tulisan BMS, proporsi, atau warna.
- Jangan mengambil icon dari logo login JPG lama jika hasilnya membuat cropping/blank.

## Pekerjaan Berikutnya

1. Gunakan file `Neon BMS Chicken Emblem-512x512.png` sebagai sumber icon resmi PWA.
2. Siapkan asset:
   - 192x192 PNG untuk Android/PWA.
   - 512x512 PNG untuk Android/PWA.
   - 180x180 PNG untuk Apple Touch Icon.
3. Pastikan semua icon berbentuk persegi dan tidak terpotong.
4. Update `manifest.webmanifest` agar memakai icon PNG tersebut.
5. Update `index.html` agar `apple-touch-icon` memakai icon 180x180.
6. Update `sw.js` / cache version agar icon lama tidak terus tersimpan.
7. Setelah deploy, hapus PWA lama dari HP lalu install ulang untuk verifikasi icon baru.
8. Verifikasi Android Home Screen: icon harus tampil penuh dan proporsional seperti file sumber.

## Batasan

- Jangan ubah database.
- Jangan ubah menu, role, transaksi, atau UI lain.
- Jangan menghidupkan kembali histori lama.
- Fokus hanya menyelesaikan icon PWA sampai sesuai file sumber.

## File PWA Saat Ini

- `index.html`
- `manifest.webmanifest`
- `sw.js`
- `assets/bms_app_icon.svg` — **jangan dijadikan acuan final** jika hasil icon tidak sesuai.

