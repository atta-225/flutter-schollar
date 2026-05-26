// =============================================================
// PENJELASAN FILE: lib/pages/search_screen.dart
// File ini sudah diberi komentar singkat agar mudah dipresentasikan.
// Komentar tidak mengubah fungsi kode, hanya menjelaskan kegunaannya.
// =============================================================

// Import package/file yang dibutuhkan oleh halaman ini.
import 'package:flutter/material.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import 'package:cloud_firestore/cloud_firestore.dart';

// Import package/file yang dibutuhkan oleh halaman ini.
import '../utils/firestore_collections.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import 'detail_beasiswa_screen.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import 'admin_main_nav_screen.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import 'main_nav_screen.dart';

// Class SearchScreen adalah halaman tampilan pada aplikasi.
class SearchScreen extends StatefulWidget {
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final bool isAdmin;

  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  const SearchScreen({
    super.key,
    this.isAdmin = false,
  });

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

// Class _SearchScreenState adalah halaman tampilan pada aplikasi.
class _SearchScreenState extends State<SearchScreen> {
  // Controller untuk membaca dan mengatur isi input text.
  final TextEditingController searchController = TextEditingController();

  String keyword = '';
  // List untuk menyimpan beberapa data yang akan ditampilkan.
  final List<String> recentSearches = [];

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  // Method ini membersihkan controller agar tidak boros memori.
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Function ini menjalankan aksi tertentu pada halaman.
  void goToHome() {
    // Percabangan untuk mengecek kondisi tertentu.
    if (widget.isAdmin) {
      // Membuka halaman baru.
      Navigator.pushReplacement(
        context,
        // Menentukan halaman tujuan saat navigasi.
        MaterialPageRoute(
          builder: (_) => const AdminMainNavScreen(),
        ),
      );
    // Bagian ini dijalankan jika kondisi sebelumnya tidak terpenuhi.
    } else {
      // Membuka halaman baru.
      Navigator.pushReplacement(
        context,
        // Menentukan halaman tujuan saat navigasi.
        MaterialPageRoute(
          builder: (_) => const MainNavScreen(),
        ),
      );
    }
  }

  // Function ini menjalankan aksi tertentu pada halaman.
  void openDetail(Map<String, dynamic> data) {
    // Percabangan untuk mengecek kondisi tertentu.
    if (widget.isAdmin) return;

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
  Future<void> deleteData(String id) async {
    // Menunggu proses async sampai selesai.
    await FirebaseFirestore.instance
        // Mengarah ke collection Firestore yang digunakan.
        .collection(FirestoreCollections.scholarships)
        // Mengarah ke document tertentu di Firestore.
        .doc(id)
        // Menghapus data dari Firestore.
        .delete();

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

  // Function ini menjalankan aksi tertentu pada halaman.
  void addRecentSearch(String value) {
    // Variabel ini menyimpan data yang dipakai oleh widget/function.
    final text = value.trim();

    // Percabangan untuk mengecek kondisi tertentu.
    if (text.isEmpty) return;

    recentSearches.removeWhere(
      (item) => item.toLowerCase() == text.toLowerCase(),
    );

    recentSearches.insert(0, text);

    // Percabangan untuk mengecek kondisi tertentu.
    if (recentSearches.length > 5) {
      recentSearches.removeLast();
    }
  }

  // Function ini menjalankan aksi tertentu pada halaman.
  void useRecentSearch(String text) {
    searchController.text = text;

    // Memperbarui tampilan setelah data berubah.
    setState(() {
      keyword = text.toLowerCase().trim();
      addRecentSearch(text);
    });
  }

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  // Method build dipakai Flutter untuk menggambar tampilan layar.
  Widget build(BuildContext context) {
    // Kerangka utama halaman Flutter.
    return Scaffold(
      backgroundColor: const Color(0xFFEFFFF6),
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
              Color(0xFF72C386),
              Color(0xFFEFFFF6),
              Colors.white,
            ],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        // Menjaga UI agar tidak tertutup notch/status bar.
        child: SafeArea(
          // Menyusun widget secara vertikal dari atas ke bawah.
          child: Column(
            children: [
              // Memberi jarak bagian dalam di sekitar widget.
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 18, 24, 0),
                // Menyusun widget secara horizontal dari kiri ke kanan.
                child: Row(
                  children: [
                    // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
                    Container(
                      width: 41,
                      height: 41,
                      // Mengatur dekorasi seperti warna, radius, shadow, atau border.
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      // Widget tombol/klik untuk menjalankan aksi.
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: goToHome,
                        // Menampilkan icon pada UI.
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 22,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    // Variabel ini menyimpan data yang dipakai oleh widget/function.
                    const SizedBox(width: 9),

                    // Membuat widget mengisi sisa ruang yang tersedia.
                    Expanded(
                      // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
                      child: Container(
                        height: 45,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        // Mengatur dekorasi seperti warna, radius, shadow, atau border.
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        // Input text biasa dari user.
                        child: TextField(
                          controller: searchController,
                          autofocus: true,
                          onChanged: (value) {
                            // Memperbarui tampilan setelah data berubah.
                            setState(() {
                              keyword =
                                  value.toLowerCase().trim();

                              addRecentSearch(value);
                            });
                          },
                          // Mengatur tampilan input seperti label, hint, dan border.
                          decoration: const InputDecoration(
                            // Menampilkan icon pada UI.
                            icon: Icon(
                              Icons.search,
                              size: 28,
                              color: Colors.black,
                            ),
                            hintText: 'Search',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Variabel ini menyimpan data yang dipakai oleh widget/function.
              const SizedBox(height: 24),

              // Membuat widget mengisi sisa ruang yang tersedia.
              Expanded(
                // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    24,
                    20,
                    20,
                  ),
                  // Mengatur dekorasi seperti warna, radius, shadow, atau border.
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8FFFB),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(38),
                      topRight: Radius.circular(38),
                    ),
                  ),
                  child: SingleChildScrollView(
                    // Menyusun widget secara vertikal dari atas ke bawah.
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        // Variabel ini menyimpan data yang dipakai oleh widget/function.
                        const Text(
                          'Recent',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        // Variabel ini menyimpan data yang dipakai oleh widget/function.
                        const SizedBox(height: 16),

                        // Percabangan untuk mengecek kondisi tertentu.
                        if (recentSearches.isEmpty)
                          // Variabel ini menyimpan data yang dipakai oleh widget/function.
                          const Padding(
                            padding:
                                EdgeInsets.only(bottom: 12),
                            // Menampilkan tulisan di layar.
                            child: Text(
                              'Belum ada pencarian',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          )
                        // Bagian ini dijalankan jika kondisi sebelumnya tidak terpenuhi.
                        else
                          // Menyusun widget secara vertikal dari atas ke bawah.
                          Column(
                            // Melakukan perulangan untuk mengolah banyak data.
                            children: recentSearches.map(
                              (item) {
                                // Mengembalikan hasil dari function/widget.
                                return _recentItem(item);
                              },
                            ).toList(),
                          ),

                        // Variabel ini menyimpan data yang dipakai oleh widget/function.
                        const SizedBox(height: 16),

                        // Widget untuk menampilkan data realtime dari stream.
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              // Mengarah ke collection Firestore yang digunakan.
                              .collection(
                                FirestoreCollections
                                    .scholarships,
                              )
                              // Mengurutkan data dari Firestore.
                              .orderBy(
                                'createdAt',
                                descending: true,
                              )
                              // Membaca data Firestore secara realtime.
                              .snapshots(),
                          builder: (context, snapshot) {
                            // Percabangan untuk mengecek kondisi tertentu.
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // Mengembalikan hasil dari function/widget.
                              return const Center(
                                // Memberi jarak bagian dalam di sekitar widget.
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(top: 30),
                                  child:
                                      // Menampilkan loading saat data sedang diproses.
                                      CircularProgressIndicator(),
                                ),
                              );
                            }

                            // Percabangan untuk mengecek kondisi tertentu.
                            if (snapshot.hasError) {
                              // Mengembalikan hasil dari function/widget.
                              return const Center(
                                // Menampilkan tulisan di layar.
                                child: Text(
                                  'Gagal mengambil data',
                                ),
                              );
                            }

                            // Percabangan untuk mengecek kondisi tertentu.
                            if (!snapshot.hasData ||
                                snapshot
                                    .data!.docs.isEmpty) {
                              // Mengembalikan hasil dari function/widget.
                              return const Center(
                                // Menampilkan tulisan di layar.
                                child: Text(
                                  'Belum ada data',
                                ),
                              );
                            }

                            // Variabel ini menyimpan data yang dipakai oleh widget/function.
                            final docs = snapshot
                                .data!.docs
                                // Memfilter data dari Firestore.
                                .where((doc) {
                              // Variabel ini menyimpan data yang dipakai oleh widget/function.
                              final data =
                                  doc.data()
                                      as Map<String, dynamic>;

                              // Variabel ini menyimpan data yang dipakai oleh widget/function.
                              final title =
                                  '${data['title'] ?? ''}'
                                      .toLowerCase();

                              // Variabel ini menyimpan data yang dipakai oleh widget/function.
                              final desc =
                                  '${data['desc'] ?? ''}'
                                      .toLowerCase();

                              // Variabel ini menyimpan data yang dipakai oleh widget/function.
                              final region =
                                  '${data['region'] ?? ''}'
                                      .toLowerCase();

                              // Percabangan untuk mengecek kondisi tertentu.
                              if (keyword.isEmpty) {
                                // Mengembalikan hasil dari function/widget.
                                return true;
                              }

                              // Mengembalikan hasil dari function/widget.
                              return title
                                      .contains(keyword) ||
                                  desc.contains(keyword) ||
                                  region
                                      .contains(keyword);
                            }).toList();

                            // Percabangan untuk mengecek kondisi tertentu.
                            if (docs.isEmpty) {
                              // Mengembalikan hasil dari function/widget.
                              return const Center(
                                // Menampilkan tulisan di layar.
                                child: Text(
                                  'Data tidak ditemukan',
                                ),
                              );
                            }

                            // Menyusun widget secara vertikal dari atas ke bawah.
                            return Column(
                              // Melakukan perulangan untuk mengolah banyak data.
                              children: docs.map((doc) {
                                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                                final item =
                                    doc.data()
                                        as Map<String, dynamic>;

                                // Widget tombol/klik untuk menjalankan aksi.
                                return GestureDetector(
                                  onTap: () =>
                                      openDetail(item),
                                  // Menumpuk widget di atas widget lain.
                                  child: Stack(
                                    children: [
                                      _searchCard({
                                        'title':
                                            '${item['title'] ?? ''}',
                                        'desc':
                                            '${item['desc'] ?? ''}',
                                        'detail':
                                            '${item['detail'] ?? ''}',
                                        'region':
                                            '${item['region'] ?? ''}',
                                        'imageUrl':
                                            '${item['imageUrl'] ?? ''}',
                                      }),

                                      // Percabangan untuk mengecek kondisi tertentu.
                                      if (widget.isAdmin)
                                        // Mengatur posisi widget di dalam Stack.
                                        Positioned(
                                          top: 10,
                                          right: 10,
                                          child: Material(
                                            color:
                                                Colors.white,
                                            shape:
                                                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                                                const CircleBorder(),
                                            elevation: 3,
                                            // Widget tombol/klik untuk menjalankan aksi.
                                            child: IconButton(
                                              onPressed: () =>
                                                  deleteData(
                                                doc.id,
                                              ),
                                              icon:
                                                  // Variabel ini menyimpan data yang dipakai oleh widget/function.
                                                  const Icon(
                                                Icons
                                                    .delete_rounded,
                                                color:
                                                    Colors.red,
                                                size: 22,
                                              ),
                                            ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _recentItem(String title) {
    // Memberi jarak bagian dalam di sekitar widget.
    return Padding(
      padding: const EdgeInsets.only(bottom: 19),
      // Menyusun widget secara horizontal dari kiri ke kanan.
      child: Row(
        children: [
          // Variabel ini menyimpan data yang dipakai oleh widget/function.
          const Icon(
            Icons.access_time_rounded,
            size: 24,
          ),

          // Variabel ini menyimpan data yang dipakai oleh widget/function.
          const SizedBox(width: 13),

          // Membuat widget mengisi sisa ruang yang tersedia.
          Expanded(
            // Widget tombol/klik untuk menjalankan aksi.
            child: GestureDetector(
              onTap: () => useRecentSearch(title),
              // Menampilkan tulisan di layar.
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),

          // Widget tombol/klik untuk menjalankan aksi.
          GestureDetector(
            onTap: () {
              // Memperbarui tampilan setelah data berubah.
              setState(() {
                recentSearches.remove(title);
              });
            },
            // Menampilkan icon pada UI.
            child: const Icon(
              Icons.close_rounded,
              size: 20,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchCard(Map<String, dynamic> item) {
    // Variabel ini menyimpan data yang dipakai oleh widget/function.
    final imageUrl = '${item['imageUrl'] ?? ''}';

    // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(10),
      // Mengatur dekorasi seperti warna, radius, shadow, atau border.
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.20),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      // Menyusun widget secara horizontal dari kiri ke kanan.
      child: Row(
        children: [
          // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
          Container(
            width: 70,
            height: 88,
            color: const Color(0xFFE8F5EC),
            child: imageUrl.isNotEmpty
                // Menampilkan gambar pada UI.
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) {
                      // Menampilkan icon pada UI.
                      return const Icon(
                        Icons.image_outlined,
                        size: 35,
                        color: Colors.black38,
                      );
                    },
                  )
                // Menampilkan icon pada UI.
                : const Icon(
                    Icons.image_outlined,
                    size: 35,
                    color: Colors.black38,
                  ),
          ),

          // Variabel ini menyimpan data yang dipakai oleh widget/function.
          const SizedBox(width: 10),

          // Membuat widget mengisi sisa ruang yang tersedia.
          Expanded(
            // Memberi jarak kosong atau ukuran tetap.
            child: SizedBox(
              height: 88,
              // Menyusun widget secara vertikal dari atas ke bawah.
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // Menampilkan tulisan di layar.
                  Text(
                    '${item['title'] ?? ''}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      decoration:
                          TextDecoration.underline,
                    ),
                  ),

                  // Variabel ini menyimpan data yang dipakai oleh widget/function.
                  const SizedBox(height: 6),

                  // Menampilkan tulisan di layar.
                  Text(
                    '${item['desc'] ?? ''}',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      height: 1.1,
                    ),
                  ),

                  // Variabel ini menyimpan data yang dipakai oleh widget/function.
                  const Spacer(),

                  Align(
                    alignment: Alignment.bottomRight,
                    child: widget.isAdmin
                        // Menampilkan icon pada UI.
                        ? const Icon(
                            Icons.admin_panel_settings,
                            size: 20,
                            color: Colors.red,
                          )
                        // Menampilkan icon pada UI.
                        : Icon(
                            Icons.bookmark,
                            size: 20,
                            color: Colors.yellow.shade600,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
