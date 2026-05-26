import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool isLoading = false;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    usernameController.text =
        user?.displayName?.isNotEmpty == true ? user!.displayName! : 'User';
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> saveProfile() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (username.isEmpty) {
      showMessage('Username tidak boleh kosong', Colors.red);
      return;
    }

    if (password.isNotEmpty && password.length < 6) {
      showMessage('Password minimal 6 karakter', Colors.red);
      return;
    }

    if (password.isNotEmpty && password != confirmPassword) {
      showMessage('Password tidak sama', Colors.red);
      return;
    }

    try {
      setState(() => isLoading = true);

      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        showMessage('User belum login', Colors.red);
        return;
      }

      await currentUser.updateDisplayName(username);

      if (password.isNotEmpty) {
        await currentUser.updatePassword(password);
      }

      await currentUser.reload();

      if (!mounted) return;

      showMessage('Profile berhasil disimpan', const Color(0xFF176653));

      Navigator.pop(context, true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        showMessage(
          'Silakan logout lalu login ulang sebelum ganti password',
          Colors.red,
        );
      } else {
        showMessage(e.message ?? 'Gagal menyimpan profile', Colors.red);
      }
    } catch (e) {
      showMessage('Error: $e', Colors.red);
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void showMessage(String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final initial = usernameController.text.isNotEmpty
        ? usernameController.text[0].toUpperCase()
        : 'U';

    return Scaffold(
      backgroundColor: const Color(0xFFEFFFF6),
      body: Stack(
        children: [
          Container(
            height: 405,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF5F8B76),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(70),
                bottomRight: Radius.circular(70),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(25, 18, 25, 40),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.keyboard_backspace_rounded,
                        size: 31,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(12, 48, 12, 95),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 94,
                          height: 94,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: [
                                Color(0xFF5EF0B8),
                                Color(0xFFF2F6A8),
                              ],
                            ),
                          ),
                          child: Text(
                            initial,
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2E1748),
                            ),
                          ),
                        ),

                        const SizedBox(height: 34),

                        const Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(height: 22),

                        _label('Username'),
                        _input(
                          controller: usernameController,
                          hint: 'Username',
                        ),

                        const SizedBox(height: 14),

                        _label('New Password'),
                        _input(
                          controller: passwordController,
                          hint: 'Kosongkan jika tidak ingin ganti',
                          obscure: hidePassword,
                          suffix: IconButton(
                            onPressed: () {
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            },
                            icon: Icon(
                              hidePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 19,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        _label('Confirm New Password'),
                        _input(
                          controller: confirmPasswordController,
                          hint: 'Ulangi password baru',
                          obscure: hideConfirmPassword,
                          suffix: IconButton(
                            onPressed: () {
                              setState(() {
                                hideConfirmPassword = !hideConfirmPassword;
                              });
                            },
                            icon: Icon(
                              hideConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 19,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        SizedBox(
                          width: double.infinity,
                          height: 39,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : saveProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF176653),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                            child: Text(
                              isLoading ? 'Saving...' : 'Save',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 1, bottom: 7),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    Widget? suffix,
  }) {
    return SizedBox(
      height: 46,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 13,
            color: Colors.black54,
          ),
          suffixIcon: suffix,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: const BorderSide(
              color: Color(0xFFD5D5D5),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: const BorderSide(
              color: Color(0xFF176653),
              width: 1.3,
            ),
          ),
        ),
      ),
    );
  }
}