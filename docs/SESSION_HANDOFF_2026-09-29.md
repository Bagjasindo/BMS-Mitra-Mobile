# SESSION HANDOFF — BMS Mobile
Tanggal: 2026-09-29
Repository: Bagjasindo/BMS-Mitra-Mobile
Branch: main

## Aturan sumber kebenaran
- Gunakan FILE TERBARU DI GITHUB branch main sebagai sumber utama.
- Jangan memakai histori chat lama sebagai sumber implementasi.
- Jangan mengembalikan kode ke versi lama kecuali diminta eksplisit.
- Jangan mengubah modul lain di luar bagian yang sedang diminta user.
- Tidak boleh ada data palsu, angka dekoratif, simulasi, atau fallback yang tampak seperti data nyata.

## Fokus terakhir
1. Dashboard Produksi:
   - Populasi awal, terpanen, deplesi, sisa ayam harus dihitung dari data sistem nyata.
   - BW/FCR/IP memakai data recording yang benar.
   - Panel Perlu Perhatian: kondisi bermasalah merah; status normal tidak masuk daftar perhatian.
   - Estimasi per Kandang sedang diarahkan ke KPI: IN, OUT, FC, Mort, IP, Pend./Ekor.
   - Pend./Ekor harus mengacu kontrak, bukan omzet kasar.

2. Estimasi PPL/Admin:
   - Fungsi database save_production_estimate_atomic sudah diperbaiki dari error:
     column reference "x" is ambiguous
   - Estimasi Baturuyuk tanggal 29/09/2026 berhasil tersimpan.
   - Riwayat Estimasi sedang dirapikan agar fokus pada kandang aktif/terpilih.
   - Screenshot terakhir user menunjukkan Ringkasan Estimasi dan Riwayat Estimasi masih perlu diselaraskan dengan acuan kontrak dan tampilan KPI yang user inginkan.

3. Data Baturuyuk aktif yang terakhir diverifikasi:
   - Assignment: e1482c74-4beb-4f0d-80ee-3a845849e010
   - Populasi awal: 14.800
   - DOA: 0
   - Mortality + culling: 2.366
   - Sudah panen: 6.762 ekor
   - Total kg panen: 9.250,30 kg
   - Sisa ayam: 5.672
   - Pakan kumulatif yang terakhir dicek: 37.300 kg

4. Admin Log:
   - Menu khusus ADMIN sudah ditambahkan:
     Administrator -> Log Aktivitas Pengguna
   - Backend table: public.user_activity_logs
   - Mencatat SESSION_START, LOGIN, LOGOUT, MENU_OPEN, perangkat HP/DESKTOP.
   - Audit perubahan data lama tetap memakai public.audit_events.

5. PPL Recording:
   - Akses baca sumber stok Logistik untuk assignment PPL sudah dibuka terbatas agar validasi stok Recording tidak salah membaca stok habis.
   - Jangan membuka akses kandang lain.

## Commit terbaru yang relevan
- 67cab08c16d1d56e04d438f6e3d2662c29a6cf30 — Add admin user activity log menu
- 4c0976d76dcc9f0bc72a0a3e5fa95e958d80182c — Always show saved estimate history
- 68db69337c5df63c906ec30dce652d0c4240da42 — Limit estimate history to selected active barn
- 1c6396b101ec0d003104ae4601d21dbaa7698743 — Show IN OUT FC Mort IP and revenue per bird in estimate dashboard
- 779b5e172cb4ffae0454e51da8147c700c5b9c0d — Base estimate dashboard KPIs on contract economics
- 82ddcaab6d252550bfc8cc8802b50b75b4d923b7 — Cache bust for contract-based estimate KPIs

## Instruksi untuk chat berikutnya
Mulai dengan membaca:
- main-1958.js
- style.css
- index.html
- file handoff ini
Lalu cek database Supabase yang aktif sebelum membuat klaim angka.
