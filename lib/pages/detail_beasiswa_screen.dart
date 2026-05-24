import 'package:flutter/material.dart';

class DetailBeasiswaScreen extends StatelessWidget {
  final String title;
  final String desc;
  final String detail;
  final String region;
  final String imageUrl;

  const DetailBeasiswaScreen({
    super.key,
    required this.title,
    required this.desc,
    required this.detail,
    required this.region,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFFFF6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2F9D72),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Detail Beasiswa'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 130,
                width: 130,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.12),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.school_rounded,
                      size: 70,
                      color: Color(0xFF2F9D72),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFF2F9D72).withOpacity(.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                region,
                style: const TextStyle(
                  color: Color(0xFF2F9D72),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(height: 18),

            Text(
              desc,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 26),

            const Text(
              'Penjelasan Lengkap',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              detail,
              style: const TextStyle(
                fontSize: 15,
                height: 1.7,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}