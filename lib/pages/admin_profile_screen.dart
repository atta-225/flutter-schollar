// =============================================================
// PENJELASAN FILE: lib/pages/admin_profile_screen.dart
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
// Import package/file yang dibutuhkan oleh halaman ini.
import '../widgets/app_logo.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import '../widgets/profile_widgets.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import 'edit_profile_screen.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import 'login_screen.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import 'admin_main_nav_screen.dart';

// Class AdminProfileScreen adalah halaman tampilan pada aplikasi.
class AdminProfileScreen extends StatelessWidget {
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  const AdminProfileScreen({super.key});

  // Function ini menjalankan aksi tertentu pada halaman.
  void _goToEditProfile(BuildContext context) {
    // Membuka halaman baru.
    Navigator.push(
      context,
      // Menentukan halaman tujuan saat navigasi.
      MaterialPageRoute(
        builder: (_) => const EditProfileScreen(),
      ),
    );
  }

  // Function async untuk proses yang membutuhkan waktu, seperti Firebase.
  Future<void> _logout(BuildContext context) async {
    // Variabel ini menyimpan data yang dipakai oleh widget/function.
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        // Menampilkan dialog konfirmasi/pesan.
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),

          // Menampilkan tulisan di layar.
          title: const Text(
            'Want to Logout?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          actionsAlignment: MainAxisAlignment.center,

          actions: [

            /// CANCEL
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(105, 45),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

              onPressed: () {
                // Kembali ke halaman sebelumnya.
                Navigator.pop(context, false);
              },

              // Menampilkan tulisan di layar.
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            /// LOGOUT
            // Widget tombol/klik untuk menjalankan aksi.
            ElevatedButton(
              // Widget tombol/klik untuk menjalankan aksi.
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEB3B00),
                foregroundColor: Colors.white,
                minimumSize: const Size(105, 45),
                elevation: 0,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),

                  side: const BorderSide(
                    color: Color(0xFFD9D9D9),
                    width: 2,
                  ),
                ),
              ),

              onPressed: () {
                // Kembali ke halaman sebelumnya.
                Navigator.pop(context, true);
              },

              // Menampilkan tulisan di layar.
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    // Percabangan untuk mengecek kondisi tertentu.
    if (result == true) {

      /// BACKEND LOGOUT FIREBASE
      // Mengakses fitur autentikasi Firebase.
      await FirebaseAuth.instance.signOut();

      // Percabangan untuk mengecek kondisi tertentu.
      if (!context.mounted) return;

      // Membuka halaman baru.
      Navigator.pushAndRemoveUntil(
        context,
        // Menentukan halaman tujuan saat navigasi.
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
        (route) => false,
      );
    }
  }

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  // Method build dipakai Flutter untuk menggambar tampilan layar.
  Widget build(BuildContext context) {

    // Mengambil instance Firebase Auth untuk login/register/logout.
    final user = FirebaseAuth.instance.currentUser;

    // Kerangka utama halaman Flutter.
    return Scaffold(
      backgroundColor: AppColors.bg,

      // Menumpuk widget di atas widget lain.
      body: Stack(
        children: [

          /// TOP BACKGROUND
          // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
          Container(
            height: 400,
            width: double.infinity,

            // Mengatur dekorasi seperti warna, radius, shadow, atau border.
            decoration: const BoxDecoration(
              color: Color(0xFF5C8973),

              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(70),
                bottomRight: Radius.circular(70),
              ),
            ),
          ),

          // Menjaga UI agar tidak tertutup notch/status bar.
          SafeArea(
            child: SingleChildScrollView(
              // Memberi jarak bagian dalam di sekitar widget.
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  22,
                  20,
                  22,
                  100,
                ),

                // Menyusun widget secara vertikal dari atas ke bawah.
                child: Column(
                  children: [

                    /// BACK BUTTON
                    Align(
                      alignment: Alignment.centerLeft,

                      // Widget tombol/klik untuk menjalankan aksi.
                      child: IconButton(
                        onPressed: () {
                          // Membuka halaman baru.
                          Navigator.pushReplacement(
                            context,
                            // Menentukan halaman tujuan saat navigasi.
                            MaterialPageRoute(
                              builder: (_) =>
                                  // Variabel ini menyimpan data yang dipakai oleh widget/function.
                                  const AdminMainNavScreen(),
                            ),
                          );
                        },

                        // Menampilkan icon pada UI.
                        icon: const Icon(
                          Icons.keyboard_backspace_rounded,
                          size: 29,
                        ),
                      ),
                    ),

                    // Variabel ini menyimpan data yang dipakai oleh widget/function.
                    const SizedBox(height: 6),

                    /// PHOTO PROFILE
                    // Menampilkan avatar/foto berbentuk lingkaran.
                    CircleAvatar(
                      radius: 47,
                      backgroundColor: const Color(0xFF9CFF9B),

                      // Menampilkan tulisan di layar.
                      child: Text(
                        getDisplayInitial(user),

                        style: const TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2E1748),
                        ),
                      ),
                    ),

                    // Variabel ini menyimpan data yang dipakai oleh widget/function.
                    const SizedBox(height: 18),

                    /// USER NAME
                    // Menampilkan tulisan di layar.
                    Text(
                      getDisplayName(user),

                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),

                    // Variabel ini menyimpan data yang dipakai oleh widget/function.
                    const SizedBox(height: 22),

                    /// LOGO
                    // Variabel ini menyimpan data yang dipakai oleh widget/function.
                    const AppLogo(size: 65),

                    // Variabel ini menyimpan data yang dipakai oleh widget/function.
                    const SizedBox(height: 16),

                    /// MENU CARD
                    // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
                    Container(
                      width: 298,

                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 20,
                      ),

                      // Mengatur dekorasi seperti warna, radius, shadow, atau border.
                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius: BorderRadius.circular(15),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(56),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),

                      // Menyusun widget secara vertikal dari atas ke bawah.
                      child: Column(
                        children: [

                          /// EDIT PROFILE
                          ProfileMenu(
                            icon: Icons.account_circle_outlined,
                            title: 'Edit Profile',
                            onTap: () =>
                                _goToEditProfile(context),
                          ),

                          // Variabel ini menyimpan data yang dipakai oleh widget/function.
                          const Divider(height: 18),

                          /// LOGOUT
                          ProfileMenu(
                            icon: Icons.logout_rounded,
                            title: 'Logout',
                            onTap: () =>
                                _logout(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
