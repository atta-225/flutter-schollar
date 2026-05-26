// =============================================================
// PENJELASAN FILE: lib/pages/login_screen.dart
// File ini sudah diberi komentar singkat agar mudah dipresentasikan.
// Komentar tidak mengubah fungsi kode, hanya menjelaskan kegunaannya.
// =============================================================

// Import package/file yang dibutuhkan oleh halaman ini.
import 'package:flutter/material.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import 'package:firebase_auth/firebase_auth.dart';

// Import package/file yang dibutuhkan oleh halaman ini.
import '../widgets/app_logo.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import '../widgets/auth_widgets.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import '../utils/app_colors.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import '../utils/auth_helpers.dart';

// Import package/file yang dibutuhkan oleh halaman ini.
import 'register_screen.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import 'main_nav_screen.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import 'admin_main_nav_screen.dart';

// Class LoginScreen adalah halaman tampilan pada aplikasi.
class LoginScreen extends StatefulWidget {
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  const LoginScreen({super.key});

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

// Class _LoginScreenState adalah halaman tampilan pada aplikasi.
class _LoginScreenState
    extends State<LoginScreen> {
  // ================= CONTROLLER =================
  // Controller untuk membaca dan mengatur isi input text.
  final emailC = TextEditingController();
  // Controller untuk membaca dan mengatur isi input text.
  final passC = TextEditingController();

  // ================= VARIABLE =================
  bool rememberMe = false;
  bool hidePassword = true;
  bool loading = false;

  // ================= LOGIN =================
  // Function async untuk proses yang membutuhkan waktu, seperti Firebase.
  Future<void> login() async {
    // Variabel ini menyimpan data yang dipakai oleh widget/function.
    final email = emailC.text.trim();
    // Variabel ini menyimpan data yang dipakai oleh widget/function.
    final password = passC.text.trim();

    // VALIDASI
    // Percabangan untuk mengecek kondisi tertentu.
    if (email.isEmpty ||
        password.isEmpty) {
      ScaffoldMessenger.of(context)
          // Menampilkan pesan singkat di bawah layar.
          .clearSnackBars();

      ScaffoldMessenger.of(context)
          // Menampilkan pesan singkat di bawah layar.
          .showSnackBar(
        // Variabel ini menyimpan data yang dipakai oleh widget/function.
        const SnackBar(
          // Menampilkan tulisan di layar.
          content: Text(
            'Email dan password wajib diisi.',
          ),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    // Memperbarui tampilan setelah data berubah.
    setState(() => loading = true);

    // Mencoba menjalankan proses yang mungkin gagal.
    try {
      // ================= FIREBASE LOGIN =================
      // Mengakses fitur autentikasi Firebase.
      await FirebaseAuth.instance
          // Melakukan login menggunakan email dan password.
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ================= USER =================
      // Variabel ini menyimpan data yang dipakai oleh widget/function.
      final currentUser =
          // Mengakses fitur autentikasi Firebase.
          FirebaseAuth.instance.currentUser;

      // ================= CEK ADMIN =================
      // Variabel ini menyimpan data yang dipakai oleh widget/function.
      final isAdmin =
          // Menunggu proses async sampai selesai.
          await isAdminAccount(currentUser);

      // ================= SIMPAN USER =================
      // Percabangan untuk mengecek kondisi tertentu.
      if (currentUser != null) {
        // Menunggu proses async sampai selesai.
        await ensureFirestoreUserRecord(
          currentUser,
          role:
              isAdmin
                  ? 'admin'
                  : 'user',
        );
      }

      // Percabangan untuk mengecek kondisi tertentu.
      if (!mounted) return;

      // ================= PINDAH HALAMAN =================
      // Variabel ini menyimpan data yang dipakai oleh widget/function.
      final nextPage =
          isAdmin
              ? const AdminMainNavScreen()
              : const MainNavScreen();

      // Membuka halaman baru.
      Navigator.pushReplacement(
        context,
        // Menentukan halaman tujuan saat navigasi.
        MaterialPageRoute(
          builder: (_) => nextPage,
        ),
      );
    }

    // ================= FIREBASE ERROR =================
    // Menangkap error agar aplikasi tidak langsung berhenti.
    on FirebaseAuthException catch (e) {
      // ================= FALLBACK LOGIN =================
      // Percabangan untuk mengecek kondisi tertentu.
      if (e.code == 'user-not-found') {
        // Variabel ini menyimpan data yang dipakai oleh widget/function.
        final fallback =
            // Menunggu proses async sampai selesai.
            await createAuthUserFromFirestore(
          email,
          password,
        );

        // Percabangan untuk mengecek kondisi tertentu.
        if (fallback) {
          // Percabangan untuk mengecek kondisi tertentu.
          if (!mounted) return;

          // Variabel ini menyimpan data yang dipakai oleh widget/function.
          final currentUser =
              FirebaseAuth
                  .instance
                  .currentUser;

          // Variabel ini menyimpan data yang dipakai oleh widget/function.
          final isAdmin =
              // Menunggu proses async sampai selesai.
              await isAdminAccount(
            currentUser,
          );

          // Percabangan untuk mengecek kondisi tertentu.
          if (!mounted) return;

          // Variabel ini menyimpan data yang dipakai oleh widget/function.
          final nextPage =
              isAdmin
                  ? const AdminMainNavScreen()
                  : const MainNavScreen();

          // Membuka halaman baru.
          Navigator.pushReplacement(
            context,
            // Menentukan halaman tujuan saat navigasi.
            MaterialPageRoute(
              builder: (_) => nextPage,
            ),
          );

          return;
        }
      }

      // Percabangan untuk mengecek kondisi tertentu.
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          // Menampilkan pesan singkat di bawah layar.
          .clearSnackBars();

      ScaffoldMessenger.of(context)
          // Menampilkan pesan singkat di bawah layar.
          .showSnackBar(
        // Menampilkan pesan singkat di bawah layar.
        SnackBar(
          content:
              // Menampilkan tulisan di layar.
              Text(_errorMessage(e)),
          backgroundColor: Colors.red,
        ),
      );
    }

    // ================= ERROR UMUM =================
    // Menangkap error agar aplikasi tidak langsung berhenti.
    catch (e) {
      // Percabangan untuk mengecek kondisi tertentu.
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          // Menampilkan pesan singkat di bawah layar.
          .clearSnackBars();

      ScaffoldMessenger.of(context)
          // Menampilkan pesan singkat di bawah layar.
          .showSnackBar(
        // Menampilkan pesan singkat di bawah layar.
        SnackBar(
          // Menampilkan tulisan di layar.
          content: Text(
            'Terjadi kesalahan: ${e.toString()}',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }

    // ================= STOP LOADING =================
    // Percabangan untuk mengecek kondisi tertentu.
    if (mounted) {
      // Memperbarui tampilan setelah data berubah.
      setState(() => loading = false);
    }
  }

  // ================= ERROR MESSAGE =================
  String _errorMessage(
    FirebaseAuthException e,
  ) {
    switch (e.code) {
      case 'invalid-email':
        // Mengembalikan hasil dari function/widget.
        return 'Format email tidak valid.';

      case 'user-disabled':
        // Mengembalikan hasil dari function/widget.
        return 'Akun telah dinonaktifkan.';

      case 'user-not-found':
        // Mengembalikan hasil dari function/widget.
        return 'Akun tidak ditemukan.';

      case 'wrong-password':
        // Mengembalikan hasil dari function/widget.
        return 'Password salah.';

      case 'too-many-requests':
        // Mengembalikan hasil dari function/widget.
        return 'Terlalu banyak percobaan login.';

      case 'invalid-credential':
        // Mengembalikan hasil dari function/widget.
        return 'Email atau password salah.';

      default:
        // Mengembalikan hasil dari function/widget.
        return e.message ??
            'Login gagal.';
    }
  }

  // ================= DISPOSE =================
  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  // Method ini membersihkan controller agar tidak boros memori.
  void dispose() {
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }

  // ================= UI =================
  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  // Method build dipakai Flutter untuk menggambar tampilan layar.
  Widget build(BuildContext context) {
    // Mengembalikan hasil dari function/widget.
    return AuthBackground(
      child: SingleChildScrollView(
        child: AuthCard(
          // Memberi jarak bagian dalam di sekitar widget.
          child: Padding(
            padding:
                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const EdgeInsets.symmetric(
              horizontal: 4,
            ),

            // Menyusun widget secara vertikal dari atas ke bawah.
            child: Column(
              children: [
                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const SizedBox(height: 22),

                // ================= LOGO =================
                AppLogo(size: 105),

                // Menampilkan tulisan di layar.
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

                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const SizedBox(height: 12),

                // ================= TITLE =================
                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),

                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const SizedBox(height: 24),

                // ================= EMAIL =================
                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const Align(
                  alignment:
                      Alignment.centerLeft,
                  // Menampilkan tulisan di layar.
                  child: Text(
                    'Username',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),

                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const SizedBox(height: 8),

                // Input text biasa dari user.
                TextField(
                  controller: emailC,
                  keyboardType:
                      TextInputType
                          .emailAddress,
                  decoration: inputStyle(
                    'Enter your Username',
                  ),
                ),

                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const SizedBox(height: 14),

                // ================= PASSWORD =================
                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const Align(
                  alignment:
                      Alignment.centerLeft,
                  // Menampilkan tulisan di layar.
                  child: Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),

                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const SizedBox(height: 8),

                // Input text biasa dari user.
                TextField(
                  controller: passC,
                  obscureText:
                      hidePassword,

                  decoration: inputStyle(
                    'Enter password',

                    // Widget tombol/klik untuk menjalankan aksi.
                    suffix: IconButton(
                      // Menampilkan icon pada UI.
                      icon: Icon(
                        hidePassword
                            ? Icons
                                .visibility_off_outlined
                            : Icons
                                .visibility_outlined,
                        size: 20,
                      ),

                      onPressed: () {
                        // Memperbarui tampilan setelah data berubah.
                        setState(() {
                          hidePassword =
                              !hidePassword;
                        });
                      },
                    ),
                  ),
                ),

                // ================= REMEMBER =================
                // Menyusun widget secara horizontal dari kiri ke kanan.
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
                          // Memperbarui tampilan setelah data berubah.
                          setState(() {
                            rememberMe =
                                v ?? false;
                          });
                        },
                      ),
                    ),

                    // Variabel ini menyimpan data yang dipakai oleh widget/function.
                    const Text(
                      'Remember Me',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            Colors.black54,
                      ),
                    ),

                    // Variabel ini menyimpan data yang dipakai oleh widget/function.
                    const Spacer(),

                    // Widget tombol/klik untuk menjalankan aksi.
                    TextButton(
                      onPressed: () {},

                      // Menampilkan tulisan di layar.
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

                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const SizedBox(height: 8),

                // ================= BUTTON LOGIN =================
                BigButton(
                  text: 'Login',
                  loading: loading,
                  onTap: login,
                ),

                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const SizedBox(height: 18),

                // ================= REGISTER =================
                // Menyusun widget secara horizontal dari kiri ke kanan.
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .center,

                  children: [
                    // Variabel ini menyimpan data yang dipakai oleh widget/function.
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),

                    // Widget tombol/klik untuk menjalankan aksi.
                    GestureDetector(
                      onTap: () {
                        // Membuka halaman baru.
                        Navigator.push(
                          context,

                          // Menentukan halaman tujuan saat navigasi.
                          MaterialPageRoute(
                            builder:
                                (_) =>
                                    // Variabel ini menyimpan data yang dipakai oleh widget/function.
                                    const RegisterScreen(),
                          ),
                        );
                      },

                      // Menampilkan tulisan di layar.
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
