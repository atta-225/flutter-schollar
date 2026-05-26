// =============================================================
// PENJELASAN FILE: lib/widgets/profile_widgets.dart
// File ini sudah diberi komentar singkat agar mudah dipresentasikan.
// Komentar tidak mengubah fungsi kode, hanya menjelaskan kegunaannya.
// =============================================================

// Import package/file yang dibutuhkan oleh halaman ini.
import 'package:flutter/material.dart';

// Class ProfileMenu menyimpan struktur atau logic utama.
class ProfileMenu extends StatelessWidget {
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final IconData icon;
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final String title;
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final VoidCallback onTap;

  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  const ProfileMenu({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  // Method build dipakai Flutter untuk menggambar tampilan layar.
  Widget build(BuildContext context) {
    // Widget tombol/klik untuk menjalankan aksi.
    return InkWell(
      onTap: onTap,
      // Menyusun widget secara horizontal dari kiri ke kanan.
      child: Row(
        children: [
          // Menampilkan icon pada UI.
          Icon(icon, color: Colors.grey.shade500, size: 26),
          // Variabel ini menyimpan data yang dipakai oleh widget/function.
          const SizedBox(width: 14),
          // Menampilkan tulisan di layar.
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
