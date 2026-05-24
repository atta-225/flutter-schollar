import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import 'home_screen.dart';
import 'saved_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int index = 0;
  bool showSearch = false;

  void changePage(int newIndex) {
    setState(() {
      index = newIndex;
      showSearch = false;
    });
  }

  void openSearch() {
    setState(() {
      showSearch = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentPage;

    if (showSearch) {
      currentPage = const SearchScreen(isAdmin: false);
    } else {
      currentPage = [
        HomeScreen(onSearchTap: openSearch),
        const SavedScreen(),
        const ProfileScreen(),
      ][index];
    }

    return Scaffold(
      body: currentPage,
      bottomNavigationBar: Container(
        height: 68,
        padding: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavItem(
              icon: Icons.home_rounded,
              active: !showSearch && index == 0,
              onTap: () => changePage(0),
            ),
            NavItem(
              icon: Icons.bookmark_rounded,
              active: !showSearch && index == 1,
              onTap: () => changePage(1),
            ),
            NavItem(
              icon: Icons.person_rounded,
              active: !showSearch && index == 2,
              onTap: () => changePage(2),
            ),
          ],
        ),
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: onTap,
      child: Container(
        width: 56,
        height: 48,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: active ? 34 : 30,
          color: active ? AppColors.primary : AppColors.primary2,
        ),
      ),
    );
  }
}