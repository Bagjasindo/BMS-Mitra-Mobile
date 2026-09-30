# BMS — CURRENT AUDIT HANDOFF ONLY

Tanggal: 30 September 2026
Branch kerja: `main`
Status: sumber lanjutan tunggal. Jangan gunakan histori chat lama.

## ATURAN LANJUTAN
- Gunakan hanya kondisi source + database live saat ini.
- Jangan membaca/merangkum ulang histori pekerjaan lama.
- Jangan membuka kembali item PASS kecuali perubahan baru menyentuh alurnya.
- Jangan mengubah flow bisnis/fungsi/formula yang sudah PASS hanya untuk merapikan UI.
- Jika perlu test write, gunakan rollback/temporary dan pastikan tanpa residue.
- Branch baseline/frozen jangan diubah.
- Sebelum edit file GitHub, fetch SHA terbaru.
- Jangan write file yang sama secara paralel.

## FLOW FREEZE
Master → Siklus → Logistik → Chick-In/ABK → Produksi/PPL → Marketing → RHPP → Keuangan → Laba/Rugi → Dashboard/Laporan.

## AUDIT STATUS SAAT INI
Status umum: PASS, dengan perubahan terbaru sudah diaudit ulang pada menu/routing.

### Siklus / Lock Global
- Siklus PROSES/AKTIF: transaksi operasional dapat dikoreksi sesuai hak role.
- Siklus CLOSED: transaksi operasional terkunci.
- ADMIN dapat Buka/Tutup Siklus dari menu Administrator.
- Buka Siklus mengaktifkan kembali edit operasional yang memang bergantung status siklus.
- Kunci permanen Master Kontrak terpisah dan tidak ikut terbuka saat siklus dibuka.
- Pakan ABK mengikuti lock global siklus:
  - PROSES: dapat dikoreksi ADMIN/PPL sesuai scope.
  - CLOSED: tidak dapat diubah.
- Trigger lama yang mengunci pakan berdasarkan `basics_locked_at` sudah diselaraskan dengan status siklus.

### Master Kontrak
- Tombol **Kunci Kontrak** aktif.
- Setelah dikunci: header kontrak + harga sapronak + harga ayam hidup + bonus + standar performa terkait tidak dapat diedit.
- Revisi setelah lock harus **Buat Kontrak Baru**.
- Backend guard aktif, bukan UI-only.

### Liga ABK
- ADMIN PC → PPL HP sinkron: PASS.
- PPL HP → database/ADMIN sinkron: PASS.
- Liga ABK memakai pembagian ABK dari Chick-In.
- PPL hanya melihat kandang/assignment sesuai scope miliknya.
- Klasemen resmi hanya siklus CLOSED/final.
- **Lihat Liga per Kandang** sekarang menampilkan:
  - PROSES = ranking sementara.
  - CLOSED = hasil final.
- Dropdown: Kandang → Siklus → Tampilkan.

### Lihat RHPP ABK
- Lokasi menu: Produksi / PPL → Lihat RHPP → Lihat RHPP ABK.
- Sumber data: Liga ABK + kontrak terkait.
- Filter: Kandang → Siklus → ABK.
- PROSES dan CLOSED dapat dilihat.
- Tampilan sudah diubah mengikuti pola audit CEK RHPP:
  - Rincian Panen ABK.
  - Rincian Harga Kontrak.
  - Harga ayam hidup berdasarkan range BW.
  - Bonus kontrak.
  - Pemakaian Pakan ABK.
  - Ringkasan Produksi ABK.
  - Kinerja Produksi ABK.
  - Perhitungan RHPP ABK.
  - Nilai RHPP ABK.
  - Print / PDF / Excel.
- Perhitungan tetap memakai data live BMS/Liga ABK; tidak boleh memakai angka hard-code/contoh.

### CEK RHPP Administrator
- **JANGAN UBAH fungsi/logika CEK RHPP untuk meniru RHPP ABK.**
- CEK RHPP sudah dikembalikan ke implementasi sebelum perubahan ABK.
- CEK RHPP tetap halaman audit utama Administrator seperti sebelumnya:
  - Rincian Panen Marketing.
  - Biaya Tambahan Marketing.
  - Pemakaian Pakan & Retur.
  - Ringkasan Produksi.
  - Kinerja Produksi.
  - Perhitungan RHPP.
  - Nilai RHPP.
  - kontrol Deal & Close.
- Error `performance_standards.std_weight_kg does not exist` berasal dari eksperimen CEK RHPP ABK dan sudah hilang setelah CEK RHPP direstore.

### Menu / Routing Audit
- Audit seluruh visibleTabs → title → route/module: PASS, tidak ada route hilang.
- Semua fungsi halaman khusus yang dipanggil router tersedia.
- Handler global `[data-tab]` aktif.
- Submenu baru Liga ABK dan Lihat RHPP punya route valid.
- Bug ditemukan: akun KEUANGAN sebelumnya mempunyai menu **CEK RHPP** tetapi diarahkan ke RHPP Real.
- Fixed:
  - CEK RHPP khusus ADMIN.
  - KEUANGAN memakai RHPP Real.
- Role/menu lain tidak diubah.

## UI / CACHE TERBARU
Frontend utama: `main-1958.js`
Cache terbaru: `main-1958.js?v=2269-rhpp-abk-like-cek-rhpp`

Commit penting kondisi terakhir:
- Restore CEK RHPP: `75aa6c98b485348a3b52d77d2b0a94512f097fef`
- Lihat RHPP ABK mengikuti layout CEK RHPP: `4f0dd2d22a1380cfcc1877cecf9ae545ff1ad062`
- Cache 2269: `48c66f699a409a8046165052c269b196400b5e7b`
- Fix menu CEK RHPP untuk role Keuangan: `746149427ef4f588ec6f665b62937a223faa088d`

## REFERENSI FORMAT RHPP TERBARU
User memberi contoh PDF RHPP perusahaan sebagai acuan visual/struktur.
Arah yang disepakati:
- Gunakan pola dokumen yang jelas: identitas → DOC → Pakan/Mutasi → OVK bila relevan → Panen/Penjualan → rekap hasil → perhitungan bonus/kontrak → ringkasan performa.
- **Jangan menyalin angka contoh.**
- Semua angka tetap berasal dari database BMS dan template kontrak aktif/final yang benar.
- Untuk RHPP ABK, OVK hanya tampil jika memang ada alokasi/sumber data ABK yang sah; jangan dibuat-buat.

## NEXT ACTION — BELUM DIKERJAKAN
**Standarkan tampilan RHPP secara global memakai pola dokumen referensi PDF**, dengan batasan:
- tidak mengubah formula,
- tidak mengubah sumber data,
- tidak mengubah status PASS,
- CEK RHPP Administrator tidak boleh rusak/berubah fungsi,
- fokus pada presentasi/print/export yang konsisten,
- audit menu dan klik tiap role sesudah perubahan.

## TITIK MULAI CHAT BARU
Gunakan instruksi:
**"Lanjut BMS dari docs/BMS_HANDOFF_CURRENT.md. Audit/current-state only. Jangan gunakan histori chat lama. Lanjutkan NEXT ACTION yang tercatat."**
