// =============================================================
// PENJELASAN FILE: lib/pages/admin_add_news_screen.dart
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
import 'admin_main_nav_screen.dart';

// Class AdminAddNewsScreen adalah halaman tampilan pada aplikasi.
class AdminAddNewsScreen extends StatefulWidget {
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  const AdminAddNewsScreen({super.key});

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  State<AdminAddNewsScreen> createState() => _AdminAddNewsScreenState();
}

// Class _AdminAddNewsScreenState adalah halaman tampilan pada aplikasi.
class _AdminAddNewsScreenState extends State<AdminAddNewsScreen> {
  String? selectedCategory;
  bool isLoading = false;

  // Controller untuk membaca dan mengatur isi input text.
  final TextEditingController nameController = TextEditingController();
  // Controller untuk membaca dan mengatur isi input text.
  final TextEditingController informationController = TextEditingController();
  // Controller untuk membaca dan mengatur isi input text.
  final TextEditingController imageUrlController = TextEditingController();

  // List untuk menyimpan beberapa data yang akan ditampilkan.
  final List<String> categories = [
    'Kalsel',
    'Kalbar',
    'Kaltim',
    'Kalteng',
  ];

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  // Method ini membersihkan controller agar tidak boros memori.
  void dispose() {
    nameController.dispose();
    informationController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  // Function async untuk proses yang membutuhkan waktu, seperti Firebase.
  Future<void> addNews() async {
    // Variabel ini menyimpan data yang dipakai oleh widget/function.
    final title = nameController.text.trim();
    // Variabel ini menyimpan data yang dipakai oleh widget/function.
    final info = informationController.text.trim();
    // Variabel ini menyimpan data yang dipakai oleh widget/function.
    final imageUrl = imageUrlController.text.trim();

    // Percabangan untuk mengecek kondisi tertentu.
    if (selectedCategory == null || title.isEmpty || info.isEmpty) {
      // Menampilkan pesan singkat di bawah layar.
      ScaffoldMessenger.of(context).showSnackBar(
        // Variabel ini menyimpan data yang dipakai oleh widget/function.
        const SnackBar(content: Text('Lengkapi semua data terlebih dahulu')),
      );
      return;
    }

    // Memperbarui tampilan setelah data berubah.
    setState(() => isLoading = true);

    // Mencoba menjalankan proses yang mungkin gagal.
    try {
      // Mengarah ke collection Firestore yang digunakan.
      await FirebaseFirestore.instance.collection('beasiswa').add({
        'title': title,
        'desc': info,
        'detail': info,
        'region': selectedCategory,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });

      nameController.clear();
      informationController.clear();
      imageUrlController.clear();

      // Memperbarui tampilan setelah data berubah.
      setState(() {
        selectedCategory = null;
      });

      // Percabangan untuk mengecek kondisi tertentu.
      if (!mounted) return;

      // Menampilkan pesan singkat di bawah layar.
      ScaffoldMessenger.of(context).showSnackBar(
        // Variabel ini menyimpan data yang dipakai oleh widget/function.
        const SnackBar(content: Text('Data berhasil ditambahkan')),
      );
    // Menangkap error agar aplikasi tidak langsung berhenti.
    } catch (e) {
      // Percabangan untuk mengecek kondisi tertentu.
      if (!mounted) return;

      // Menampilkan pesan singkat di bawah layar.
      ScaffoldMessenger.of(context).showSnackBar(
        // Menampilkan tulisan di layar.
        SnackBar(content: Text('Gagal menambahkan data: $e')),
      );
    } finally {
      // Percabangan untuk mengecek kondisi tertentu.
      if (mounted) {
        // Memperbarui tampilan setelah data berubah.
        setState(() => isLoading = false);
      }
    }
  }

  Widget inputLabel(String text) {
    // Menampilkan tulisan di layar.
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w900,
        color: Colors.black,
      ),
    );
  }

  // Mengatur tampilan input seperti label, hint, dan border.
  InputDecoration inputDecoration(String hint) {
    // Mengatur tampilan input seperti label, hint, dan border.
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 11,
        color: Colors.black38,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 9,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(2),
        borderSide: const BorderSide(
          color: AppColors.primaryDark,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(2),
        borderSide: const BorderSide(
          color: AppColors.primaryDark,
          width: 1.3,
        ),
      ),
    );
  }

  Widget categoryItem(String category) {
    // Variabel ini menyimpan data yang dipakai oleh widget/function.
    final bool active = selectedCategory == category;

    // Widget tombol/klik untuk menjalankan aksi.
    return GestureDetector(
      onTap: () {
        // Memperbarui tampilan setelah data berubah.
        setState(() {
          selectedCategory = category;
        });
      },
      // Memberi jarak kosong atau ukuran tetap.
      child: SizedBox(
       width: double.infinity,
        // Menyusun widget secara horizontal dari kiri ke kanan.
        child: Row(
          children: [
            // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
            Container(
              width: 22,
              height: 22,
              // Mengatur dekorasi seperti warna, radius, shadow, atau border.
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primaryDark,
                  width: 2,
                ),
              ),
              child: active
                  ? Center(
                      // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
                      child: Container(
                        width: 10,
                        height: 10,
                        // Mengatur dekorasi seperti warna, radius, shadow, atau border.
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    )
                  : null,
            ),
            // Variabel ini menyimpan data yang dipakai oleh widget/function.
            const SizedBox(width: 6),
            // Menampilkan tulisan di layar.
            Text(
              category,
              style: const TextStyle(
                color: Color(0xFF198150),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget addPhotoBox() {
    // Widget tombol/klik untuk menjalankan aksi.
    return GestureDetector(
      onTap: () {
        // nanti bisa diganti fitur upload foto
      },
      // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
      child: Container(
        width: 90,
        height: 112,
        alignment: Alignment.center,
        // Mengatur dekorasi seperti warna, radius, shadow, atau border.
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
            color: AppColors.primaryDark,
            width: 1,
          ),
        ),
        // Menampilkan icon pada UI.
        child: const Icon(
          Icons.add_rounded,
          color: AppColors.yellow,
          size: 24,
        ),
      ),
    );
  }

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  // Method build dipakai Flutter untuk menggambar tampilan layar.
  Widget build(BuildContext context) {
    // Kerangka utama halaman Flutter.
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
              Color(0xFF52B989),
              Color(0xFFA9DFC8),
              Color(0xFFEFFFF6),
            ],
          ),
        ),
        // Menjaga UI agar tidak tertutup notch/status bar.
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 95),
            // Menyusun widget secara vertikal dari atas ke bawah.
            child: Column(
              children: [
                // Menyusun widget secara horizontal dari kiri ke kanan.
                Row(
                  children: [
                    // Widget tombol/klik untuk menjalankan aksi.
                    IconButton(
                     onPressed: () {
                      // Membuka halaman baru.
                      Navigator.pushAndRemoveUntil(
                        context,
                        // Menentukan halaman tujuan saat navigasi.
                        MaterialPageRoute(
                          builder: (_) => const AdminMainNavScreen(),
                        ),
                        (route) => false,
                      );
                    },
                      // Menampilkan icon pada UI.
                      icon: const Icon(
                        Icons.keyboard_backspace_rounded,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                    // Variabel ini menyimpan data yang dipakai oleh widget/function.
                    const SizedBox(width: 2),
                    // Variabel ini menyimpan data yang dipakai oleh widget/function.
                    const Text(
                      'Add News',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    // Variabel ini menyimpan data yang dipakai oleh widget/function.
                    const Spacer(),
                    // Widget tombol/klik untuk menjalankan aksi.
                    IconButton(
                      onPressed: () {},
                      // Menampilkan icon pada UI.
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const SizedBox(height: 6),

                // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
                  // Mengatur dekorasi seperti warna, radius, shadow, atau border.
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(19),
                  ),
                  // Menyusun widget secara vertikal dari atas ke bawah.
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      inputLabel('Category'),
                      // Variabel ini menyimpan data yang dipakai oleh widget/function.
                      const SizedBox(height: 14),

                     // Menampilkan daftar dalam bentuk grid.
                     GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: categories.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 30,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 12,
                        ),
                        itemBuilder: (context, index) {
                          // Mengembalikan hasil dari function/widget.
                          return categoryItem(categories[index]);
                        },
                      ),

                      // Variabel ini menyimpan data yang dipakai oleh widget/function.
                      const SizedBox(height: 26),

                      inputLabel('Add Name'),
                      // Variabel ini menyimpan data yang dipakai oleh widget/function.
                      const SizedBox(height: 10),

                      // Input text biasa dari user.
                      TextField(
                        controller: nameController,
                        decoration: inputDecoration('University Name'),
                      ),

                      // Variabel ini menyimpan data yang dipakai oleh widget/function.
                      const SizedBox(height: 14),

                      inputLabel('Add Photo'),
                      // Variabel ini menyimpan data yang dipakai oleh widget/function.
                      const SizedBox(height: 10),

                      addPhotoBox(),

                      // Variabel ini menyimpan data yang dipakai oleh widget/function.
                      const SizedBox(height: 24),

                      inputLabel('Add Information'),
                      // Variabel ini menyimpan data yang dipakai oleh widget/function.
                      const SizedBox(height: 12),

                      // Input text biasa dari user.
                      TextField(
                        controller: informationController,
                        maxLines: 6,
                        decoration: inputDecoration(''),
                      ),
                    ],
                  ),
                ),

                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const SizedBox(height: 46),

                Align(
                  alignment: Alignment.centerRight,
                  // Memberi jarak kosong atau ukuran tetap.
                  child: SizedBox(
                    width: 82,
                    height: 30,
                    // Widget tombol/klik untuk menjalankan aksi.
                    child: ElevatedButton(
                      onPressed: isLoading ? null : addNews,
                      // Widget tombol/klik untuk menjalankan aksi.
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: isLoading
                          // Memberi jarak kosong atau ukuran tetap.
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              // Menampilkan loading saat data sedang diproses.
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          // Menampilkan tulisan di layar.
                          : const Text(
                              'Add',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
