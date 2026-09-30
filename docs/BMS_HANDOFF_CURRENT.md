# BMS — HANDOFF TUNGGAL TERBARU

Tanggal: 30 September 2026
Status: SUMBER LANJUTAN SATU-SATUNYA

## ATURAN UTAMA
- Semua handoff lama sudah dihapus dari folder `docs`.
- Jangan mengambil pekerjaan dari histori/handoff lama.
- Semua audit dan perbaikan sebelumnya dianggap PASS dan DIKUNCI.
- Jangan mengulang rekonsiliasi lama.
- Jangan mengulang input transaksi/data yang sudah ada.
- Jangan menghidupkan kembali daftar pending lama.
- Database/web saat ini adalah sumber kebenaran operasional.
- Jika ada temuan baru, hanya tindak lanjuti jika ditemukan dari Audit Hulu → Hilir saat ini.

## STATUS TERKUNCI — PASS
- UI global: PASS.
- Routing/menu per role: PASS.
- CRUD backend final: PASS.
- DELETE transaksi utama: ADMIN-only PASS.
- OWNER: read-only sesuai desain.
- PPL/Marketing/Logistik/Keuangan: alur yang sudah diuji sebelumnya tetap PASS.
- Guard siklus CLOSED: PASS pada audit terakhir.
- Formula `finance_cycle_profit_loss_v2`: mismatch 0.
- Formula laba/rugi global: diff 0.
- Arus kas pembelian stok vs invoice stok: sinkron pada smoke-check terakhir.
- Overpayment supplier/ekspedisi/Mandiri: 0 pada smoke-check terakhir.
- Test transactions yang sebelumnya dibersihkan tidak boleh dimunculkan lagi sebagai pending.
- Perbaikan Admin Arsip Data untuk `finance_reference_counters`: PASS.

## SATU-SATUNYA PEKERJAAN SELANJUTNYA
# AUDIT HULU → HILIR

Audit harus mengikuti aliran data nyata dari sumber sampai laporan akhir, bukan mengulang audit menu lama.

Urutan audit:
1. MASTER / HULU
   - Kandang
   - Kontrak
   - Item/Sapronak
   - Supplier/Pelanggan/Karyawan/ABK/PPL
   - Harga/standar performa
   - relasi master ke transaksi

2. INPUT OPERASIONAL
   - Logistik
   - PPL/Produksi
   - Marketing
   - Keuangan
   - Expedisi

3. ALIRAN ANTAR-MODUL
   - input sumber harus masuk ke tabel/ledger tujuan yang benar
   - referensi transaksi harus konsisten
   - tidak boleh ada input statis/palsu
   - tidak boleh ada double count
   - tidak boleh ada transaksi yang putus dari sumbernya
   - stok/aset/hutang/piutang/kas harus bergerak sistematis

4. RHPP / PRODUKSI
   - sumber DOC, pakan, OVK1, panen, recording, retur, sapronak luar, tambah daging
   - nilai kontrak vs aktual sesuai aturan
   - RHPP Real/koreksi mengikuti jalur resmi
   - BOP Produksi terpisah sesuai desain
   - Perawatan Kandang tidak dicampur ke siklus

5. KEUANGAN / HILIR
   - hutang supplier
   - piutang
   - pembayaran/penerimaan
   - arus kas
   - aset/stok
   - BOP Umum
   - Expedisi
   - laba/rugi kandang
   - laba/rugi global

6. OUTPUT AKHIR
   - Dashboard
   - laporan per role
   - laporan OWNER
   - cetak/export
   - angka output harus dapat ditelusuri kembali sampai transaksi sumber

## CARA KERJA AUDIT HULU → HILIR
- Audit dengan data live saat ini.
- Ikuti satu aliran transaksi dari sumber → proses → ledger → laporan.
- Jangan mengubah data hanya untuk testing bila tidak perlu.
- Bila perlu tes tulis, gunakan transaksi rollback/temporary dan pastikan tidak meninggalkan residue.
- Setiap temuan baru diberi status: PASS / BUG / FIXED.
- Jangan membuka ulang item yang sudah PASS kecuali perubahan baru menyentuh alurnya.
- Jangan memakai catatan historis sebagai bukti bahwa data sekarang masih belum masuk.
- Sebelum menyatakan data belum ada, cek database live terlebih dahulu.

## TITIK MULAI CHAT BERIKUTNYA
Perintah:
**"Lanjut BMS dari HANDOFF TUNGGAL TERBARU. Mulai Audit Hulu → Hilir. Jangan baca/ulang handoff lama karena semuanya sudah PASS."**


## PERUBAHAN TERBARU — ADMIN BUKA/TUTUP SIKLUS
- Menu baru: **Administrator → Buka/Tutup Siklus**.
- Alur: pilih Kandang → pilih Siklus → Buka/Tutup.
- Hanya ADMIN yang dapat menjalankan aksi.
- Membuka siklus hanya memengaruhi assignment kandang+siklus terpilih; siklus lain tetap terkunci.
- Sistem menolak membuka siklus lama jika kandang yang sama masih memiliki siklus aktif lain.
- Saat siklus MITRA dibuka, snapshot `rhpp_system_final` lama dilepas; saat ditutup kembali sistem memakai proses close resmi dan membuat snapshot final baru.
- Saat siklus MANDIRI dibuka, snapshot `production_mandiri_final` lama dilepas; saat ditutup kembali sistem memakai proses close resmi.
- Backend RPC: `admin_reopen_cycle_v1` dan `admin_reclose_cycle_v1`.
- Uji ADMIN buka→tutup dilakukan dengan transaksi rollback; data asli tetap CLOSED dan snapshot final tetap ada setelah rollback.
- Uji akses non-ADMIN: ditolak.
- Cache web saat ini: `main-1958.js?v=2248-admin-cycle-open-close`.
