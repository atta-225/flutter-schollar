import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFFFF6),

      body: Stack(
        children: [

          Container(
            height: 370,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF5F8B76),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(55),
                bottomRight: Radius.circular(55),
              ),
            ),
          ),

          SafeArea(
            child: Stack(
              children: [

                Positioned(
                  top: 5,
                  left: 5,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 28,
                      color: Colors.black,
                    ),
                  ),
                ),

                Center(
                  child: SingleChildScrollView(
                    child: Container(
                      width: 285,
                      padding: const EdgeInsets.fromLTRB(
                        12,
                        35,
                        12,
                        38,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          Image.asset(
                            'assets/images/logo.jpeg',
                            height: 85,
                          ),

                          const Text(
                            'Borneo Scholar',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF176653),
                            ),
                          ),

                          const SizedBox(height: 24),

                          const Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),

                          const SizedBox(height: 24),

                          _label('Username'),

                          _input(
                            hint: 'Enter your username',
                          ),

                          const SizedBox(height: 14),

                          _label('Password'),

                          _input(
                            hint: 'Enter password',
                            obscure: hidePassword,
                            suffix: IconButton(
                              icon: Icon(
                                hidePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 18,
                              ),
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 14),

                          _label('Confirm Password'),

                          _input(
                            hint: 'Confirm your password',
                            obscure: hideConfirmPassword,
                            suffix: IconButton(
                              icon: Icon(
                                hideConfirmPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 18,
                              ),
                              onPressed: () {
                                setState(() {
                                  hideConfirmPassword =
                                      !hideConfirmPassword;
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 24),

                          SizedBox(
                            width: double.infinity,
                            height: 36,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF176653),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22),
                                ),
                              ),
                              child: const Text(
                                'Save',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 50),

                          Container(
                            height: 18,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFFFF6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _input({
    required String hint,
    bool obscure = false,
    Widget? suffix,
  }) {
    return SizedBox(
      height: 42,
      child: TextField(
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
          suffixIcon: suffix,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          filled: true,
          fillColor: Colors.white,

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: const BorderSide(
              color: Color(0xFFD5D5D5),
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: const BorderSide(
              color: Color(0xFF176653),
            ),
          ),
        ),
      ),
    );
  }
}