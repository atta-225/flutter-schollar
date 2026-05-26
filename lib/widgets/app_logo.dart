// =============================================================
// PENJELASAN FILE: lib/widgets/app_logo.dart
// File ini sudah diberi komentar singkat agar mudah dipresentasikan.
// Komentar tidak mengubah fungsi kode, hanya menjelaskan kegunaannya.
// =============================================================

// Import package/file yang dibutuhkan oleh halaman ini.
import 'package:flutter/material.dart';

// Class AppLogo adalah komponen UI yang bisa dipakai ulang.
class AppLogo extends StatelessWidget {
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final double size;

  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  const AppLogo({
    super.key,
    this.size = 105,
  });

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  // Method build dipakai Flutter untuk menggambar tampilan layar.
  Widget build(BuildContext context) {
    // Menampilkan gambar pada UI.
    return Image.asset(
      'assets/images/logo.jpeg',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
