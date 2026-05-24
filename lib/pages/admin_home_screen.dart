import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/app_colors.dart';
import '../widgets/home_widgets.dart';

class AdminHomeScreen extends StatefulWidget {
  final VoidCallback? onSearchTap;

  const AdminHomeScreen({
    super.key,
    this.onSearchTap,
  });

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Kalsel',
    'Kaltim',
    'Kalteng',
    'Kalbar',
    'Kaltara',
  ];

  void openSearch() {
    widget.onSearchTap?.call();
  }

  List<QueryDocumentSnapshot> filterDocs(List<QueryDocumentSnapshot> docs) {
    if (selectedCategory == 'All') return docs;

    return docs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return '${data['region'] ?? ''}' == selectedCategory;
    }).toList();
  }

  Future<void> deleteData(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Data?'),
          content: const Text('Data beasiswa ini akan dihapus dari Firebase.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    await FirebaseFirestore.instance.collection('beasiswa').doc(id).delete();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data berhasil dihapus'),
      ),
    );
  }

  Widget emptyData(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 55),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.school_outlined,
              size: 70,
              color: Colors.green.shade300,
            ),
            const SizedBox(height: 14),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
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

  @override
  Widget build(BuildContext context) {
    return Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(
                onSearchTap: openSearch,
              ),

              const SizedBox(height: 20),

              const ScholarshipBanner(),

              const SizedBox(height: 20),

              SizedBox(
                height: 42,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final active = selectedCategory == category;

                    return Padding(
                      padding: const EdgeInsets.only(right: 27),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          height: 38,
                          alignment: Alignment.center,
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

              const SizedBox(height: 20),

              const Text(
                'Data Beasiswa',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 12),

              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('beasiswa')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return emptyData('Belum ada data beasiswa');
                  }

                  final docs = filterDocs(snapshot.data!.docs);

                  if (docs.isEmpty) {
                    return emptyData('Belum ada data di kategori ini');
                  }

                  return Column(
                    children: docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;

                      return Stack(
                        children: [
                          NewsCard(
                            title: '${data['title'] ?? ''}',
                            desc: '${data['desc'] ?? ''}',
                            imageUrl: '${data['imageUrl'] ?? ''}',
                            showBookmark: false,
                          ),

                          Positioned(
                            right: 8,
                            top: 8,
                            child: Material(
                              color: Colors.white,
                              shape: const CircleBorder(),
                              elevation: 3,
                              child: IconButton(
                                onPressed: () => deleteData(doc.id),
                                icon: const Icon(
                                  Icons.delete_rounded,
                                  color: Colors.red,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ],
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