import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'pages/main_nav_screen.dart';
import 'pages/admin_main_nav_screen.dart';
import 'utils/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const BorneoScholarApp());
}

class BorneoScholarApp extends StatelessWidget {
  const BorneoScholarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Borneo Scholar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ),
      ),
      home: const MainNavScreen(),
      routes: {
        '/user': (_) => const MainNavScreen(),
        '/admin': (_) => const AdminMainNavScreen(),
      },
    );
  }
}
