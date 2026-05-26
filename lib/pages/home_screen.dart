// =============================================================
// PENJELASAN FILE: lib/pages/home_screen.dart
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
import 'detail_beasiswa_screen.dart';

// Class HomeScreen adalah halaman tampilan pada aplikasi.
class HomeScreen extends StatefulWidget {
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final VoidCallback? onSearchTap;

  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  const HomeScreen({
    super.key,
    this.onSearchTap,
  });

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// Class _HomeScreenState adalah halaman tampilan pada aplikasi.
class _HomeScreenState extends State<HomeScreen> {
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

  // Function ini menjalankan aksi tertentu pada halaman.
  void openDetail(Map<String, dynamic> data) {
    // Membuka halaman baru.
    Navigator.push(
      context,
      // Menentukan halaman tujuan saat navigasi.
      MaterialPageRoute(
        builder: (_) => DetailBeasiswaScreen(
          title: '${data['title'] ?? ''}',
          desc: '${data['desc'] ?? ''}',
          detail: '${data['detail'] ?? ''}',
          region: '${data['region'] ?? ''}',
          imageUrl: '${data['imageUrl'] ?? ''}',
        ),
      ),
    );
  }

  // Function async untuk proses yang membutuhkan waktu, seperti Firebase.
  Future<void> saveBeasiswa(Map<String, dynamic> data) async {
    // Mengarah ke collection Firestore yang digunakan.
    await FirebaseFirestore.instance.collection('saved_beasiswa').add({
      'title': '${data['title'] ?? ''}',
      'desc': '${data['desc'] ?? ''}',
      'detail': '${data['detail'] ?? ''}',
      'region': '${data['region'] ?? ''}',
      'imageUrl': '${data['imageUrl'] ?? ''}',
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Percabangan untuk mengecek kondisi tertentu.
    if (!mounted) return;

    // Menampilkan pesan singkat di bawah layar.
    ScaffoldMessenger.of(context).showSnackBar(
      // Variabel ini menyimpan data yang dipakai oleh widget/function.
      const SnackBar(
        // Menampilkan tulisan di layar.
        content: Text('Beasiswa berhasil disimpan'),
        backgroundColor: Color(0xFF2F9D72),
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
              'Beasiswa akan tampil jika admin sudah menambahkan',
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

                      // Widget tombol/klik untuk menjalankan aksi.
                      return GestureDetector(
                        onTap: () => openDetail(data),
                        child: NewsCard(
                          title: '${data['title'] ?? ''}',
                          desc: '${data['desc'] ?? ''}',
                          imageUrl: '${data['imageUrl'] ?? ''}',
                          onBookmarkTap: () => saveBeasiswa(data),
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
