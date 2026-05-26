import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/app_colors.dart';
import '../utils/auth_helpers.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback onSearchTap;

  const HomeHeader({super.key, required this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary2,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFFC9FF98),
                child: Text(
                  getDisplayInitial(FirebaseAuth.instance.currentUser),
                  style: const TextStyle(
                    fontSize: 26,
                    color: Color(0xFF00606E),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, ${getDisplayName(FirebaseAuth.instance.currentUser)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Sudah memikirkan apa yg ingin kamu\ncapai dimasa depan?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: onSearchTap,
            child: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.black, size: 28),
                  SizedBox(width: 10),
                  Text(
                    'search for info',
                    style: TextStyle(fontSize: 13, color: Colors.black54),
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

class ScholarshipBanner extends StatefulWidget {
  const ScholarshipBanner({super.key});

  @override
  State<ScholarshipBanner> createState() => _ScholarshipBannerState();
}

class _ScholarshipBannerState extends State<ScholarshipBanner> {
  late final PageController controller;

  final List<String> banners = const [
    'assets/images/banner_1.jpeg',
    'assets/images/banner_2.jpeg',
    'assets/images/banner_3.jpeg',
  ];

  int currentPage = 1000;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: currentPage);
    autoSlide();
  }

  void autoSlide() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 3));

      if (!mounted) return;

      currentPage++;

      controller.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 128,
      width: double.infinity,
      child: PageView.builder(
        controller: controller,
        onPageChanged: (index) {
          currentPage = index;
        },
        itemBuilder: (context, index) {
          final banner = banners[index % banners.length];

          return ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Image.asset(
              banner,
              width: double.infinity,
              height: 128,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          );
        },
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final String title;
  final String desc;
  final String imageUrl;
  final bool showBookmark;
  final VoidCallback? onBookmarkTap;

  const NewsCard({
    super.key,
    required this.title,
    required this.desc,
    required this.imageUrl,
    this.showBookmark = true,
    this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 102,
                width: 102,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE8A3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.school_rounded,
                              color: Color(0xFF006B5F),
                              size: 48,
                            );
                          },
                        ),
                      )
                    : const Icon(
                        Icons.school_rounded,
                        color: Color(0xFF006B5F),
                        size: 48,
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: showBookmark ? 28 : 0,
                    bottom: showBookmark ? 22 : 0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          decoration: TextDecoration.underline,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        desc,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (showBookmark)
            Positioned(
              right: 2,
              bottom: 2,
              child: GestureDetector(
                onTap: onBookmarkTap,
                child: const Icon(
                  Icons.bookmark,
                  color: Color(0xFFFFD23F),
                  size: 26,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
