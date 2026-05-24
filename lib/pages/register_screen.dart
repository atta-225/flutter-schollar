import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/app_logo.dart';
import '../widgets/auth_widgets.dart';
import '../utils/app_colors.dart';
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
    if (passC.text.trim() != confirmC.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password tidak sama.')),
      );
      return;
    }

    setState(() => loading = true);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailC.text.trim(),
        password: passC.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Daftar gagal')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }

    if (mounted) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: SingleChildScrollView(
        child: AuthCard(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              children: [
                SizedBox(height: 20),

                AppLogo(size: 100),

                Text(
                  'Borneo Scholar',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                Text(
                  'Sign up and start your scholarship journey today',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),

                SizedBox(height: 22),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Username',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                SizedBox(height: 8),

                TextField(
                  controller: emailC,
                  keyboardType: TextInputType.emailAddress,
                  decoration: inputStyle('Enter your Username'),
                ),

                SizedBox(height: 14),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                SizedBox(height: 8),

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

                SizedBox(height: 14),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Confirm Password',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                SizedBox(height: 8),

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

                SizedBox(height: 28),

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