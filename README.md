# BMS Mitra Online

Checkpoint bersih — 27 September 2026.

## Baseline
- Branch aktif: `main`
- Source aktif di branch `main` adalah patokan tunggal.
- File inti: `index.html`, `main-1958.js`, `style.css`, dan migration pada `supabase/`.
- Komentar deploy/history lama di `index.html` sudah dibersihkan.

## Status terakhir
- Expedisi berdiri terpisah dari RHPP/Kandang.
- Master Data Expedisi berada di menu utama Master Data.
- Grup Expedisi berada di bawah Logistik.
- Submenu Expedisi saat ini: Data / Operasional, Pembayaran Expedisi, BOP Expedisi, Perawatan Expedisi, Laba/Rugi Expedisi.
- Hak operasional: ADMIN/LOGISTIK.
- Hak Pembayaran/BOP/Perawatan: ADMIN/KEUANGAN.
- Laba/Rugi Expedisi dapat dilihat ADMIN/KEUANGAN/OWNER.
- Nomor invoice Expedisi otomatis: `001/BMS-BSI/FMC/YYYY` dan reset per tahun.
- Trip mendukung banyak tujuan/kandang dalam satu perjalanan.
- Jenis muatan dicari dari Master Sapronak kategori PAKAN.
- Master Rute menyimpan harga trip serta komponen biaya standar BOP.
- BOP Operasional Trip dibuat dengan tombol **Masukkan BOP** dari biaya standar Master Rute dan tidak boleh dobel.
- Perawatan Expedisi dipisahkan dari BOP Operasional.
- Rumus Laba/Rugi Expedisi: Pendapatan - BOP Operasional = Laba Operasional; Laba Operasional - Perawatan = Laba Bersih Expedisi.
- Tampilan web sudah dikompakkan untuk HP sampai lebar 900px.
- Data contoh invoice Expedisi sudah masuk: 15 trip, total nilai trip Rp15.600.000, total muatan 2.380 zak.

## Lanjutan
- Audit final Keuangan.
- Finalisasi tampilan/rekap Owner.
- Bagian yang sudah PASS/terkunci jangan diubah kecuali ada perintah khusus.
