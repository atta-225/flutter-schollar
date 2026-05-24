import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/app_colors.dart';
import '../widgets/home_widgets.dart';
import 'detail_beasiswa_screen.dart';

class HomeScreen extends StatefulWidget {
final VoidCallback? onSearchTap;
  const HomeScreen({
    super.key,
     this.onSearchTap,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selected = 'All';

  final List<String> regions = [
    'All',
    'Kalsel',
    'Kaltim',
    'Kalteng',
    'Kalbar',
    'Kaltara',
  ];

  List<Map<String, String>> filterData(List<Map<String, String>> data) {
    if (selected == 'All') return data;
    return data.where((e) => e['region'] == selected).toList();
  }

 void openSearch() {
  widget.onSearchTap?.call();
}

  void openDetail(Map<String, String> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailBeasiswaScreen(
          title: item['title'] ?? '',
          desc: item['desc'] ?? '',
          detail: item['detail'] ?? '',
          region: item['region'] ?? '',
          imageUrl: item['imageUrl'] ?? '',
        ),
      ),
    );
  }

  Future<void> saveBeasiswa(Map<String, String> item) async {
    await FirebaseFirestore.instance.collection('saved_beasiswa').add({
      'title': item['title'] ?? '',
      'desc': item['desc'] ?? '',
      'detail': item['detail'] ?? '',
      'region': item['region'] ?? '',
      'imageUrl': item['imageUrl'] ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Beasiswa berhasil disimpan'),
        backgroundColor: Color(0xFF2F9D72),
      ),
    );
  }

  Widget emptyData() {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.school_outlined,
              size: 70,
              color: Colors.green.shade300,
            ),
            const SizedBox(height: 14),
            const Text(
              'Belum ada data beasiswa',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Silahkan tambahkan data dari admin',
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
                  itemCount: regions.length,
                  itemBuilder: (context, index) {
                    final r = regions[index];
                    final active = selected == r;

                    return Padding(
                      padding: const EdgeInsets.only(right: 27),
                      child: GestureDetector(
                        onTap: () => setState(() => selected = r),
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
                            r,
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
                'New',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 12),

              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('beasiswa')
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
                    return emptyData();
                  }

                  final data = snapshot.data!.docs.map((e) {
                    final m = e.data() as Map<String, dynamic>;

                    return {
                      'id': e.id,
                      'title': '${m['title'] ?? 'Judul Beasiswa'}',
                      'desc': '${m['desc'] ?? 'Deskripsi singkat'}',
                      'detail': '${m['detail'] ?? 'Belum ada detail'}',
                      'region': '${m['region'] ?? 'All'}',
                      'imageUrl': '${m['imageUrl'] ?? ''}',
                    };
                  }).toList();

                  final filtered = filterData(data);

                  if (filtered.isEmpty) {
                    return emptyData();
                  }

                  return Column(
                    children: filtered.map((item) {
                      return GestureDetector(
                        onTap: () => openDetail(item),
                        child: NewsCard(
                          title: item['title'] ?? '',
                          desc: item['desc'] ?? '',
                          imageUrl: item['imageUrl'] ?? '',
                          onBookmarkTap: () => saveBeasiswa(item),
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