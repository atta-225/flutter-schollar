// =============================================================
// PENJELASAN FILE: lib/widgets/auth_widgets.dart
// File ini sudah diberi komentar singkat agar mudah dipresentasikan.
// Komentar tidak mengubah fungsi kode, hanya menjelaskan kegunaannya.
// =============================================================

// Import package/file yang dibutuhkan oleh halaman ini.
import 'package:flutter/material.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import '../utils/app_colors.dart';

// Class AuthBackground menyimpan struktur atau logic utama.
class AuthBackground extends StatelessWidget {
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final Widget child;

  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  const AuthBackground({
    super.key,
    required this.child,
  });

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  // Method build dipakai Flutter untuk menggambar tampilan layar.
  Widget build(BuildContext context) {
    // Kerangka utama halaman Flutter.
    return Scaffold(
      // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Mengatur dekorasi seperti warna, radius, shadow, atau border.
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFC7EFD7),
              Color(0xFFF4FFF9),
            ],
          ),
        ),
        // Menjaga UI agar tidak tertutup notch/status bar.
        child: SafeArea(
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}

// Class AuthCard menyimpan struktur atau logic utama.
class AuthCard extends StatelessWidget {
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final Widget child;

  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  const AuthCard({
    super.key,
    required this.child,
  });

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  // Method build dipakai Flutter untuk menggambar tampilan layar.
  Widget build(BuildContext context) {
    // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
    return Container(
      width: 330,
      constraints: BoxConstraints(
         minHeight: 540,
        maxHeight: 580,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      // Mengatur dekorasi seperti warna, radius, shadow, atau border.
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(209),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white,
          width: 1.4,
        ),
      ),
      child: child,
    );
  }
}

// Class BigButton menyimpan struktur atau logic utama.
class BigButton extends StatelessWidget {
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final String text;
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final VoidCallback onTap;
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final bool loading;

  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  const BigButton({
    super.key,
    required this.text,
    required this.onTap,
    this.loading = false,
  });

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  // Method build dipakai Flutter untuk menggambar tampilan layar.
  Widget build(BuildContext context) {
    // Memberi jarak kosong atau ukuran tetap.
    return SizedBox(
      width: double.infinity,
      height: 42,
      // Widget tombol/klik untuk menjalankan aksi.
      child: ElevatedButton(
        // Widget tombol/klik untuk menjalankan aksi.
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: loading ? null : onTap,
        child: loading
            // Memberi jarak kosong atau ukuran tetap.
            ? SizedBox(
                width: 18,
                height: 18,
                // Menampilkan loading saat data sedang diproses.
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            // Menampilkan tulisan di layar.
            : Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
      ),
    );
  }
}

// Mengatur tampilan input seperti label, hint, dan border.
InputDecoration inputStyle(String hint, {Widget? suffix}) {
  // Mengatur tampilan input seperti label, hint, dan border.
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      color: Colors.black54,
      fontSize: 14,
    ),
    contentPadding: EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 16,
    ),
    filled: true,
    fillColor: Colors.white,
    suffixIcon: suffix,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: BorderSide(
        color: Colors.grey.shade300,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: BorderSide(
        color: AppColors.primary,
        width: 1.5,
      ),
    ),
  );
}
