# BMS SESSION HANDOFF — 2026-09-30 18:05 WIB

## ATURAN LANJUT
- Jangan kembali ke histori lama.
- Jangan ulang audit yang sudah PASS.
- Fokus hanya pada audit yang BELUM SELESAI di bawah.
- Semua perubahan harus menjaga data/rusmus/alur yang sudah PASS.
- DELETE transaksi = ADMIN only.
- Input/Edit tetap sesuai role masing-masing.
- Uji perubahan dengan transaksi rollback bila memungkinkan.

## STATUS ROLE YANG SUDAH PASS
### ADMIN + LOGISTIK
- Input utama Logistik sudah diuji PASS:
  - Buat Siklus + PPL + ABK
  - Pengiriman Mitra
  - Retur Sapronak
  - Sapronak Luar
  - Beli Peralatan OVK2
  - Kirim Barang Gudang
  - Perpindahan stok pakan BMS
  - Trip Expedisi
  - Invoice Expedisi
- Fix RLS baca LOGISTIK untuk ABK aktif, PPL aktif, barn_assets.
- Tombol delete transaksi tersimpan disembunyikan dari LOGISTIK; backend delete ADMIN-only.

### PPL
- Sudah diuji PASS:
  - Chick-In/edit
  - Recording + sampel bobot
  - Kunjungan
  - Estimasi
  - Liga ABK: populasi awal, kunci pakan, input panen
- PPL hanya boleh pada siklus aktif yang ditugaskan.
- DELETE tetap ADMIN only.
- Cache: 2243-ppl-input-fix.

### MARKETING
- Sudah diuji PASS:
  - Master Pelanggan
  - Panen Mitra
  - Tambah Daging
- Menu Pelanggan sudah dibuka untuk MARKETING.
- Tombol hapus Panen/Tambah Daging disembunyikan dari MARKETING.
- Panen Mandiri belum bisa diuji penuh karena saat ini tidak ada siklus Mandiri aktif; ini kondisi data, bukan bug.
- Cache: 2244-marketing-input-fix.

### KEUANGAN
- Sudah diuji PASS:
  - BOP Produksi
  - Perawatan Kandang
  - BOP Umum
  - Koreksi RHPP Real
  - Kasbon baru
  - Bayar Kasbon
  - Penerimaan Expedisi
  - Bayar Supplier
  - Pembelian Barang/Stok Gudang
  - Beli Aset
  - Gaji ABK per Siklus
  - BOP Expedisi
  - Perawatan Expedisi
- Fix penting:
  - supplier_payments sekarang INSERT/UPDATE untuk ADMIN+KEUANGAN.
  - Menu Gaji ABK ditambahkan ke Keuangan.
  - Menu Beli Aset / Pembelian Langsung ditambahkan ke Keuangan.
- Cache: 2245-finance-input-fix.

## AUDIT YANG BELUM SELESAI
### 1. OWNER — PRIORITAS BERIKUTNYA
User terakhir menyebut masalah umum:
> menu-menu bisa diklik tetapi tidak bisa isi data / edit / hapus

Catatan: OWNER secara desain seharusnya read-only/restore-only, jadi audit OWNER harus memastikan:
- semua menu laporan OWNER bisa dibuka
- semua data sumber terbaca
- angka laporan sama dengan sumber operasional
- tidak ada tombol Input/Edit/Delete untuk OWNER
- tidak ada backend write permission untuk OWNER
- laporan Owner Logistik/Marketing/Keuangan/Produksi/PPL berjalan tanpa error
- Laba/Rugi Kandang, Laba/Rugi Global, Laporan Expedisi, RHPP Real view berjalan
- jangan membuka hak tulis OWNER kecuali user mengubah aturan.

### 2. AUDIT UI GLOBAL SETELAH PER ROLE
Setelah OWNER:
- cek semua visibleTabs vs roles vs render routing
- pastikan tidak ada fungsi halaman yang sudah ada tetapi tidak punya menu/routing seperti kasus Gaji ABK
- cek tombol submit disabled/hidden yang salah per role
- cek dropdown/reference kosong karena RLS SELECT
- cek edit action terlihat tetapi backend update ditolak
- cek delete action hanya ADMIN di UI dan backend
- cek cache version/deploy GitHub Pages

### 3. AUDIT CRUD BACKEND FINAL
- INSERT/UPDATE role matrix final untuk semua tabel operasional
- CLOSED cycle guard tetap menolak perubahan yang tidak diizinkan
- BOP CLOSED hanya bisa jika ADMIN buka akses khusus
- RHPP Real direct update/delete tetap ditolak, koreksi via RPC resmi
- Perawatan Kandang tidak terkait siklus
- admin_only_delete trigger tetap aktif di tabel transaksi utama

### 4. AUDIT DATA/RUMUS FINAL SETELAH UI-RBAC
Jangan ulang rekonsiliasi lama; hanya smoke-check:
- finance_cycle_profit_loss_v2 formula mismatch = 0
- Laba/Rugi Global subtotal = total final
- Arus Kas tidak double count
- Hutang Supplier / Piutang Expedisi tidak overpaid/negative
- tidak ada duplicate refs baru akibat testing/perbaikan
- semua transaksi test harus rollback, tidak tertinggal.

## FIX TERAKHIR PENTING
- Finance report table alignment + laba operasional konsisten.
- Global BOP Umum menampilkan GAJI di rincian; tidak ada baris Gaji terpisah yang dobel.
- Semua closed BOP access yang tertinggal sudah ditutup.
- RLS Perawatan Kandang dibetulkan.
- RHPP Real correction RPC dibetulkan.
- DELETE transaksi keuangan dan operasional dikunci ADMIN-only.
- Marketing Customer UI dibuka.
- PPL Liga ABK input dibuka terbatas ke assignment aktif yang ditugaskan.
- Keuangan supplier payment privilege diperbaiki.

## COMMIT TERAKHIR YANG RELEVAN
- 5b8d65bf57336b3480c61ebfdb2b6ab77cc7ec40 — expose Finance asset purchase and ABK salary menus
- 45b3ce60e6d196ce93b621eaf7ac4cbddd934849 — cache 2245-finance-input-fix
- 3cb35284184cc274d475bdae88e22f52c0fc0e33 — Marketing customer + hide admin-only deletes
- 0541a8e3e29b37172e8ee5e8e6c6b4db96c7ae91 — cache Marketing
- 20f7709660cb7431f288cf2f9161b03ad51deeeb — PPL ABK UI
- 9998826a6e3b3026cdf08a7b65ffe374bdb14da8 — cache PPL
- 772a0f6433e3155b62692df7464d7d5ad1875618 — Logistik delete UI
- 7be9f51e9c7ba8cad89c4b04c2f22f26fe94536c — cache Logistik

## NEXT COMMAND
Mulai chat baru dengan:
**"Lanjut BMS dari handoff terbaru GitHub. Audit yang belum selesai mulai dari OWNER, jangan ulang yang sudah PASS."**
