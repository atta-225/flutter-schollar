import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/app_logo.dart';
import '../widgets/auth_widgets.dart';
import '../utils/app_colors.dart';
import '../utils/auth_helpers.dart';
import 'main_nav_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final confirmC = TextEditingController();

  bool hide1 = true;
  bool hide2 = true;
  bool loading = false;

  Future<void> register() async {
    final email = emailC.text.trim();
    final password = passC.text.trim();
    final confirmPassword = confirmC.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua field wajib diisi.'),
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password tidak sama.'),
        ),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final currentUser = credential.user;

      if (currentUser != null) {
        await createFirestoreUserFromAuth(
          currentUser,
          role: 'user',
        );
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MainNavScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).clearSnackBars();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage(e)),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).clearSnackBars();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Terjadi kesalahan: ${e.runtimeType}: ${e.toString()}',
          ),
        ),
      );
    }

    if (mounted) {
      setState(() => loading = false);
    }
  }

  String _errorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Format email tidak valid.';

      case 'email-already-in-use':
        return 'Email sudah digunakan.';

      case 'weak-password':
        return 'Password terlalu lemah.';

      case 'operation-not-allowed':
        return 'Pendaftaran belum diaktifkan.';

      default:
        return e.message ?? 'Pendaftaran gagal: ${e.code}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: SingleChildScrollView(
        child: AuthCard(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              children: [
                const SizedBox(height: 20),

                const AppLogo(size: 100),

                Text(
                  'Borneo Scholar',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const Text(
                  'Sign up and start your scholarship journey today',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 22),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Username',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: emailC,
                  keyboardType: TextInputType.emailAddress,
                  decoration: inputStyle(
                    'Enter your Username',
                  ),
                ),

                const SizedBox(height: 14),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: passC,
                  obscureText: hide1,
                  decoration: inputStyle(
                    'Enter password',
                    suffix: IconButton(
                      icon: Icon(
                        hide1
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() => hide1 = !hide1);
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Confirm Password',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: confirmC,
                  obscureText: hide2,
                  decoration: inputStyle(
                    'Confirm your password',
                    suffix: IconButton(
                      icon: Icon(
                        hide2
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() => hide2 = !hide2);
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                BigButton(
                  text: 'Register',
                  loading: loading,
                  onTap: register,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}