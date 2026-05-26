// =============================================================
// PENJELASAN FILE: lib/widgets/admin_home_widgets.dart
// File ini sudah diberi komentar singkat agar mudah dipresentasikan.
// Komentar tidak mengubah fungsi kode, hanya menjelaskan kegunaannya.
// =============================================================

// Import package/file yang dibutuhkan oleh halaman ini.
import 'package:flutter/material.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import 'package:firebase_auth/firebase_auth.dart';

// Import package/file yang dibutuhkan oleh halaman ini.
import '../utils/app_colors.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import '../utils/auth_helpers.dart';

// Class AdminHeader menyimpan struktur atau logic utama.
class AdminHeader extends StatelessWidget {
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  const AdminHeader({super.key});

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  // Method build dipakai Flutter untuk menggambar tampilan layar.
  Widget build(BuildContext context) {
    // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 18, 12, 0),
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
      // Mengatur dekorasi seperti warna, radius, shadow, atau border.
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(13),
      ),
      // Menyusun widget secara vertikal dari atas ke bawah.
      child: Column(
        children: [
          // Menyusun widget secara horizontal dari kiri ke kanan.
          Row(
            children: [
              // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
              Container(
                width: 47,
                height: 47,
                // Mengatur dekorasi seperti warna, radius, shadow, atau border.
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFFBFFF86), Color(0xFF8DFFE8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                alignment: Alignment.center,
                // Menampilkan tulisan di layar.
                child: Text(
                  // Mengakses fitur autentikasi Firebase.
                  getDisplayInitial(FirebaseAuth.instance.currentUser),
                  style: const TextStyle(
                    fontSize: 24,
                    color: Color(0xFF004C6B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Variabel ini menyimpan data yang dipakai oleh widget/function.
              const SizedBox(width: 10),
              // Membuat widget mengisi sisa ruang yang tersedia.
              Expanded(
                // Menyusun widget secara vertikal dari atas ke bawah.
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Menampilkan tulisan di layar.
                    Text(
                      // Mengakses fitur autentikasi Firebase.
                      'Hi, ${getDisplayName(FirebaseAuth.instance.currentUser)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    // Variabel ini menyimpan data yang dipakai oleh widget/function.
                    const SizedBox(height: 2),
                    // Variabel ini menyimpan data yang dipakai oleh widget/function.
                    const Text(
                      'Sudah memikirkan apa yg ingin kamu\ncapai dimasa depan?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
              Container(
                width: 37,
                height: 37,
                // Mengatur dekorasi seperti warna, radius, shadow, atau border.
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                // Menampilkan icon pada UI.
                child: const Icon(
                  Icons.notifications_none_rounded,
                  size: 28,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          // Variabel ini menyimpan data yang dipakai oleh widget/function.
          const SizedBox(height: 12),
          // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
          Container(
            height: 41,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            // Mengatur dekorasi seperti warna, radius, shadow, atau border.
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            // Menyusun widget secara horizontal dari kiri ke kanan.
            child: const Row(
              children: [
                // Menampilkan icon pada UI.
                Icon(Icons.search_rounded, size: 25, color: Colors.black),
                // Memberi jarak kosong atau ukuran tetap.
                SizedBox(width: 10),
                // Menampilkan tulisan di layar.
                Text(
                  'search for info',
                  style: TextStyle(color: Color(0xFF555555), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Class ScholarshipBanner menyimpan struktur atau logic utama.
class ScholarshipBanner extends StatelessWidget {
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  const ScholarshipBanner({super.key});

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  // Method build dipakai Flutter untuk menggambar tampilan layar.
  Widget build(BuildContext context) {
    // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
    return Container(
      height: 121,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      // Mengatur dekorasi seperti warna, radius, shadow, atau border.
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        gradient: const LinearGradient(
          colors: [Color(0xFF0BBE85), Color(0xFF9DF0BA)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      // Menumpuk widget di atas widget lain.
      child: Stack(
        children: [
          // Mengatur posisi widget di dalam Stack.
          Positioned(
            left: 25,
            top: 8,
            // Menampilkan tulisan di layar.
            child: Text(
              'DAFTAR\nBEASISWA',
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 29,
                height: 0.9,
                fontWeight: FontWeight.w900,
                shadows: [
                  Shadow(
                    color: Colors.blue.shade700,
                    blurRadius: 2,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
            ),
          ),
          // Variabel ini menyimpan data yang dipakai oleh widget/function.
          const Positioned(
            left: 41,
            top: 80,
            // Menampilkan tulisan di layar.
            child: Text(
              'Dapatkan Kesempatan\nKuliah Gratis!',
              style: TextStyle(
                color: Color(0xFF0C3D95),
                fontSize: 12,
                fontWeight: FontWeight.w800,
                height: 0.9,
              ),
            ),
          ),
          // Mengatur posisi widget di dalam Stack.
          Positioned(
            right: -8,
            bottom: -8,
            // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
            child: Container(
              width: 135,
              height: 135,
              // Mengatur dekorasi seperti warna, radius, shadow, atau border.
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(64),
                shape: BoxShape.circle,
              ),
              // Menampilkan icon pada UI.
              child: const Icon(
                Icons.school_rounded,
                size: 78,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Class CategoryButton menyimpan struktur atau logic utama.
class CategoryButton extends StatelessWidget {
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final String title;
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final bool isActive;
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final VoidCallback onTap;

  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  const CategoryButton({
    super.key,
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  // Method build dipakai Flutter untuk menggambar tampilan layar.
  Widget build(BuildContext context) {
    // Widget tombol/klik untuk menjalankan aksi.
    return GestureDetector(
      onTap: onTap,
      // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
      child: Container(
        width: 64,
        alignment: Alignment.center,
        // Mengatur dekorasi seperti warna, radius, shadow, atau border.
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF2B6F59) : const Color(0xFF4BA77D),
          borderRadius: BorderRadius.circular(7),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withAlpha(64),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        // Menampilkan tulisan di layar.
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}

// Class NewsCard menyimpan struktur atau logic utama.
class NewsCard extends StatelessWidget {
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final String title;
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final String description;
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final String imageText;

  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  const NewsCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageText,
  });

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  // Method build dipakai Flutter untuk menggambar tampilan layar.
  Widget build(BuildContext context) {
    // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
    return Container(
      height: 102,
      margin: const EdgeInsets.symmetric(horizontal: 11),
      padding: const EdgeInsets.all(9),
      // Mengatur dekorasi seperti warna, radius, shadow, atau border.
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(64),
            blurRadius: 5,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      // Menyusun widget secara horizontal dari kiri ke kanan.
      child: Row(
        children: [
          // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
          Container(
            width: 66,
            height: 82,
            // Mengatur dekorasi seperti warna, radius, shadow, atau border.
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: const LinearGradient(
                colors: [Color(0xFFFFE27A), Color(0xFF3CC389)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            alignment: Alignment.center,
            // Menampilkan tulisan di layar.
            child: Text(
              imageText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 9,
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          // Variabel ini menyimpan data yang dipakai oleh widget/function.
          const SizedBox(width: 9),
          // Membuat widget mengisi sisa ruang yang tersedia.
          Expanded(
            // Memberi jarak bagian dalam di sekitar widget.
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              // Menyusun widget secara vertikal dari atas ke bawah.
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Menampilkan tulisan di layar.
                  Text(
                    title,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  // Variabel ini menyimpan data yang dipakai oleh widget/function.
                  const SizedBox(height: 4),
                  // Menampilkan tulisan di layar.
                  Text(
                    description,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 8,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
