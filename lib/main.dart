// =============================================================
// PENJELASAN FILE: lib/main.dart
// File ini sudah diberi komentar singkat agar mudah dipresentasikan.
// Komentar tidak mengubah fungsi kode, hanya menjelaskan kegunaannya.
// =============================================================

// Import package/file yang dibutuhkan oleh halaman ini.
import 'package:flutter/material.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import 'package:firebase_core/firebase_core.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import 'package:firebase_auth/firebase_auth.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import 'firebase_options.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import 'pages/login_screen.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import 'pages/main_nav_screen.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import 'pages/admin_main_nav_screen.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import 'utils/app_colors.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import 'utils/auth_helpers.dart';

// Function async untuk proses yang membutuhkan waktu, seperti Firebase.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Mencoba menjalankan proses yang mungkin gagal.
  try {
    // Menghubungkan aplikasi Flutter dengan Firebase.
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized successfully');
  // Menangkap error agar aplikasi tidak langsung berhenti.
  } catch (e) {
    debugPrint('Error initializing Firebase: $e');
  }

  runApp(const BorneoScholarApp());
}

// Class BorneoScholarApp menyimpan struktur atau logic utama.
class BorneoScholarApp extends StatelessWidget {
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  const BorneoScholarApp({super.key});

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  // Method build dipakai Flutter untuk menggambar tampilan layar.
  Widget build(BuildContext context) {
    // Mengembalikan hasil dari function/widget.
    return MaterialApp(
      title: 'Borneo Scholar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Arial',
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          elevation: 0,
        ),
      ),
      home: _getLandingPage(),
    );
  }

  Widget _getLandingPage() {
    // Widget untuk menampilkan data realtime dari stream.
    return StreamBuilder<User?>(
      // Mengakses fitur autentikasi Firebase.
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Percabangan untuk mengecek kondisi tertentu.
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Kerangka utama halaman Flutter.
          return const Scaffold(
            body: Center(
              // Menampilkan loading saat data sedang diproses.
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          );
        }

        // Percabangan untuk mengecek kondisi tertentu.
        if (snapshot.hasError) {
          debugPrint('Auth error: ${snapshot.error}');
          // Kerangka utama halaman Flutter.
          return Scaffold(
            body: Center(
              // Menampilkan tulisan di layar.
              child: Text(
                'Error: ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        // Percabangan untuk mengecek kondisi tertentu.
        if (snapshot.hasData) {
          // Widget untuk menampilkan hasil proses async.
          return FutureBuilder<bool>(
            future: isAdminAccount(snapshot.data!),
            builder: (context, adminSnapshot) {
              // Percabangan untuk mengecek kondisi tertentu.
              if (adminSnapshot.connectionState == ConnectionState.waiting) {
                // Kerangka utama halaman Flutter.
                return const Scaffold(
                  body: Center(
                    // Menampilkan loading saat data sedang diproses.
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                );
              }

              // Percabangan untuk mengecek kondisi tertentu.
              if (adminSnapshot.hasError) {
                // Mengembalikan hasil dari function/widget.
                return const MainNavScreen();
              }

              // Variabel ini menyimpan data yang dipakai oleh widget/function.
              final isAdmin = adminSnapshot.data == true;
              // Mengembalikan hasil dari function/widget.
              return isAdmin
                  ? const AdminMainNavScreen()
                  : const MainNavScreen();
            },
          );
        }

        // Mengembalikan hasil dari function/widget.
        return const LoginScreen();
      },
    );
  }
}
