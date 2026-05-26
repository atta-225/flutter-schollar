// =============================================================
// PENJELASAN FILE: lib/pages/saved_screen.dart
// File ini sudah diberi komentar singkat agar mudah dipresentasikan.
// Komentar tidak mengubah fungsi kode, hanya menjelaskan kegunaannya.
// =============================================================

import 'package:flutter/material.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import 'package:cloud_firestore/cloud_firestore.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import 'package:firebase_auth/firebase_auth.dart';

// Import package/file yang dibutuhkan oleh halaman ini.
import '../utils/app_colors.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import '../utils/firestore_collections.dart';

// Class SavedScreen adalah halaman tampilan pada aplikasi.
class SavedScreen extends StatelessWidget {
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  const SavedScreen({super.key});

  // Function async untuk proses yang membutuhkan waktu, seperti Firebase.
  Future<void> _removeSaved(BuildContext context, String id) async {
    // Menunggu proses async sampai selesai.
    await FirebaseFirestore.instance
        // Mengarah ke collection Firestore yang digunakan.
        .collection(FirestoreCollections.savedScholarships)
        // Mengarah ke document tertentu di Firestore.
        .doc(id)
        // Menghapus data dari Firestore.
        .delete();

    // Percabangan untuk mengecek kondisi tertentu.
    if (!context.mounted) return;

    // Menampilkan pesan singkat di bawah layar.
    ScaffoldMessenger.of(context).showSnackBar(
      // Variabel ini menyimpan data yang dipakai oleh widget/function.
      const SnackBar(
        // Menampilkan tulisan di layar.
        content: Text('Beasiswa tersimpan berhasil dihapus'),
      ),
    );
  }

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  // Method build dipakai Flutter untuk menggambar tampilan layar.
  Widget build(BuildContext context) {
    // Mengambil instance Firebase Auth untuk login/register/logout.
    final user = FirebaseAuth.instance.currentUser;

    // Percabangan untuk mengecek kondisi tertentu.
    if (user == null) {
      // Kerangka utama halaman Flutter.
      return Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(
          // Memberi jarak bagian dalam di sekitar widget.
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            // Menampilkan tulisan di layar.
            child: Text(
              'Silakan login untuk melihat beasiswa tersimpan.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      );
    }

    // Kerangka utama halaman Flutter.
    return Scaffold(
      backgroundColor: AppColors.bg,

      // Menyusun widget secara vertikal dari atas ke bawah.
      body: Column(
        children: [
          // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 65, 24, 35),
            // Mengatur dekorasi seperti warna, radius, shadow, atau border.
            decoration: const BoxDecoration(
              color: Color(0xFF5C8973),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(38),
                bottomRight: Radius.circular(38),
              ),
            ),
            // Menyusun widget secara vertikal dari atas ke bawah.
            child: Column(
              children: [
                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const Icon(
                  Icons.bookmark_rounded,
                  size: 55,
                  color: Colors.white,
                ),

                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const SizedBox(height: 12),

                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const Text(
                  'Saved Beasiswa',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),

                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const SizedBox(height: 6),

                // Menampilkan tulisan di layar.
                Text(
                  'List beasiswa yang sudah kamu simpan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(.9),
                  ),
                ),
              ],
            ),
          ),

          // Membuat widget mengisi sisa ruang yang tersedia.
          Expanded(
            // Widget untuk menampilkan data realtime dari stream.
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  // Mengarah ke collection Firestore yang digunakan.
                  .collection(FirestoreCollections.savedScholarships)
                  // Memfilter data dari Firestore.
                  .where('userId', isEqualTo: user.uid)
                  // Mengurutkan data dari Firestore.
                  .orderBy('savedAt', descending: true)
                  // Membaca data Firestore secara realtime.
                  .snapshots(),
              builder: (context, snapshot) {
                // Percabangan untuk mengecek kondisi tertentu.
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  // Mengembalikan hasil dari function/widget.
                  return const Center(
                    // Menampilkan loading saat data sedang diproses.
                    child: CircularProgressIndicator(),
                  );
                }

                // Percabangan untuk mengecek kondisi tertentu.
                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  // Mengembalikan hasil dari function/widget.
                  return Center(
                    // Memberi jarak bagian dalam di sekitar widget.
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                      ),
                      // Menyusun widget secara vertikal dari atas ke bawah.
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Menampilkan icon pada UI.
                          Icon(
                            Icons.bookmark_border_rounded,
                            size: 90,
                            color: AppColors.primary.withOpacity(.5),
                          ),

                          // Variabel ini menyimpan data yang dipakai oleh widget/function.
                          const SizedBox(height: 18),

                          // Menampilkan tulisan di layar.
                          Text(
                            'Belum ada beasiswa tersimpan.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                final docs = snapshot.data!.docs;

                // Menampilkan daftar yang bisa discroll.
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    18,
                    22,
                    18,
                    30,
                  ),
                  separatorBuilder: (_, _) =>
                      // Variabel ini menyimpan data yang dipakai oleh widget/function.
                      const SizedBox(height: 14),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    // Variabel ini menyimpan data yang dipakai oleh widget/function.
                    final data =
                        docs[index].data() as Map<String, dynamic>;

                    // Variabel ini menyimpan data yang dipakai oleh widget/function.
                    final id = docs[index].id;

                    // Variabel ini menyimpan data yang dipakai oleh widget/function.
                    final title =
                        '${data['title'] ?? 'Judul tidak tersedia'}';

                    // Variabel ini menyimpan data yang dipakai oleh widget/function.
                    final desc =
                        '${data['desc'] ?? 'Deskripsi tidak tersedia'}';

                    // Variabel ini menyimpan data yang dipakai oleh widget/function.
                    final region = '${data['region'] ?? ''}';

                    // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
                    return Container(
                      // Mengatur dekorasi seperti warna, radius, shadow, atau border.
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.08),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      // Memberi jarak bagian dalam di sekitar widget.
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        // Menyusun widget secara horizontal dari kiri ke kanan.
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
                            Container(
                              width: 55,
                              height: 55,
                              // Mengatur dekorasi seperti warna, radius, shadow, atau border.
                              decoration: BoxDecoration(
                                color: const Color(0xFF5C8973)
                                    .withOpacity(.15),
                                borderRadius:
                                    BorderRadius.circular(16),
                              ),
                              // Menampilkan icon pada UI.
                              child: const Icon(
                                Icons.school_rounded,
                                color: Color(0xFF5C8973),
                                size: 30,
                              ),
                            ),

                            // Variabel ini menyimpan data yang dipakai oleh widget/function.
                            const SizedBox(width: 14),

                            // Membuat widget mengisi sisa ruang yang tersedia.
                            Expanded(
                              // Menyusun widget secara vertikal dari atas ke bawah.
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  // Menampilkan tulisan di layar.
                                  Text(
                                    title,
                                    maxLines: 2,
                                    overflow:
                                        TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                          FontWeight.w800,
                                    ),
                                  ),

                                  // Variabel ini menyimpan data yang dipakai oleh widget/function.
                                  const SizedBox(height: 7),

                                  // Menampilkan tulisan di layar.
                                  Text(
                                    desc,
                                    maxLines: 2,
                                    overflow:
                                        TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black
                                          .withOpacity(.65),
                                      height: 1.4,
                                    ),
                                  ),

                                  // Variabel ini menyimpan data yang dipakai oleh widget/function.
                                  const SizedBox(height: 10),

                                  // Menyusun widget secara horizontal dari kiri ke kanan.
                                  Row(
                                    children: [
                                      // Variabel ini menyimpan data yang dipakai oleh widget/function.
                                      const Icon(
                                        Icons.location_on_outlined,
                                        size: 16,
                                        color: Colors.black54,
                                      ),

                                      // Variabel ini menyimpan data yang dipakai oleh widget/function.
                                      const SizedBox(width: 4),

                                      // Membuat widget mengisi sisa ruang yang tersedia.
                                      Expanded(
                                        // Menampilkan tulisan di layar.
                                        child: Text(
                                          region,
                                          maxLines: 1,
                                          overflow:
                                              TextOverflow
                                                  .ellipsis,
                                          style:
                                              // Variabel ini menyimpan data yang dipakai oleh widget/function.
                                              const TextStyle(
                                            fontSize: 12,
                                            fontWeight:
                                                FontWeight.w600,
                                            color:
                                                Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Widget tombol/klik untuk menjalankan aksi.
                            IconButton(
                              // Menampilkan icon pada UI.
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.red,
                                size: 28,
                              ),
                              onPressed: () =>
                                  _removeSaved(context, id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
