// =============================================================
// PENJELASAN FILE: lib/pages/admin_main_nav_screen.dart
// File ini sudah diberi komentar singkat agar mudah dipresentasikan.
// Komentar tidak mengubah fungsi kode, hanya menjelaskan kegunaannya.
// =============================================================

// Import package/file yang dibutuhkan oleh halaman ini.
import 'package:flutter/material.dart';

// Import package/file yang dibutuhkan oleh halaman ini.
import '../utils/app_colors.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import 'admin_home_screen.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import 'admin_add_news_screen.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import 'admin_profile_screen.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import 'search_screen.dart';

// Class AdminMainNavScreen adalah halaman tampilan pada aplikasi.
class AdminMainNavScreen extends StatefulWidget {
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  const AdminMainNavScreen({super.key});

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  State<AdminMainNavScreen> createState() => _AdminMainNavScreenState();
}

// Class _AdminMainNavScreenState adalah halaman tampilan pada aplikasi.
class _AdminMainNavScreenState extends State<AdminMainNavScreen> {
  int index = 0;
  bool showSearch = false;

  // Function ini menjalankan aksi tertentu pada halaman.
  void changePage(int newIndex) {
    // Memperbarui tampilan setelah data berubah.
    setState(() {
      index = newIndex;
      showSearch = false;
    });
  }

  // Function ini menjalankan aksi tertentu pada halaman.
  void openSearch() {
    // Memperbarui tampilan setelah data berubah.
    setState(() {
      showSearch = true;
    });
  }

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  // Method build dipakai Flutter untuk menggambar tampilan layar.
  Widget build(BuildContext context) {
    Widget currentPage;

    // Percabangan untuk mengecek kondisi tertentu.
    if (showSearch) {
      currentPage = const SearchScreen(isAdmin: true);
    // Bagian ini dijalankan jika kondisi sebelumnya tidak terpenuhi.
    } else {
      currentPage = [
        AdminHomeScreen(onSearchTap: openSearch),
        // Variabel ini menyimpan data yang dipakai oleh widget/function.
        const AdminAddNewsScreen(),
        // Variabel ini menyimpan data yang dipakai oleh widget/function.
        const AdminProfileScreen(),
      ][index];
    }

    // Kerangka utama halaman Flutter.
    return Scaffold(
      body: currentPage,
      // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
      bottomNavigationBar: Container(
        height: 68,
        padding: const EdgeInsets.only(bottom: 6),
        // Mengatur dekorasi seperti warna, radius, shadow, atau border.
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        // Menyusun widget secara horizontal dari kiri ke kanan.
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            AdminNavItem(
              icon: Icons.home_rounded,
              active: !showSearch && index == 0,
              onTap: () => changePage(0),
            ),
            AdminNavItem(
              icon: Icons.add_box_rounded,
              active: !showSearch && index == 1,
              onTap: () => changePage(1),
            ),
            AdminNavItem(
              icon: Icons.person_rounded,
              active: !showSearch && index == 2,
              onTap: () => changePage(2),
            ),
          ],
        ),
      ),
    );
  }
}

// Class AdminNavItem menyimpan struktur atau logic utama.
class AdminNavItem extends StatelessWidget {
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final IconData icon;
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final bool active;
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final VoidCallback onTap;

  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  const AdminNavItem({
    super.key,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  // Method build dipakai Flutter untuk menggambar tampilan layar.
  Widget build(BuildContext context) {
    // Widget tombol/klik untuk menjalankan aksi.
    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: onTap,
      // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
      child: Container(
        width: 56,
        height: 48,
        alignment: Alignment.center,
        // Menampilkan icon pada UI.
        child: Icon(
          icon,
          size: active ? 34 : 30,
          color: active ? AppColors.primary : AppColors.primary2,
        ),
      ),
    );
  }
}
