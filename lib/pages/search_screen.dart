import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/home_widgets.dart';
import 'detail_beasiswa_screen.dart';

class SearchScreen extends StatefulWidget {
  final bool isAdmin;

  const SearchScreen({
    super.key,
    this.isAdmin = false,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  String keyword = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void openDetail(Map<String, dynamic> data) {
    if (widget.isAdmin) return;

    Navigator.push(
      context,
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

  Future<void> deleteData(String id) async {
    await FirebaseFirestore.instance.collection('beasiswa').doc(id).delete();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data berhasil dihapus'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEFFFF6),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF78CC8B),
              Color(0xFFEFFFF6),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 26, 24, 0),
            child: Column(
              children: [
                Container(
                  height: 52,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: searchController,
                    autofocus: true,
                    onChanged: (value) {
                      setState(() {
                        keyword = value.toLowerCase().trim();
                      });
                    },
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                    decoration: const InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(
                          left: 2,
                          top: 1,
                        ),
                        child: Icon(
                          Icons.search,
                          size: 26,
                          color: Colors.black,
                        ),
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 42,
                        minHeight: 42,
                      ),
                      hintText: 'search for info',
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                      border: InputBorder.none,
                      isCollapsed: true,
                      contentPadding: EdgeInsets.only(
                        top: 15,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('beasiswa')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (keyword.isEmpty) {
                        return const SizedBox();
                      }

                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text('Belum ada data beasiswa'),
                        );
                      }

                      final docs = snapshot.data!.docs.where((doc) {
                        final data = doc.data() as Map<String, dynamic>;

                        final title =
                            '${data['title'] ?? ''}'.toLowerCase();
                        final desc =
                            '${data['desc'] ?? ''}'.toLowerCase();
                        final region =
                            '${data['region'] ?? ''}'.toLowerCase();

                        return title.contains(keyword) ||
                            desc.contains(keyword) ||
                            region.contains(keyword);
                      }).toList();

                      if (docs.isEmpty) {
                        return const Center(
                          child: Text('Data tidak ditemukan'),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.only(bottom: 100),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final doc = docs[index];
                          final data = doc.data() as Map<String, dynamic>;

                          return GestureDetector(
                            onTap: () => openDetail(data),
                            child: Stack(
                              children: [
                                NewsCard(
                                  title: '${data['title'] ?? ''}',
                                  desc: '${data['desc'] ?? ''}',
                                  imageUrl: '${data['imageUrl'] ?? ''}',
                                  showBookmark: !widget.isAdmin,
                                ),
                                if (widget.isAdmin)
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
                            ),
                          );
                        },
                      );
                    },
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