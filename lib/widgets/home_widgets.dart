// =============================================================
// PENJELASAN FILE: lib/widgets/home_widgets.dart
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

// Class HomeHeader menyimpan struktur atau logic utama.
class HomeHeader extends StatelessWidget {
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final VoidCallback onSearchTap;

  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  const HomeHeader({super.key, required this.onSearchTap});

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  // Method build dipakai Flutter untuk menggambar tampilan layar.
  Widget build(BuildContext context) {
    // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
    return Container(
      padding: const EdgeInsets.all(12),
      // Mengatur dekorasi seperti warna, radius, shadow, atau border.
      decoration: BoxDecoration(
        color: AppColors.primary2,
        borderRadius: BorderRadius.circular(13),
      ),
      // Menyusun widget secara vertikal dari atas ke bawah.
      child: Column(
        children: [
          // Menyusun widget secara horizontal dari kiri ke kanan.
          Row(
            children: [
              // Menampilkan avatar/foto berbentuk lingkaran.
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFFC9FF98),
                // Menampilkan tulisan di layar.
                child: Text(
                  // Mengakses fitur autentikasi Firebase.
                  getDisplayInitial(FirebaseAuth.instance.currentUser),
                  style: const TextStyle(
                    fontSize: 26,
                    color: Color(0xFF00606E),
                  ),
                ),
              ),
              // Variabel ini menyimpan data yang dipakai oleh widget/function.
              const SizedBox(width: 12),
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
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                    // Variabel ini menyimpan data yang dipakai oleh widget/function.
                    const SizedBox(height: 2),
                    // Variabel ini menyimpan data yang dipakai oleh widget/function.
                    const Text(
                      'Sudah memikirkan apa yg ingin kamu\ncapai dimasa depan?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Variabel ini menyimpan data yang dipakai oleh widget/function.
          const SizedBox(height: 14),
          // Widget tombol/klik untuk menjalankan aksi.
          GestureDetector(
            onTap: onSearchTap,
            // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
            child: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              // Mengatur dekorasi seperti warna, radius, shadow, atau border.
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
              ),
              // Menyusun widget secara horizontal dari kiri ke kanan.
              child: const Row(
                children: [
                  // Menampilkan icon pada UI.
                  Icon(Icons.search, color: Colors.black, size: 28),
                  // Memberi jarak kosong atau ukuran tetap.
                  SizedBox(width: 10),
                  // Menampilkan tulisan di layar.
                  Text(
                    'search for info',
                    style: TextStyle(fontSize: 13, color: Colors.black54),
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

// Class ScholarshipBanner menyimpan struktur atau logic utama.
class ScholarshipBanner extends StatefulWidget {
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  const ScholarshipBanner({super.key});

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  State<ScholarshipBanner> createState() => _ScholarshipBannerState();
}

// Class _ScholarshipBannerState menyimpan struktur atau logic utama.
class _ScholarshipBannerState extends State<ScholarshipBanner> {
  late final PageController controller;

  // List untuk menyimpan beberapa data yang akan ditampilkan.
  final List<String> banners = const [
    'assets/images/banner_1.jpeg',
    'assets/images/banner_2.jpeg',
    'assets/images/banner_3.jpeg',
  ];

  int currentPage = 1000;

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  // Method ini berjalan pertama kali saat halaman dibuka.
  void initState() {
    super.initState();
    controller = PageController(initialPage: currentPage);
    autoSlide();
  }

  // Function ini menjalankan aksi tertentu pada halaman.
  void autoSlide() async {
    while (mounted) {
      // Menunggu proses async sampai selesai.
      await Future.delayed(const Duration(seconds: 3));

      // Percabangan untuk mengecek kondisi tertentu.
      if (!mounted) return;

      currentPage++;

      controller.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    }
  }

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  // Method ini membersihkan controller agar tidak boros memori.
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  // Method build dipakai Flutter untuk menggambar tampilan layar.
  Widget build(BuildContext context) {
    // Memberi jarak kosong atau ukuran tetap.
    return SizedBox(
      height: 128,
      width: double.infinity,
      child: PageView.builder(
        controller: controller,
        onPageChanged: (index) {
          currentPage = index;
        },
        itemBuilder: (context, index) {
          // Variabel ini menyimpan data yang dipakai oleh widget/function.
          final banner = banners[index % banners.length];

          // Memotong widget dengan sudut membulat.
          return ClipRRect(
            borderRadius: BorderRadius.circular(13),
            // Menampilkan gambar pada UI.
            child: Image.asset(
              banner,
              width: double.infinity,
              height: 128,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          );
        },
      ),
    );
  }
}

// Class NewsCard menyimpan struktur atau logic utama.
class NewsCard extends StatelessWidget {
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final String title;
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final String desc;
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final String imageUrl;
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final bool showBookmark;
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final VoidCallback? onBookmarkTap;

  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  const NewsCard({
    super.key,
    required this.title,
    required this.desc,
    required this.imageUrl,
    this.showBookmark = true,
    this.onBookmarkTap,
  });

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  // Method build dipakai Flutter untuk menggambar tampilan layar.
  Widget build(BuildContext context) {
    // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      padding: const EdgeInsets.all(14),
      // Mengatur dekorasi seperti warna, radius, shadow, atau border.
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      // Menumpuk widget di atas widget lain.
      child: Stack(
        children: [
          // Menyusun widget secara horizontal dari kiri ke kanan.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
              Container(
                height: 102,
                width: 102,
                padding: const EdgeInsets.all(12),
                // Mengatur dekorasi seperti warna, radius, shadow, atau border.
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE8A3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: imageUrl.isNotEmpty
                    // Memotong widget dengan sudut membulat.
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        // Menampilkan gambar pada UI.
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            // Menampilkan icon pada UI.
                            return const Icon(
                              Icons.school_rounded,
                              color: Color(0xFF006B5F),
                              size: 48,
                            );
                          },
                        ),
                      )
                    // Menampilkan icon pada UI.
                    : const Icon(
                        Icons.school_rounded,
                        color: Color(0xFF006B5F),
                        size: 48,
                      ),
              ),
              // Variabel ini menyimpan data yang dipakai oleh widget/function.
              const SizedBox(width: 16),
              // Membuat widget mengisi sisa ruang yang tersedia.
              Expanded(
                // Memberi jarak bagian dalam di sekitar widget.
                child: Padding(
                  padding: EdgeInsets.only(
                    right: showBookmark ? 28 : 0,
                    bottom: showBookmark ? 22 : 0,
                  ),
                  // Menyusun widget secara vertikal dari atas ke bawah.
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Menampilkan tulisan di layar.
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          decoration: TextDecoration.underline,
                          color: Colors.black87,
                        ),
                      ),
                      // Variabel ini menyimpan data yang dipakai oleh widget/function.
                      const SizedBox(height: 10),
                      // Menampilkan tulisan di layar.
                      Text(
                        desc,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Percabangan untuk mengecek kondisi tertentu.
          if (showBookmark)
            // Mengatur posisi widget di dalam Stack.
            Positioned(
              right: 2,
              bottom: 2,
              // Widget tombol/klik untuk menjalankan aksi.
              child: GestureDetector(
                onTap: onBookmarkTap,
                // Menampilkan icon pada UI.
                child: const Icon(
                  Icons.bookmark,
                  color: Color(0xFFFFD23F),
                  size: 26,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
