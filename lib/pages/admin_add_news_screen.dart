import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/app_colors.dart';
import '../pages/admin_main_nav_screen.dart';

class AdminAddNewsScreen extends StatefulWidget {
  const AdminAddNewsScreen({super.key});

  @override
  State<AdminAddNewsScreen> createState() => _AdminAddNewsScreenState();
}

class _AdminAddNewsScreenState extends State<AdminAddNewsScreen> {
  String? selectedCategory;
  bool isLoading = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController shortInfoController = TextEditingController();
  final TextEditingController detailController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  final List<String> categories = [
    'Kalsel',
    'Kalbar',
    'Kaltim',
    'Kalteng',
    'Kaltara',
  ];

  @override
  void dispose() {
    nameController.dispose();
    shortInfoController.dispose();
    detailController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  Future<void> addNews() async {
    final title = nameController.text.trim();
    final desc = shortInfoController.text.trim();
    final detail = detailController.text.trim();
    final imageUrl = imageUrlController.text.trim();

    if (selectedCategory == null || title.isEmpty || desc.isEmpty || detail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lengkapi kategori, nama, deskripsi, dan detail.'),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('beasiswa').add({
        'title': title,
        'desc': desc,
        'detail': detail,
        'region': selectedCategory,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });

      nameController.clear();
      shortInfoController.clear();
      detailController.clear();
      imageUrlController.clear();
      setState(() => selectedCategory = null);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil ditambahkan')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan data: $e')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Widget inputLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 11, color: Colors.black45),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(
          color: AppColors.primaryDark,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(
          color: AppColors.primaryDark,
          width: 1.4,
        ),
      ),
    );
  }

  Widget categoryItem(String category) {
    final active = selectedCategory == category;

    return GestureDetector(
      onTap: () => setState(() => selectedCategory = category),
      child: SizedBox(
        width: 86,
        child: Row(
          children: [
            Container(
              width: 21,
              height: 21,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primaryDark,
                  width: 2,
                ),
              ),
              child: active
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 6),
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

  Widget addPhotoBox({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.primaryDark, width: 1),
      ),
      child: const Icon(
        Icons.add_rounded,
        color: AppColors.yellow,
        size: 25,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 100),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AdminMainNavScreen(),
                          ),
                        );
                      },

                      icon: const Icon(
                        Icons.keyboard_backspace_rounded,
                        size: 29,
                      ),
                    ),

                    const SizedBox(width: 8),

                    const Text(
                      'Add Beasiswa',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_vert_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 1.05),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.05),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      inputLabel('Category'),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 12,
                        children: categories.map(categoryItem).toList(),
                      ),
                      const SizedBox(height: 25),
                      inputLabel('Add Name'),
                      const SizedBox(height: 12),
                      TextField(
                        controller: nameController,
                        decoration: inputDecoration('University Name'),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: addPhotoBox(
                              width: double.infinity,
                              height: 104,
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            flex: 1,
                            child: addPhotoBox(
                              width: double.infinity,
                              height: 104,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      inputLabel('Short Information'),
                      const SizedBox(height: 12),

                      TextField(
                        controller: shortInfoController,
                        maxLines: 3,
                        decoration: inputDecoration('Deskripsi singkat untuk card user'),
                      ),
                      const SizedBox(height: 22),

                      inputLabel('Add Information'),

                      const SizedBox(height: 12),

                      TextField(
                        controller: detailController,
                        maxLines: 6,
                        decoration: inputDecoration('Penjelasan lengkap beasiswa'),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 17),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 96,
                    height: 34,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : addNews,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 17,
                              width: 17,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Add',
                              style: TextStyle(
                                fontSize: 12,
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
