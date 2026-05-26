// =============================================================
// PENJELASAN FILE: lib/pages/admin_home_screen.dart
// File ini sudah diberi komentar singkat agar mudah dipresentasikan.
// Komentar tidak mengubah fungsi kode, hanya menjelaskan kegunaannya.
// =============================================================

// Import package/file yang dibutuhkan oleh halaman ini.
import 'package:flutter/material.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import 'package:cloud_firestore/cloud_firestore.dart';

// Import package/file yang dibutuhkan oleh halaman ini.
import '../utils/app_colors.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import '../widgets/home_widgets.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import 'edit_beasiswa_screen.dart';

// Class AdminHomeScreen adalah halaman tampilan pada aplikasi.
class AdminHomeScreen extends StatefulWidget {
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final VoidCallback? onSearchTap;

  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  const AdminHomeScreen({
    super.key,
    this.onSearchTap,
  });

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

// Class _AdminHomeScreenState adalah halaman tampilan pada aplikasi.
class _AdminHomeScreenState extends State<AdminHomeScreen> {
  String selectedCategory = 'All';

  // List untuk menyimpan beberapa data yang akan ditampilkan.
  final List<String> categories = [
    'All',
    'Kalsel',
    'Kaltim',
    'Kalteng',
    'Kalbar',
  ];

  // Function ini menjalankan aksi tertentu pada halaman.
  void openSearch() {
    widget.onSearchTap?.call();
  }

  List<QueryDocumentSnapshot> filterDocs(List<QueryDocumentSnapshot> docs) {
    // Mengembalikan hasil dari function/widget.
    if (selectedCategory == 'All') return docs;

    // Memfilter data dari Firestore.
    return docs.where((doc) {
      // Map untuk menyimpan data dalam bentuk key dan value.
      final data = doc.data() as Map<String, dynamic>;
      // Mengembalikan hasil dari function/widget.
      return '${data['region'] ?? ''}' == selectedCategory;
    }).toList();
  }

  // Function async untuk proses yang membutuhkan waktu, seperti Firebase.
  Future<void> deleteData(String id) async {
    // Variabel ini menyimpan data yang dipakai oleh widget/function.
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        // Menampilkan dialog konfirmasi/pesan.
        return AlertDialog(
          // Menampilkan tulisan di layar.
          title: const Text('Are you sure want to delete this data?'),
          actions: [
            // Widget tombol/klik untuk menjalankan aksi.
            TextButton(
              // Kembali ke halaman sebelumnya.
              onPressed: () => Navigator.pop(context, false),
              // Menampilkan tulisan di layar.
              child: const Text('Batal'),
            ),
            // Widget tombol/klik untuk menjalankan aksi.
            ElevatedButton(
              // Kembali ke halaman sebelumnya.
              onPressed: () => Navigator.pop(context, true),
              // Widget tombol/klik untuk menjalankan aksi.
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              // Menampilkan tulisan di layar.
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    // Percabangan untuk mengecek kondisi tertentu.
    if (confirm != true) return;

    // Mengarah ke collection Firestore yang digunakan.
    await FirebaseFirestore.instance.collection('beasiswa').doc(id).delete();

    // Percabangan untuk mengecek kondisi tertentu.
    if (!mounted) return;

    // Menampilkan pesan singkat di bawah layar.
    ScaffoldMessenger.of(context).showSnackBar(
      // Variabel ini menyimpan data yang dipakai oleh widget/function.
      const SnackBar(
        // Menampilkan tulisan di layar.
        content: Text('Data berhasil dihapus'),
      ),
    );
  }

  Widget emptyData(String text) {
    // Memberi jarak bagian dalam di sekitar widget.
    return Padding(
      padding: const EdgeInsets.only(top: 55),
      child: Center(
        // Menyusun widget secara vertikal dari atas ke bawah.
        child: Column(
          children: [
            // Menampilkan icon pada UI.
            Icon(
              Icons.school_outlined,
              size: 70,
              color: Colors.green.shade300,
            ),
            // Variabel ini menyimpan data yang dipakai oleh widget/function.
            const SizedBox(height: 14),
            // Menampilkan tulisan di layar.
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            // Variabel ini menyimpan data yang dipakai oleh widget/function.
            const SizedBox(height: 6),
            // Variabel ini menyimpan data yang dipakai oleh widget/function.
            const Text(
              'Tambahkan data melalui menu tambah',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  // Method build dipakai Flutter untuk menggambar tampilan layar.
  Widget build(BuildContext context) {
    // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
    return Container(
      // Mengatur dekorasi seperti warna, radius, shadow, atau border.
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF72C386),
            Color(0xFFA8DDB4),
            Color(0xFFEFFFF6),
          ],
          stops: [0.0, 0.45, 1.0],
        ),
      ),
      // Menjaga UI agar tidak tertutup notch/status bar.
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 100),
          // Menyusun widget secara vertikal dari atas ke bawah.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(
                onSearchTap: openSearch,
              ),

              // Variabel ini menyimpan data yang dipakai oleh widget/function.
              const SizedBox(height: 20),

              // Variabel ini menyimpan data yang dipakai oleh widget/function.
              const ScholarshipBanner(),

              // Variabel ini menyimpan data yang dipakai oleh widget/function.
              const SizedBox(height: 20),

              // Memberi jarak kosong atau ukuran tetap.
              SizedBox(
                height: 42,
                // Menampilkan daftar yang bisa discroll.
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    // Variabel ini menyimpan data yang dipakai oleh widget/function.
                    final category = categories[index];
                    // Variabel ini menyimpan data yang dipakai oleh widget/function.
                    final active = selectedCategory == category;

                    // Memberi jarak bagian dalam di sekitar widget.
                    return Padding(
                      padding: const EdgeInsets.only(right: 27),
                      // Widget tombol/klik untuk menjalankan aksi.
                      child: GestureDetector(
                        onTap: () {
                          // Memperbarui tampilan setelah data berubah.
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                        // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          height: 38,
                          alignment: Alignment.center,
                          // Mengatur dekorasi seperti warna, radius, shadow, atau border.
                          decoration: BoxDecoration(
                            color: active
                                ? AppColors.primary.withOpacity(0.9)
                                : AppColors.primary2.withOpacity(0.75),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: active
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(.18),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : [],
                          ),
                          // Menampilkan tulisan di layar.
                          child: Text(
                            category,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Variabel ini menyimpan data yang dipakai oleh widget/function.
              const SizedBox(height: 20),

              // Variabel ini menyimpan data yang dipakai oleh widget/function.
              const Text(
                'New',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),

              // Variabel ini menyimpan data yang dipakai oleh widget/function.
              const SizedBox(height: 12),

              // Widget untuk menampilkan data realtime dari stream.
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    // Mengarah ke collection Firestore yang digunakan.
                    .collection('beasiswa')
                    // Mengurutkan data dari Firestore.
                    .orderBy('createdAt', descending: true)
                    // Membaca data Firestore secara realtime.
                    .snapshots(),
                builder: (context, snapshot) {
                  // Percabangan untuk mengecek kondisi tertentu.
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Memberi jarak bagian dalam di sekitar widget.
                    return const Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: Center(
                        // Menampilkan loading saat data sedang diproses.
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  // Percabangan untuk mengecek kondisi tertentu.
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    // Mengembalikan hasil dari function/widget.
                    return emptyData('Belum ada data beasiswa');
                  }

                  // Variabel ini menyimpan data yang dipakai oleh widget/function.
                  final docs = filterDocs(snapshot.data!.docs);

                  // Percabangan untuk mengecek kondisi tertentu.
                  if (docs.isEmpty) {
                    // Mengembalikan hasil dari function/widget.
                    return emptyData('Belum ada data di kategori ini');
                  }

                  // Menyusun widget secara vertikal dari atas ke bawah.
                  return Column(
                    // Melakukan perulangan untuk mengolah banyak data.
                    children: docs.map((doc) {
                      // Map untuk menyimpan data dalam bentuk key dan value.
                      final data = doc.data() as Map<String, dynamic>;

                      // Memberi jarak bagian dalam di sekitar widget.
                      return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      // Menumpuk widget di atas widget lain.
                      child: Stack(
                        children: [
                          NewsCard(
                            title: '${data['title'] ?? ''}',
                            desc: '${data['desc'] ?? ''}',
                            imageUrl: '${data['imageUrl'] ?? ''}',
                            showBookmark: false,
                          ),

                          // Mengatur posisi widget di dalam Stack.
                          Positioned(
                          right: 14,
                          top: 14,
                            // Menyusun widget secara horizontal dari kiri ke kanan.
                            child: Row(
                              children: [
                                // Widget tombol/klik untuk menjalankan aksi.
                                GestureDetector(
                                  onTap: () {
                                    // Membuka halaman baru.
                                    Navigator.push(
                                      context,
                                      // Menentukan halaman tujuan saat navigasi.
                                      MaterialPageRoute(
                                        builder: (_) => EditBeasiswaScreen(
                                          docId: doc.id,
                                          oldTitle: '${data['title'] ?? ''}',
                                          oldDesc: '${data['desc'] ?? ''}',
                                          oldDetail: '${data['detail'] ?? ''}',
                                          oldRegion: '${data['region'] ?? ''}',
                                          oldImageUrl: '${data['imageUrl'] ?? ''}',
                                        ),
                                      ),
                                    );
                                  },
                                  // Menampilkan icon pada UI.
                                  child: const Icon(
                                    Icons.edit_outlined,
                                    color: Color(0xFFFFD600),
                                    size: 30,
                                  ),
                                ),

                                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                                const SizedBox(width: 14),

                                // Widget tombol/klik untuk menjalankan aksi.
                                GestureDetector(
                                  onTap: () => deleteData(doc.id),
                                  // Menampilkan icon pada UI.
                                  child: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                    size: 32,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
