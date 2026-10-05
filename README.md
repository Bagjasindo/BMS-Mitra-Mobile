# BMS Mitra Online

## Garis Ketat RHPP
- **Sumber RHPP hanya Logistik dan Marketing.**
- **Logistik menjadi sumber Chick-In dan seluruh sapronak real: pengiriman, retur, tambah sapronak, transfer/alih barang, serta nilai biayanya.**
- **Marketing menjadi sumber panen real: Chick-Out/ekor panen, berat, harga, nilai panen, serta tambah daging bila ada.**
- **Mortalitas/Deplesi RHPP dihitung dari data real Chick-In Logistik dibanding Chick-Out/Panen Marketing.**
- **Recording PPL tidak boleh masuk, mengubah, mengoreksi, atau menjadi pembanding RHPP.**
- **Recording PPL tetap boleh dipakai untuk monitoring produksi dan sebagai acuan kematian/culling pada modul Estimasi saja.**
- **Estimasi tidak boleh membaca atau menulis RHPP. Estimasi memakai Panen aktual Marketing + kematian/culling dari Recording untuk menghitung sisa ayam simulasi.**
- **Liga ABK berdiri sendiri dan tidak boleh menjadi sumber, koreksi, bonus, atau komponen RHPP.**
- Perubahan kode, SQL, view, RPC, laporan, atau rekonsiliasi yang membuat Recording PPL, Estimasi, atau Liga ABK memengaruhi RHPP dianggap melanggar aturan ini dan tidak boleh diterapkan tanpa instruksi eksplisit Administrator.

