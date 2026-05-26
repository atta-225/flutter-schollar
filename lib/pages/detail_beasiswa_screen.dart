import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

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
      backgroundColor: AppColors.bg,

      body: Container(
        width: double.infinity,

        constraints: const BoxConstraints(
          minHeight: double.infinity,
        ),

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

        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              24,
              14,
              24,
              40,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                /// BACK BUTTON
                IconButton(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,

                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    size: 32,
                    color: Colors.black,
                  ),

                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),

                const SizedBox(height: 16),

                /// IMAGE
                Container(
                  width: double.infinity,
                  height: 315,

                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(24),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(28),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),

                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(24),

                    child: imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,

                            errorBuilder:
                                (
                                  context,
                                  error,
                                  stackTrace,
                                ) {

                              return Container(
                                color: Colors.white,

                                child: const Icon(
                                  Icons.school_rounded,
                                  size: 70,
                                  color: Color(0xFF2F9D72),
                                ),
                              );
                            },
                          )

                        : Container(
                            color:
                                Colors.white.withAlpha(180),

                            child: const Icon(
                              Icons.image_outlined,
                              size: 70,
                              color: Colors.black38,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 22),

                /// REGION
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),

                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(
                      47,
                      157,
                      114,
                      0.12,
                    ),

                    borderRadius:
                        BorderRadius.circular(30),
                  ),

                  child: Text(
                    region,

                    style: const TextStyle(
                      color: Color(0xFF2F9D72),
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                /// TITLE
                Text(
                  title,

                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 14),

                /// DESC
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(20),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(14),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Text(
                    desc,

                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// TITLE DETAIL
                const Text(
                  'Penjelasan Lengkap',

                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 12),

                /// DETAIL
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(22),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(14),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Text(
                    detail,
                    textAlign: TextAlign.left,

                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      height: 1.7,
                      color: Colors.black87,
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