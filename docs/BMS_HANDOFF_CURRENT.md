# BMS — CURRENT STATE HANDOFF ONLY

Tanggal: 1 Oktober 2026
Branch kerja: `main`
Status: FIXED sampai revisi Cetak RHPP profesional ini.
Sumber lanjutan tunggal: source code live + file ini.

## ATURAN WAJIB CHAT BERIKUTNYA
- JANGAN gunakan histori chat lama.
- JANGAN kembali ke handoff lama.
- JANGAN buka ulang pekerjaan yang sudah selesai hanya karena histori.
- Mulai hanya dari kondisi source `main` saat ini.
- Jika ada revisi berikutnya, fetch SHA terbaru lebih dulu.
- Jangan ubah formula, sumber data, flow bisnis, permission, atau status PASS kecuali user meminta secara eksplisit.
- Fokus perubahan terakhir hanya UI RHPP.
- Sampai titik ini user menyatakan cukup; jangan lanjut otomatis.

## KONDISI RHPP TERKINI
Terdapat 5 halaman/menu RHPP:
1. Lihat RHPP
2. Lihat RHPP ABK
3. CEK RHPP
4. Cetak RHPP
5. RHPP Real

### Cetak RHPP
- Hasil Print/PDF sudah memakai standar dokumen BMS.
- A4 portrait.
- Logo BMS bawaan.
- Header perusahaan: PT Bagjasindo Mandiri Sindangkasih.
- Alamat/kontak diambil dari Data Perusahaan.
- Warna mengikuti branding BMS biru/cyan.
- Nilai positif/laba = bold hitam.
- Nilai rugi/negatif = merah.
- Tidak memakai tanda kurung untuk angka normal.
- Layout dokumen: DOC → Pakan → OVK → Penjualan/Panen → Rekap hasil → bonus/performa → keterangan/bank.
- Data/hitungan tetap dari database BMS.
- View Cetak RHPP direvisi menjadi UI audit profesional: Identitas Siklus, Kinerja Produksi, Biaya Sapronak, Nilai RHPP, Rincian Panen, Rincian Kiriman Pakan, dan Rincian Kiriman OVK.
- Hasil Print/PDF Cetak RHPP dibuat lebih terbaca dan profesional; A4 portrait, hierarki section konsisten, tabel lebih lega, header BMS seragam.
- Seluruh hasil print RHPP yang memakai shell bersama (termasuk RHPP/ABK terkait) memakai bahasa visual BMS yang seragam: header, tipografi, tabel, spacing, warna, total, serta laba/rugi.
- Formula, sumber data, flow bisnis dan permission tidak diubah.
- Jangan ubah hasil print ini kecuali user meminta.

### Lihat RHPP
- Tampilan layar sudah diarahkan menjadi UI audit/dashboard BMS, bukan miniatur kertas.
- KPI, kartu informasi, tabel detail, warna BMS, spacing dan typography diseragamkan.
- Detail kontrak dan syarat/aturan bonus tidak ditampilkan ke user.
- Perhitungan kontrak/bonus tetap berjalan di belakang bila dibutuhkan oleh nilai RHPP.

### Lihat RHPP ABK
- Tampilan layar diseragamkan ke keluarga UI Lihat RHPP.
- Sumber data tetap Liga ABK + data terkait.
- Detail kontrak dan syarat/aturan bonus tidak ditampilkan ke user.
- Data RHPP ABK tetap terpisah dari RHPP utama.
- Jangan mencampur sumber data RHPP utama dan RHPP ABK.

### CEK RHPP
- Fungsi audit Administrator tetap terpisah.
- Jangan ubah logika/source/formula CEK RHPP hanya demi menyeragamkan tampilan.
- Perubahan terakhir fokus presentasi UI saja.

### RHPP Real
- Tetap halaman terpisah untuk role terkait.
- Jangan ubah tanpa permintaan eksplisit.

## STANDAR UI RHPP YANG DIKUNCI
- Branding BMS: biru/cyan, aksen merah hanya untuk rugi/negatif.
- Header, font, tabel, spacing, tombol dan kartu mengikuti satu keluarga visual BMS.
- Tampilan layar tidak harus identik dengan dokumen A4.
- Dokumen print tetap khusus print/PDF.
- Lihat RHPP dan Lihat RHPP ABK diprioritaskan untuk keterbacaan di layar.
- Kontrak/syarat bonus tidak ditampilkan di layar.
- Angka positif jangan diberi warna merah.

## KOMIT TERAKHIR RELEVAN
- `cbf49dcbdddf17e9499505ce9d82289543014eec` — Bump cache for readable professional RHPP print
- `e82173aabdd991a44e95c3ab830c8f1c98675bed` — Make shared RHPP print output readable and professional
- `27af7e8636439995922032d4bd9b5da3a3271243` — Bump cache for exact Cetak RHPP submenu styling
- `08d2b08c48930e2f3143b430c809e8ca05136cd8` — Remove custom RHPP child styling and inherit Cetak RHPP UI
- `ad192086f5cd49762efcad63d0b64f961a1e4f63` — Make Lihat RHPP children use exact Cetak RHPP nav component
- `862ac2699270358e08dd3ef44f003306444d9154` — Bump cache for uniform RHPP submenu
- `2d9c1b6f682299a059958fac7f241366d03ce86f` — Standardize Lihat RHPP submenu visual states
- `978d55e030bed765108cce0d1f5fa1eab1687aee` — Unify Lihat RHPP submenu icon and structure
- `a2e6fb1c0bfbb19fa92119fc3b87452529697a73` — Keep RHPP screen scope isolated to Cetak RHPP
- `61ad66b8053865646895cdfdc99bf90d6b746802` — Bump cache for professional RHPP print UI
- `124fa6dffa6bd3f573311359522cefa1071f865e` — Refine Cetak RHPP view and unify professional RHPP print UI
- `70283b1e69eb0434998e599c920a68ec3f87cc69` — Unify all RHPP screen views with one BMS dashboard UI
- `929aa999bd7e7d64615c804c2a92fd2c595e8164` — Bump cache for unified RHPP screen UI
- `6c03b71c3032cff26113a1df7cfa8373a231830a` — Unify RHPP and RHPP ABK print templates with BMS standard
- `0458e79c2018838349665085f81900a639781427` — Bump cache for unified RHPP print templates

Cache aktif saat handoff ini dibuat:
`main-1958.js?v=2293-rhpp-print-readable`

## TITIK BERHENTI
STOP di sini.
Tidak ada NEXT ACTION otomatis.
Chat berikutnya hanya melanjutkan jika user memberi instruksi baru.

Instruksi pembuka chat baru:
**"Lanjut BMS dari docs/BMS_HANDOFF_CURRENT.md. Current state only. Jangan gunakan histori chat lama."**
