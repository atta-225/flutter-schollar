import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/app_logo.dart';
import '../widgets/auth_widgets.dart';
import '../utils/app_colors.dart';
import '../utils/auth_helpers.dart';

import 'register_screen.dart';
import 'main_nav_screen.dart';
import 'admin_main_nav_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {
  // ================= CONTROLLER =================
  final emailC = TextEditingController();
  final passC = TextEditingController();

  // ================= VARIABLE =================
  bool rememberMe = false;
  bool hidePassword = true;
  bool loading = false;

  // ================= LOGIN =================
  Future<void> login() async {
    final email = emailC.text.trim();
    final password = passC.text.trim();

    // VALIDASI
    if (email.isEmpty ||
        password.isEmpty) {
      ScaffoldMessenger.of(context)
          .clearSnackBars();

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Email dan password wajib diisi.',
          ),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    setState(() => loading = true);

    try {
      // ================= FIREBASE LOGIN =================
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ================= USER =================
      final currentUser =
          FirebaseAuth.instance.currentUser;

      // ================= CEK ADMIN =================
      final isAdmin =
          await isAdminAccount(currentUser);

      // ================= SIMPAN USER =================
      if (currentUser != null) {
        await ensureFirestoreUserRecord(
          currentUser,
          role:
              isAdmin
                  ? 'admin'
                  : 'user',
        );
      }

      if (!mounted) return;

      // ================= PINDAH HALAMAN =================
      final nextPage =
          isAdmin
              ? const AdminMainNavScreen()
              : const MainNavScreen();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => nextPage,
        ),
      );
    }

    // ================= FIREBASE ERROR =================
    on FirebaseAuthException catch (e) {
      // ================= FALLBACK LOGIN =================
      if (e.code == 'user-not-found') {
        final fallback =
            await createAuthUserFromFirestore(
          email,
          password,
        );

        if (fallback) {
          if (!mounted) return;

          final currentUser =
              FirebaseAuth
                  .instance
                  .currentUser;

          final isAdmin =
              await isAdminAccount(
            currentUser,
          );

          if (!mounted) return;

          final nextPage =
              isAdmin
                  ? const AdminMainNavScreen()
                  : const MainNavScreen();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => nextPage,
            ),
          );

          return;
        }
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .clearSnackBars();

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content:
              Text(_errorMessage(e)),
          backgroundColor: Colors.red,
        ),
      );
    }

    // ================= ERROR UMUM =================
    catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .clearSnackBars();

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Terjadi kesalahan: ${e.toString()}',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }

    // ================= STOP LOADING =================
    if (mounted) {
      setState(() => loading = false);
    }
  }

  // ================= ERROR MESSAGE =================
  String _errorMessage(
    FirebaseAuthException e,
  ) {
    switch (e.code) {
      case 'invalid-email':
        return 'Format email tidak valid.';

      case 'user-disabled':
        return 'Akun telah dinonaktifkan.';

      case 'user-not-found':
        return 'Akun tidak ditemukan.';

      case 'wrong-password':
        return 'Password salah.';

      case 'too-many-requests':
        return 'Terlalu banyak percobaan login.';

      case 'invalid-credential':
        return 'Email atau password salah.';

      default:
        return e.message ??
            'Login gagal.';
    }
  }

  // ================= DISPOSE =================
  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: SingleChildScrollView(
        child: AuthCard(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 4,
            ),

            child: Column(
              children: [
                const SizedBox(height: 22),

                // ================= LOGO =================
                AppLogo(size: 105),

                Text(
                  'Borneo Scholar',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight:
                        FontWeight.w800,
                    color:
                        AppColors.primary,
                  ),
                ),

                const SizedBox(height: 12),

                // ================= TITLE =================
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 24),

                // ================= EMAIL =================
                const Align(
                  alignment:
                      Alignment.centerLeft,
                  child: Text(
                    'Username',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: emailC,
                  keyboardType:
                      TextInputType
                          .emailAddress,
                  decoration: inputStyle(
                    'Enter your Username',
                  ),
                ),

                const SizedBox(height: 14),

                // ================= PASSWORD =================
                const Align(
                  alignment:
                      Alignment.centerLeft,
                  child: Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: passC,
                  obscureText:
                      hidePassword,

                  decoration: inputStyle(
                    'Enter password',

                    suffix: IconButton(
                      icon: Icon(
                        hidePassword
                            ? Icons
                                .visibility_off_outlined
                            : Icons
                                .visibility_outlined,
                        size: 20,
                      ),

                      onPressed: () {
                        setState(() {
                          hidePassword =
                              !hidePassword;
                        });
                      },
                    ),
                  ),
                ),

                // ================= REMEMBER =================
                Row(
                  children: [
                    Transform.scale(
                      scale: 0.9,

                      child: Checkbox(
                        value: rememberMe,

                        visualDensity:
                            VisualDensity
                                .compact,

                        activeColor:
                            AppColors
                                .primary,

                        onChanged: (v) {
                          setState(() {
                            rememberMe =
                                v ?? false;
                          });
                        },
                      ),
                    ),

                    const Text(
                      'Remember Me',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            Colors.black54,
                      ),
                    ),

                    const Spacer(),

                    TextButton(
                      onPressed: () {},

                      child: const Text(
                        '',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors
                              .lightBlueAccent,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // ================= BUTTON LOGIN =================
                BigButton(
                  text: 'Login',
                  loading: loading,
                  onTap: login,
                ),

                const SizedBox(height: 18),

                // ================= REGISTER =================
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .center,

                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder:
                                (_) =>
                                    const RegisterScreen(),
                          ),
                        );
                      },

                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors
                              .lightBlueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}