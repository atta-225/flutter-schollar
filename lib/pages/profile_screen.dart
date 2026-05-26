// =============================================================
// PENJELASAN FILE: lib/pages/profile_screen.dart
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
import 'main_nav_screen.dart';

// Class ProfileScreen adalah halaman tampilan pada aplikasi.
class ProfileScreen extends StatelessWidget {
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  const ProfileScreen({super.key});

  // Function async untuk proses yang membutuhkan waktu, seperti Firebase.
  Future<void> logout(BuildContext context) async {
    // Variabel ini menyimpan data yang dipakai oleh widget/function.
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        // Menampilkan dialog konfirmasi/pesan.
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(
              color: Color(0xFFD9D9D9),
              width: 2,
            ),
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
        (_) => false,
      );
    }
  }

  // Function ini menjalankan aksi tertentu pada halaman.
  void goToEditProfile(BuildContext context) {
    // Membuka halaman baru.
    Navigator.push(
      context,
      // Menentukan halaman tujuan saat navigasi.
      MaterialPageRoute(
        builder: (_) => const EditProfileScreen(),
      ),
    );
  }

  // Function ini menjalankan aksi tertentu pada halaman.
  void goToHome(BuildContext context) {
    // Membuka halaman baru.
    Navigator.pushReplacement(
      context,
      // Menentukan halaman tujuan saat navigasi.
      MaterialPageRoute(
        builder: (_) => const MainNavScreen(),
      ),
    );
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
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
                // Menyusun widget secara vertikal dari atas ke bawah.
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      // Widget tombol/klik untuk menjalankan aksi.
                      child: IconButton(
                        // Menampilkan icon pada UI.
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          size: 32,
                        ),
                        onPressed: () => goToHome(context),
                      ),
                    ),

                    // Menampilkan avatar/foto berbentuk lingkaran.
                    CircleAvatar(
                      radius: 47,
                      backgroundColor: const Color(0xFF9CFF9B),
                      // Menampilkan tulisan di layar.
                      child: Text(
                        getDisplayInitial(user),
                        style: const TextStyle(
                          fontSize: 52,
                          color: Color(0xFF2E1748),
                        ),
                      ),
                    ),

                    // Variabel ini menyimpan data yang dipakai oleh widget/function.
                    const SizedBox(height: 18),

                    // Menampilkan tulisan di layar.
                    Text(
                      getDisplayName(user),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    // Variabel ini menyimpan data yang dipakai oleh widget/function.
                    const SizedBox(height: 22),

                    // Variabel ini menyimpan data yang dipakai oleh widget/function.
                    const AppLogo(size: 65),

                    // Variabel ini menyimpan data yang dipakai oleh widget/function.
                    const SizedBox(height: 16),

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
                            color: Colors.black.withOpacity(.22),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      // Menyusun widget secara vertikal dari atas ke bawah.
                      child: Column(
                        children: [
                          ProfileMenu(
                            icon: Icons.account_circle_outlined,
                            title: 'Edit Profile',
                            onTap: () => goToEditProfile(context),
                          ),

                          // Variabel ini menyimpan data yang dipakai oleh widget/function.
                          const Divider(height: 18),

                          ProfileMenu(
                            icon: Icons.logout_rounded,
                            title: 'Logout',
                            onTap: () => logout(context),
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
