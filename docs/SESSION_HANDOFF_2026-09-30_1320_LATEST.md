# SESSION HANDOFF — 30 September 2026 sekitar 13:20 WIB

## WAJIB BACA PERTAMA DI CHAT BARU
Repo: `Bagjasindo/BMS-Mitra-Mobile`  
Branch: `main`  
Frontend utama: `main-1958.js`  
Supabase project: `mqqrfhwqgcpkjeaasdsr`

**Jangan mulai ulang audit 283 transaksi Excel. Jangan membuat daftar "missing BB" dari nol.**
Pekerjaan migrasi lama sudah sekitar 90% sebelum sesi ini dan sekarang harus dilanjutkan dari sisa akhir saja.

User meminta: **jika membahas data sisa migrasi, laporkan satu per satu kepada user, bukan sekaligus.**
Jika ada data ambigu/mencurigakan, **tanya dulu**. Jangan menebak lokasi, klasifikasi, jumlah, atau tujuan.

---

# 1. KONDISI MIGRASI LAMA — SUDAH

## Batch lama yang sudah masuk dan tidak boleh diulang
- BOP Umum: 77 transaksi, Rp200.243.659
- Perawatan kandang: batch besar sudah masuk
- GROUP transport sudah dibagi 4 sesuai instruksi user
- Mang Delon sudah dibagi 4 sesuai instruksi user
- Material/repair batch besar sudah masuk
- Kasbon historical balance sudah masuk
- Gaji kantor sudah masuk sebagai staf kantor, bukan ABK
- Lampu pilot Baturuyuk sudah dipindah
- Indihome Cicurug masuk Perawatan Kandang tanpa siklus
- Berbagai RHPP real yang sudah ada tidak boleh diinput ulang

## Aset lama yang sudah selesai sebelum sesi ini
AST-0001 s.d. AST-0013 sudah lengkap quantity/unit dan tidak perlu dibuka ulang.

## Aset tambahan yang dimasukkan pada sesi ini
1. AST-0018 — Terpal A3 — 1 ROLL — Rp1.200.000 — Randegan — sumber BB-93
2. AST-0019 — Mesin steam + selang 100 m — 1 SET — Rp2.850.000 — Bantrangsana — sumber BB-161
3. AST-0020 — Stepless — 2 UNIT — Rp110.000 — Cicurug — sumber BB-194
4. AST-0021 — Tabung gas baru — 5 TABUNG — Rp950.000 — Cicurug — sumber BB-224

Semua di atas sudah terverifikasi masuk database.

---

# 2. DATA YANG DITAHAN / BELUM DIMASUKKAN

## BB-100 — Dinamo untuk stok — Rp4.700.000
Status: **BELUM DIMASUKKAN**.

User menegaskan bahwa barang yang tertulis "untuk stok" seharusnya masuk alur stok gudang, bukan langsung aset kandang.

BB-100 jangan dimasukkan dulu sampai struktur menu pembelian/stok/aset final dirapikan.

## Kandidat lain yang masih perlu dibahas satu per satu
Contoh yang masih perlu konfirmasi/klasifikasi:
- Freezer
- Tempat freezer
- Termohydro GROUP
- Timbangan digital GROUP
- barang rumah tangga/perlengkapan campuran
- beberapa barang stok/peralatan baru lain

**Jangan bahas semuanya sekaligus.**
Ambil satu item, laporkan ke user, tunggu keputusan jika ada bagian ambigu.

---

# 3. MODUL STOK GUDANG — SUDAH DIBUAT DI DATABASE DAN FRONTEND

Pada sesi ini dibuat alur:
- Keuangan → Beli untuk Stok
- Logistik → Stok Barang
- Logistik → Kirim Barang dari Gudang

Database baru:
- `finance_stock_purchase_invoices`
- `warehouse_stock_items`
- `warehouse_stock_shipments`

RPC:
- `finance_save_stock_invoice_atomic(...)`
- `logistics_send_warehouse_stock_atomic(...)`
- `finance_cashflow_entries_v4()`

RLS sudah aktif pada tabel baru.
Anon tidak diberi akses RPC.
Role:
- Pembelian stok: ADMIN / KEUANGAN
- Kirim stok: ADMIN / LOGISTIK
- Baca stok: ADMIN / KEUANGAN / LOGISTIK

Arus kas v4 sudah memasukkan **BELI UNTUK STOK** sebagai kas keluar.

SQL dokumentasi:
`sql/20260930_warehouse_stock_flow.sql`

Commit frontend utama:
`366782b11317fefae6acee3047d687b3a19c2c53`

Commit cache:
`308a93c0464dcf22cbdb7fff7c7e54652831fd6f`

Commit SQL:
`4f232148f68c9bab4d049318a40aac869c1e8dd8`

Commit index tambahan:
`07ab24b5c3db9ff5f32b3fa2af3033017a33121b`

Cache loader saat ini:
`./main-1958.js?v=2239-warehouse-stock-flow`

Frontend syntax test: PASS.

---

# 4. DATA PERCOBAAN — SUDAH DIHAPUS

User membuat percobaan:
- Supplier: Toko bandung
- No nota: 9836-8346
- IGM 5 PCS × Rp500 = Rp2.500
- lalu 1 PCS dikirim ke Cicurug
- referensi kirim: afqe

User kemudian meminta semua data percobaan dihapus.

SUDAH DIHAPUS:
- purchase invoice
- stock item
- shipment
- asset yang sempat terkait

Verifikasi terakhir:
- invoice remaining = 0
- item remaining = 0
- shipment remaining = 0
- asset remaining = 0

Jadi database bersih dari percobaan tersebut.

---

# 5. KEPUTUSAN TERBARU USER — PENTING

User menilai struktur sekarang mulai rancu karena ada:
- Beli Aset
- Aset Kandang / Kantor
- Beli untuk Stok
- Stok Barang
- Kirim Barang dari Gudang

Keputusan konsep terbaru user:

## SATU PINTU PEMBELIAN
Keuangan harus punya satu menu utama:
**Keuangan → Pembelian Barang**

Di satu form ini user memilih tujuan:
- Gudang
- Kandang
- Kantor

### Jika tujuan = Gudang
- barang masuk Stok Gudang
- belum menjadi aset
- Logistik kemudian mengirim dari gudang

### Jika tujuan = Kandang / Kantor
- jika barang adalah aset → otomatis masuk Aset Kandang/Kantor
- jangan ada input pembelian lagi di menu Aset

## Aset Kandang / Kantor
Harus menjadi **menu daftar/rekap aset**, bukan tempat input pembelian baru.

## Logistik
- Stok Gudang
- Kirim Barang dari Gudang

## Jangan pakai checkbox "Buat menjadi Aset"
User menolak checkbox manual karena membingungkan.

Konsep final yang diinginkan:
**Pembelian Barang → Gudang/Kandang/Kantor → Stok atau Aset otomatis**

---

# 6. YANG BELUM DIIMPLEMENTASIKAN

Keputusan satu pintu pembelian di atas **BELUM dibuat di kode**.

Saat handoff ini ditulis, frontend masih mempunyai menu terpisah:
- Beli Aset
- Beli untuk Stok
- Stok Barang
- Kirim Barang dari Gudang

Jadi pekerjaan selanjutnya adalah **merapikan dan menyatukan menu**, bukan menambah menu baru lagi.

Belum dikerjakan:
1. Gabungkan `Beli Aset` + `Beli untuk Stok` menjadi satu **Pembelian Barang**
2. Tambahkan pilihan tujuan: Gudang / Kandang / Kantor
3. Tambahkan klasifikasi barang yang menentukan perilaku otomatis (aset vs non-aset/habis pakai), tetapi jangan membuat UI membingungkan
4. Hilangkan kebutuhan checkbox `Buat menjadi Aset`
5. Jadikan `Aset Kandang/Kantor` read-only untuk pembelian normal; tampilkan daftar/rekap saja
6. Pastikan pengiriman stok aset ke Kandang/Kantor otomatis membuat aset
7. Pastikan barang non-aset yang dikirim hanya mengurangi stok
8. Pastikan Arus Kas hanya menghitung pembelian satu kali
9. Setelah struktur ini selesai, baru masukkan BB-100 Dinamo untuk stok
10. Setelah itu lanjutkan sisa migrasi satu per satu

---

# 7. ATURAN DESAIN ALUR YANG DIKUNCI

- Keuangan mencatat pembelian / uang keluar
- Logistik menangani stok fisik dan distribusi barang gudang
- Aset bukan tempat input ulang
- Satu transaksi tidak boleh dicatat dua kali
- Stok gudang harus berkurang otomatis saat dikirim
- Jika barang menjadi aset, aset dibuat otomatis dari alur transaksi
- Tidak ada data palsu/static
- Semua menu harus terhubung database nyata
- Jangan menebak data lama yang ambigu
- Jika source menyebut nama kandang, nama kandang mengalahkan kode BMS
- Kode BMS hanya fallback
- User ingin info data migrasi **satu per satu**

---

# 8. OUTSTANDING LAMA YANG MASIH JANGAN DILUPAKAN

- Cicurug June masih MANDIRI ACTIVE; jangan close tanpa izin user
- Selisih SAP Cicurug Rp950.000 masih unresolved
- Jangan menganggap AMIR Jul14 menyelesaikan selisih itu
- RHPP/supplier payment/tambah daging reconciliation tertentu masih deferred
- Jangan claim laba/rugi final benar jika period aktif dan final sapronak belum masuk formula
- Jangan re-audit semua transaksi lama kecuali user secara eksplisit minta

---

# 9. TITIK LANJUT CHAT BARU

Urutan yang benar:
1. Baca handoff ini
2. Jangan mulai dari audit Excel 283 transaksi
3. Rapikan menu menjadi **Keuangan → Pembelian Barang**
4. Hubungkan otomatis ke Gudang / Aset
5. Hilangkan checkbox aset manual
6. Jadikan Aset Kandang/Kantor sebagai daftar/rekap, bukan input pembelian
7. Tes end-to-end dengan rollback
8. Setelah sistem stabil, lanjut migrasi data
9. Mulai dari **BB-100 Dinamo untuk stok Rp4.700.000**
10. Lanjut data berikutnya **satu per satu**, laporkan ke user sebelum keputusan jika ambigu

