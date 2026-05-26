// =============================================================
// PENJELASAN FILE: lib/pages/detail_beasiswa_screen.dart
// File ini sudah diberi komentar singkat agar mudah dipresentasikan.
// Komentar tidak mengubah fungsi kode, hanya menjelaskan kegunaannya.
// =============================================================

// Import package/file yang dibutuhkan oleh halaman ini.
import 'package:flutter/material.dart';

// Import package/file yang dibutuhkan oleh halaman ini.
import '../utils/app_colors.dart';

// Class DetailBeasiswaScreen adalah halaman tampilan pada aplikasi.
class DetailBeasiswaScreen extends StatelessWidget {
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final String title;
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final String desc;
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final String detail;
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final String region;
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final String imageUrl;

  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  const DetailBeasiswaScreen({
    super.key,
    required this.title,
    required this.desc,
    required this.detail,
    required this.region,
    required this.imageUrl,
  });

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  // Method build dipakai Flutter untuk menggambar tampilan layar.
  Widget build(BuildContext context) {

    // Kerangka utama halaman Flutter.
    return Scaffold(
      backgroundColor: AppColors.bg,

      // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
      body: Container(
        width: double.infinity,

        constraints: const BoxConstraints(
          minHeight: double.infinity,
        ),

        // Mengatur dekorasi seperti warna, radius, shadow, atau border.
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,

            colors: [
              Color(0xFF72C386),
              Color(0xFFEFFFF6),
              Colors.white,
            ],

            stops: [0.0, 0.55, 1.0],
          ),
        ),

        // Menjaga UI agar tidak tertutup notch/status bar.
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              24,
              14,
              24,
              40,
            ),

            // Menyusun widget secara vertikal dari atas ke bawah.
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                /// BACK BUTTON
                // Widget tombol/klik untuk menjalankan aksi.
                IconButton(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,

                  // Menampilkan icon pada UI.
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    size: 32,
                    color: Colors.black,
                  ),

                  onPressed: () {
                    // Kembali ke halaman sebelumnya.
                    Navigator.pop(context);
                  },
                ),

                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const SizedBox(height: 16),

                /// IMAGE
                // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
                Container(
                  width: double.infinity,
                  height: 315,

                  // Mengatur dekorasi seperti warna, radius, shadow, atau border.
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(24),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(28),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),

                  // Memotong widget dengan sudut membulat.
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(24),

                    child: imageUrl.isNotEmpty
                        // Menampilkan gambar pada UI.
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,

                            errorBuilder:
                                (
                                  context,
                                  error,
                                  stackTrace,
                                ) {

                              // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
                              return Container(
                                color: Colors.white,

                                // Menampilkan icon pada UI.
                                child: const Icon(
                                  Icons.school_rounded,
                                  size: 70,
                                  color: Color(0xFF2F9D72),
                                ),
                              );
                            },
                          )

                        // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
                        : Container(
                            color:
                                Colors.white.withAlpha(180),

                            // Menampilkan icon pada UI.
                            child: const Icon(
                              Icons.image_outlined,
                              size: 70,
                              color: Colors.black38,
                            ),
                          ),
                  ),
                ),

                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const SizedBox(height: 22),

                /// REGION
                // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),

                  // Mengatur dekorasi seperti warna, radius, shadow, atau border.
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(
                      47,
                      157,
                      114,
                      0.12,
                    ),

                    borderRadius:
                        BorderRadius.circular(30),
                  ),

                  // Menampilkan tulisan di layar.
                  child: Text(
                    region,

                    style: const TextStyle(
                      color: Color(0xFF2F9D72),
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),

                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const SizedBox(height: 18),

                /// TITLE
                // Menampilkan tulisan di layar.
                Text(
                  title,

                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                    color: Colors.black,
                  ),
                ),

                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const SizedBox(height: 14),

                /// DESC
                // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(18),

                  // Mengatur dekorasi seperti warna, radius, shadow, atau border.
                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(20),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(14),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  // Menampilkan tulisan di layar.
                  child: Text(
                    desc,

                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                ),

                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const SizedBox(height: 24),

                /// TITLE DETAIL
                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const Text(
                  'Penjelasan Lengkap',

                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),

                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const SizedBox(height: 12),

                /// DETAIL
                // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(20),

                  // Mengatur dekorasi seperti warna, radius, shadow, atau border.
                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(22),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(14),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  // Menampilkan tulisan di layar.
                  child: Text(
                    detail,
                    textAlign: TextAlign.left,

                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      height: 1.7,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
