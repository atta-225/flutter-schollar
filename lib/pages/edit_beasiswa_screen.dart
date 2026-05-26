// =============================================================
// PENJELASAN FILE: lib/pages/edit_beasiswa_screen.dart
// File ini sudah diberi komentar singkat agar mudah dipresentasikan.
// Komentar tidak mengubah fungsi kode, hanya menjelaskan kegunaannya.
// =============================================================

// Import package/file yang dibutuhkan oleh halaman ini.
import 'package:flutter/material.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import 'package:cloud_firestore/cloud_firestore.dart';

// Class EditBeasiswaScreen adalah halaman tampilan pada aplikasi.
class EditBeasiswaScreen extends StatefulWidget {
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final String docId;
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final String oldTitle;
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final String oldDesc;
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final String oldDetail;
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final String oldRegion;
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final String oldImageUrl;

  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  const EditBeasiswaScreen({
    super.key,
    required this.docId,
    required this.oldTitle,
    required this.oldDesc,
    required this.oldDetail,
    required this.oldRegion,
    required this.oldImageUrl,
  });

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  State<EditBeasiswaScreen> createState() => _EditBeasiswaScreenState();
}

// Class _EditBeasiswaScreenState adalah halaman tampilan pada aplikasi.
class _EditBeasiswaScreenState extends State<EditBeasiswaScreen> {
  late TextEditingController titleController;
  late TextEditingController detailController;

  String selectedRegion = 'Kalsel';
  bool isLoading = false;

  // List untuk menyimpan beberapa data yang akan ditampilkan.
  final List<String> regions = [
    'Kalsel',
    'Kalbar',
    'Kaltim',
    'Kalteng',
  ];

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  // Method ini berjalan pertama kali saat halaman dibuka.
  void initState() {
    super.initState();
    selectedRegion =
        widget.oldRegion.isEmpty ? 'Kalsel' : widget.oldRegion;

    titleController = TextEditingController(text: widget.oldTitle);
    detailController = TextEditingController(
      text: widget.oldDetail.isNotEmpty ? widget.oldDetail : widget.oldDesc,
    );
  }

  // Function async untuk proses yang membutuhkan waktu, seperti Firebase.
  Future<void> saveData() async {
    // Memperbarui tampilan setelah data berubah.
    setState(() => isLoading = true);

    // Menunggu proses async sampai selesai.
    await FirebaseFirestore.instance
        // Mengarah ke collection Firestore yang digunakan.
        .collection('beasiswa')
        // Mengarah ke document tertentu di Firestore.
        .doc(widget.docId)
        // Mengubah data yang sudah ada di Firestore.
        .update({
      'title': titleController.text.trim(),
      'desc': detailController.text.trim(),
      'detail': detailController.text.trim(),
      'region': selectedRegion,
      'imageUrl': widget.oldImageUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Percabangan untuk mengecek kondisi tertentu.
    if (!mounted) return;

    // Memperbarui tampilan setelah data berubah.
    setState(() => isLoading = false);
    // Kembali ke halaman sebelumnya.
    Navigator.pop(context);
  }

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  // Method build dipakai Flutter untuk menggambar tampilan layar.
  Widget build(BuildContext context) {
    // Kerangka utama halaman Flutter.
    return Scaffold(
      // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
      body: Container(
        width: double.infinity,
        // Mengatur dekorasi seperti warna, radius, shadow, atau border.
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4CAF88),
              Color(0xFFEFFFF6),
            ],
          ),
        ),
        // Menjaga UI agar tidak tertutup notch/status bar.
        child: SafeArea(
          // Menyusun widget secara vertikal dari atas ke bawah.
          child: Column(
            children: [
              // Memberi jarak bagian dalam di sekitar widget.
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
                // Menyusun widget secara horizontal dari kiri ke kanan.
                child: Row(
                  children: [
                    // Widget tombol/klik untuk menjalankan aksi.
                    GestureDetector(
                      // Kembali ke halaman sebelumnya.
                      onTap: () => Navigator.pop(context),
                      // Menampilkan icon pada UI.
                      child: const Icon(Icons.arrow_back, size: 28),
                    ),
                    // Variabel ini menyimpan data yang dipakai oleh widget/function.
                    const SizedBox(width: 18),
                    // Variabel ini menyimpan data yang dipakai oleh widget/function.
                    const Text(
                      'Edit News',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    // Variabel ini menyimpan data yang dipakai oleh widget/function.
                    const Spacer(),
                    // Variabel ini menyimpan data yang dipakai oleh widget/function.
                    const Icon(Icons.more_vert),
                  ],
                ),
              ),

              // Membuat widget mengisi sisa ruang yang tersedia.
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                  // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
                    // Mengatur dekorasi seperti warna, radius, shadow, atau border.
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    // Menyusun widget secara vertikal dari atas ke bawah.
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Variabel ini menyimpan data yang dipakai oleh widget/function.
                        const Text(
                          'Category',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        // Variabel ini menyimpan data yang dipakai oleh widget/function.
                        const SizedBox(height: 8),

                        Wrap(
                          spacing: 18,
                          runSpacing: 4,
                          // Melakukan perulangan untuk mengolah banyak data.
                          children: regions.map((region) {
                            // Memberi jarak kosong atau ukuran tetap.
                            return SizedBox(
                              width: 70,
                              // Menyusun widget secara horizontal dari kiri ke kanan.
                              child: Row(
                                children: [
                                  Radio<String>(
                                    value: region,
                                    groupValue: selectedRegion,
                                    activeColor: const Color(0xFF006B5F),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    onChanged: (value) {
                                      // Memperbarui tampilan setelah data berubah.
                                      setState(() {
                                        selectedRegion = value!;
                                      });
                                    },
                                  ),
                                  // Menampilkan tulisan di layar.
                                  Text(
                                    region,
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                        // Variabel ini menyimpan data yang dipakai oleh widget/function.
                        const SizedBox(height: 16),

                        // Variabel ini menyimpan data yang dipakai oleh widget/function.
                        const Text(
                          'Edit Name',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        // Variabel ini menyimpan data yang dipakai oleh widget/function.
                        const SizedBox(height: 8),

                        // Input text biasa dari user.
                        TextField(
                          controller: titleController,
                          // Mengatur tampilan input seperti label, hint, dan border.
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),

                        // Variabel ini menyimpan data yang dipakai oleh widget/function.
                        const SizedBox(height: 16),

                        // Variabel ini menyimpan data yang dipakai oleh widget/function.
                        const Text(
                          'Edit Photo',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        // Variabel ini menyimpan data yang dipakai oleh widget/function.
                        const SizedBox(height: 10),

                        // Memotong widget dengan sudut membulat.
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: widget.oldImageUrl.isNotEmpty
                              // Menampilkan gambar pada UI.
                              ? Image.network(
                                  widget.oldImageUrl,
                                  width: 82,
                                  height: 104,
                                  fit: BoxFit.cover,
                                )
                              // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
                              : Container(
                                  width: 82,
                                  height: 104,
                                  color: const Color(0xFFFFE9A6),
                                  // Menampilkan icon pada UI.
                                  child: const Icon(
                                    Icons.school,
                                    color: Color(0xFF006B5F),
                                    size: 42,
                                  ),
                                ),
                        ),

                        // Variabel ini menyimpan data yang dipakai oleh widget/function.
                        const SizedBox(height: 22),

                        // Variabel ini menyimpan data yang dipakai oleh widget/function.
                        const Text(
                          'Edit Information',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        // Variabel ini menyimpan data yang dipakai oleh widget/function.
                        const SizedBox(height: 8),

                        // Input text biasa dari user.
                        TextField(
                          controller: detailController,
                          maxLines: 6,
                          // Mengatur tampilan input seperti label, hint, dan border.
                          decoration: const InputDecoration(
                            alignLabelWithHint: true,
                            contentPadding: EdgeInsets.all(8),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Memberi jarak bagian dalam di sekitar widget.
              Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 22),
                child: Align(
                  alignment: Alignment.centerRight,
                  // Widget tombol/klik untuk menjalankan aksi.
                  child: ElevatedButton(
                    onPressed: isLoading ? null : saveData,
                    // Widget tombol/klik untuk menjalankan aksi.
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B6B52),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    // Menampilkan tulisan di layar.
                    child: Text(isLoading ? 'saving...' : 'save'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
