import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/app_colors.dart';
import 'admin_main_nav_screen.dart';

class AdminAddNewsScreen extends StatefulWidget {
  const AdminAddNewsScreen({super.key});

  @override
  State<AdminAddNewsScreen> createState() => _AdminAddNewsScreenState();
}

class _AdminAddNewsScreenState extends State<AdminAddNewsScreen> {
  String? selectedCategory;
  bool isLoading = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController informationController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  final List<String> categories = [
    'Kalsel',
    'Kalbar',
    'Kaltim',
    'Kalteng',
  ];

  @override
  void dispose() {
    nameController.dispose();
    informationController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  Future<void> addNews() async {
    final title = nameController.text.trim();
    final info = informationController.text.trim();
    final imageUrl = imageUrlController.text.trim();

    if (selectedCategory == null || title.isEmpty || info.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua data terlebih dahulu')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
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

      setState(() {
        selectedCategory = null;
      });

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
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Widget inputLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w900,
        color: Colors.black,
      ),
    );
  }

  InputDecoration inputDecoration(String hint) {
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
    final bool active = selectedCategory == category;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: SizedBox(
       width: double.infinity,
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
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

  Widget addPhotoBox() {
    return GestureDetector(
      onTap: () {
        // nanti bisa diganti fitur upload foto
      },
      child: Container(
        width: 90,
        height: 112,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
            color: AppColors.primaryDark,
            width: 1,
          ),
        ),
        child: const Icon(
          Icons.add_rounded,
          color: AppColors.yellow,
          size: 24,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 95),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                     onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminMainNavScreen(),
                        ),
                        (route) => false,
                      );
                    },
                      icon: const Icon(
                        Icons.keyboard_backspace_rounded,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Text(
                      'Add News',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(19),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      inputLabel('Category'),
                      const SizedBox(height: 14),

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
                          return categoryItem(categories[index]);
                        },
                      ),

                      const SizedBox(height: 26),

                      inputLabel('Add Name'),
                      const SizedBox(height: 10),

                      TextField(
                        controller: nameController,
                        decoration: inputDecoration('University Name'),
                      ),

                      const SizedBox(height: 14),

                      inputLabel('Add Photo'),
                      const SizedBox(height: 10),

                      addPhotoBox(),

                      const SizedBox(height: 24),

                      inputLabel('Add Information'),
                      const SizedBox(height: 12),

                      TextField(
                        controller: informationController,
                        maxLines: 6,
                        decoration: inputDecoration(''),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 46),

                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 82,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : addNews,
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
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
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