# BMS Mobile — Handoff Current State

> CHECKPOINT ONLY — 2026-10-01
> Hanya kondisi terakhir; jangan membawa histori lama.

## Status ikon PWA

Sumber resmi: `WhatsApp Image 2026-09-03 at 21.03.03-512x512(1).png`, lampiran terbaru pengguna.
Logo dipakai persis; hanya resize, tanpa crop, redesign, atau perubahan warna/proporsi.

- PNG 192x192 dan 512x512 untuk PWA, purpose `any`.
- PNG 180x180 untuk Apple Touch Icon.
- Manifest, Apple Touch Icon, dan service worker memakai versi `6-original-20261001`.
- Dimensi dan decoding PNG telah diperiksa. Ikon 512 mempertahankan pixel sumber.
- Database, menu, role, transaksi, dan UI lainnya tidak diubah.

## Verifikasi yang masih diperlukan

Deployment GitHub Pages berhasil. Manifest, index.html, dan sw.js live memakai versi baru. Ketiga PNG live berhasil dibuka, dimensinya benar, dan pixel-nya cocok dengan aset hasil resize sumber asli.
Tampilan ikon Home Screen perangkat nyata belum diverifikasi.
Setelah versi baru aktif, hapus aplikasi PWA lama saja, lalu pasang ulang dari situs yang sama. Jangan hapus data situs.
Periksa Android dan iPhone/iPad: logo harus penuh dan proporsional.

## Desktop

Favicon ICO multiukuran (16–256) dan PNG 32 ditambahkan dari sumber asli; halaman juga menyediakan favicon PNG 192. Screenshot pengguna menunjukkan shortcut Windows huruf B; shortcut yang sudah tersimpan perlu dibuat ulang. Tampilan shortcut Windows baru belum diverifikasi di perangkat pengguna.
