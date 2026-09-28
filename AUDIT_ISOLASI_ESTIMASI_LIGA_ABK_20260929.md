# Audit Isolasi Estimasi & Liga ABK — 29 September 2026

## Estimasi
- Membaca `recordings` hanya untuk kematian/culling sebagai acuan sisa ayam Estimasi.
- Tidak membaca `logistics_rhpp_cost_summary`.
- Tidak membaca atau menulis tabel/fungsi RHPP.
- Data aktual simulasi berasal dari kematian/culling Recording dan Panen Marketing yang sudah tersimpan.
- Sisa ayam dihitung dari Chick-In dikurangi kematian/culling Recording dan dikurangi Panen Marketing aktual.
- Input estimasi hanya menyimpan ke `production_estimates` dan `production_estimate_sizes`.
- Estimasi tidak memengaruhi RHPP Sistem maupun RHPP Real.

## Liga ABK
- Tidak membaca `logistics_rhpp_cost_summary`.
- Tidak membaca atau menulis tabel/fungsi RHPP.
- Tidak ada fungsi RHPP yang membaca `production_abk_results`, `production_abk_result_sizes`, atau `abk_league`.
- Liga ABK hanya modul penilaian/performa internal ABK dan tidak boleh memengaruhi RHPP.

## Verifikasi
- Frontend Estimasi: `recordings` dipakai hanya untuk mortalitas/culling Estimasi; bukan RHPP.
- Frontend Estimasi: referensi langsung ke `logistics_rhpp_cost_summary` = 0.
- Frontend Liga ABK: referensi langsung ke `logistics_rhpp_cost_summary` = 0.
- Backend RHPP -> tabel Liga ABK = tidak ada.
- Backend RHPP -> tabel Estimasi = tidak ada.
