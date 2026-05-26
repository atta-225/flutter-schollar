// =============================================================
// PENJELASAN FILE: lib/widgets/admin_profile_widgets.dart
// File ini sudah diberi komentar singkat agar mudah dipresentasikan.
// Komentar tidak mengubah fungsi kode, hanya menjelaskan kegunaannya.
// =============================================================

// Import package/file yang dibutuhkan oleh halaman ini.
import 'package:flutter/material.dart';

// Class ProfileMenuItem menyimpan struktur atau logic utama.
class ProfileMenuItem extends StatelessWidget {
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final IconData icon;
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final String title;
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final bool hasSwitch;
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final bool showDivider;

  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.hasSwitch = false,
    this.showDivider = true,
  });

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  // Method build dipakai Flutter untuk menggambar tampilan layar.
  Widget build(BuildContext context) {
    // Menyusun widget secara vertikal dari atas ke bawah.
    return Column(
      children: [
        // Memberi jarak kosong atau ukuran tetap.
        SizedBox(
          height: 36,
          // Menyusun widget secara horizontal dari kiri ke kanan.
          child: Row(
            children: [
              // Menampilkan icon pada UI.
              Icon(
                icon,
                color: const Color(0xFF9E9E9E),
                size: 23,
              ),
              // Variabel ini menyimpan data yang dipakai oleh widget/function.
              const SizedBox(width: 13),
              // Membuat widget mengisi sisa ruang yang tersedia.
              Expanded(
                // Menampilkan tulisan di layar.
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ),
              // Percabangan untuk mengecek kondisi tertentu.
              if (hasSwitch)
                Switch(
                  value: true,
                  activeThumbColor: Colors.white,
                  activeTrackColor: const Color(0xFF67C54E),
                  onChanged: (_) {},
                ),
            ],
          ),
        ),
        // Percabangan untuk mengecek kondisi tertentu.
        if (showDivider)
          // Variabel ini menyimpan data yang dipakai oleh widget/function.
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFE2E2E2),
          ),
      ],
    );
  }
}
