import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/app_colors.dart';
import '../utils/auth_helpers.dart';
import '../widgets/app_logo.dart';
import '../widgets/profile_widgets.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';
import 'admin_main_nav_screen.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  void _goToEditProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const EditProfileScreen(),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),

          title: const Text(
            'Want to Logout?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          actionsAlignment: MainAxisAlignment.center,

          actions: [

            /// CANCEL
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(105, 45),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

              onPressed: () {
                Navigator.pop(context, false);
              },

              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            /// LOGOUT
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEB3B00),
                foregroundColor: Colors.white,
                minimumSize: const Size(105, 45),
                elevation: 0,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),

                  side: const BorderSide(
                    color: Color(0xFFD9D9D9),
                    width: 2,
                  ),
                ),
              ),

              onPressed: () {
                Navigator.pop(context, true);
              },

              child: const Text(
                'Logout',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (result == true) {

      /// BACKEND LOGOUT FIREBASE
      await FirebaseAuth.instance.signOut();

      if (!context.mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.bg,

      body: Stack(
        children: [

          /// TOP BACKGROUND
          Container(
            height: 400,
            width: double.infinity,

            decoration: const BoxDecoration(
              color: Color(0xFF5C8973),

              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(70),
                bottomRight: Radius.circular(70),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  22,
                  20,
                  22,
                  100,
                ),

                child: Column(
                  children: [

                    /// BACK BUTTON
                    Align(
                      alignment: Alignment.centerLeft,

                      child: IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const AdminMainNavScreen(),
                            ),
                          );
                        },

                        icon: const Icon(
                          Icons.keyboard_backspace_rounded,
                          size: 29,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// PHOTO PROFILE
                    CircleAvatar(
                      radius: 47,
                      backgroundColor: const Color(0xFF9CFF9B),

                      child: Text(
                        getDisplayInitial(user),

                        style: const TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2E1748),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    /// USER NAME
                    Text(
                      getDisplayName(user),

                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 22),

                    /// LOGO
                    const AppLogo(size: 65),

                    const SizedBox(height: 16),

                    /// MENU CARD
                    Container(
                      width: 298,

                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 20,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius: BorderRadius.circular(15),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(56),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),

                      child: Column(
                        children: [

                          /// EDIT PROFILE
                          ProfileMenu(
                            icon: Icons.account_circle_outlined,
                            title: 'Edit Profile',
                            onTap: () =>
                                _goToEditProfile(context),
                          ),

                          const Divider(height: 18),

                          /// LOGOUT
                          ProfileMenu(
                            icon: Icons.logout_rounded,
                            title: 'Logout',
                            onTap: () =>
                                _logout(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}