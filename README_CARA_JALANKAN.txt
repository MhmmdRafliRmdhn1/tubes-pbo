CARA MENJALANKAN PROJECT JAVA WEB 2F - LOGIN FIXED

1. Buka XAMPP Control Panel.
2. Start Apache dan MySQL.
3. Buka browser: http://localhost/phpmyadmin
4. Import database/cafe_aura.sql
   - Jika database lama sudah ada, aman karena SQL memakai DROP DATABASE IF EXISTS.
5. Buka NetBeans.
6. File > Open Project > pilih folder CafeAuraJavaWeb.
7. Pastikan server memakai Apache Tomcat 10 / 10.1.
8. Run project.
9. Buka: http://localhost:8080/CafeAuraJavaWeb

AKUN DEFAULT:
Admin    : admin@2f.com / admin123
Staff    : staff@2f.com / staff123
Customer : customer@2f.com / customer123

JIKA LOGIN MASIH SALAH:
1. Pastikan kolom Password benar-benar diisi, bukan dibiarkan kosong.
2. Import ulang file database/cafe_aura.sql di phpMyAdmin.
3. Cek di phpMyAdmin > database cafe_aura > tabel users.
4. Pastikan ada data:
   admin@2f.com | admin123 | ADMIN | active = 1
5. Jika XAMPP MySQL memakai password, ubah file:
   src/main/java/com/cafeaura/config/DBConnection.java

FITUR:
- Tampilan 2F aesthetic POS.
- Customer: Tambah Pesanan, kategori menu, current order, payment QRIS/Cash/Debit/Credit, payment success.
- Staff: Kelola pesanan, update status, konfirmasi pembayaran.
- Admin: Kelola menu, order, payment, user, laporan.

UPDATE DESAIN FOODIES DASHBOARD
- Tampilan terbaru dibuat lebih modern, simple, dan aesthetic dengan layout POS restaurant/cafe.
- Customer memiliki sidebar kiri, kategori menu, grid menu, panel Current Order di kanan, serta tombol Continue to payment.
- Warna utama menggunakan tema hijau-biru, kartu rounded, dan shadow lembut agar tampilan terlihat modern dan bersih.
- Payment QRIS dan halaman pembayaran berhasil tetap tersedia.

UPDATE LOGIN CLEAN:
- Background login sudah diganti menjadi gambar kopi bersih tanpa tulisan bawaan.
- Card “Solusi terbaik” pada panel gambar login sudah dihapus.
- Jika tampilan lama masih muncul, tekan Ctrl + F5 atau clear cache browser.
