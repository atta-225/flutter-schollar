// =============================================================
// PENJELASAN FILE: lib/pages/register_screen.dart
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
import 'main_nav_screen.dart';

// Class RegisterScreen adalah halaman tampilan pada aplikasi.
class RegisterScreen extends StatefulWidget {
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  const RegisterScreen({super.key});

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

// Class _RegisterScreenState adalah halaman tampilan pada aplikasi.
class _RegisterScreenState extends State<RegisterScreen> {
  // Controller untuk membaca dan mengatur isi input text.
  final emailC = TextEditingController();
  // Controller untuk membaca dan mengatur isi input text.
  final passC = TextEditingController();
  // Controller untuk membaca dan mengatur isi input text.
  final confirmC = TextEditingController();

  bool hide1 = true;
  bool hide2 = true;
  bool loading = false;

  // Function async untuk proses yang membutuhkan waktu, seperti Firebase.
  Future<void> register() async {
    // Variabel ini menyimpan data yang dipakai oleh widget/function.
    final email = emailC.text.trim();
    // Variabel ini menyimpan data yang dipakai oleh widget/function.
    final password = passC.text.trim();
    // Variabel ini menyimpan data yang dipakai oleh widget/function.
    final confirmPassword = confirmC.text.trim();

    // Percabangan untuk mengecek kondisi tertentu.
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      // Menampilkan pesan singkat di bawah layar.
      ScaffoldMessenger.of(context).showSnackBar(
        // Variabel ini menyimpan data yang dipakai oleh widget/function.
        const SnackBar(
          // Menampilkan tulisan di layar.
          content: Text('Semua field wajib diisi.'),
        ),
      );
      return;
    }

    // Percabangan untuk mengecek kondisi tertentu.
    if (password != confirmPassword) {
      // Menampilkan pesan singkat di bawah layar.
      ScaffoldMessenger.of(context).showSnackBar(
        // Variabel ini menyimpan data yang dipakai oleh widget/function.
        const SnackBar(
          // Menampilkan tulisan di layar.
          content: Text('Password tidak sama.'),
        ),
      );
      return;
    }

    // Memperbarui tampilan setelah data berubah.
    setState(() => loading = true);

    // Mencoba menjalankan proses yang mungkin gagal.
    try {
      // Variabel ini menyimpan data yang dipakai oleh widget/function.
      final credential =
          // Mengakses fitur autentikasi Firebase.
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Variabel ini menyimpan data yang dipakai oleh widget/function.
      final currentUser = credential.user;

      // Percabangan untuk mengecek kondisi tertentu.
      if (currentUser != null) {
        // Menunggu proses async sampai selesai.
        await createFirestoreUserFromAuth(
          currentUser,
          role: 'user',
        );
      }

      // Percabangan untuk mengecek kondisi tertentu.
      if (!mounted) return;

      // Membuka halaman baru.
      Navigator.pushReplacement(
        context,
        // Menentukan halaman tujuan saat navigasi.
        MaterialPageRoute(
          builder: (_) => const MainNavScreen(),
        ),
      );
    // Menangkap error agar aplikasi tidak langsung berhenti.
    } on FirebaseAuthException catch (e) {
      // Percabangan untuk mengecek kondisi tertentu.
      if (!mounted) return;

      // Menampilkan pesan singkat di bawah layar.
      ScaffoldMessenger.of(context).clearSnackBars();

      // Menampilkan pesan singkat di bawah layar.
      ScaffoldMessenger.of(context).showSnackBar(
        // Menampilkan pesan singkat di bawah layar.
        SnackBar(
          // Menampilkan tulisan di layar.
          content: Text(_errorMessage(e)),
        ),
      );
    // Menangkap error agar aplikasi tidak langsung berhenti.
    } catch (e) {
      // Percabangan untuk mengecek kondisi tertentu.
      if (!mounted) return;

      // Menampilkan pesan singkat di bawah layar.
      ScaffoldMessenger.of(context).clearSnackBars();

      // Menampilkan pesan singkat di bawah layar.
      ScaffoldMessenger.of(context).showSnackBar(
        // Menampilkan pesan singkat di bawah layar.
        SnackBar(
          // Menampilkan tulisan di layar.
          content: Text(
            'Terjadi kesalahan: ${e.runtimeType}: ${e.toString()}',
          ),
        ),
      );
    }

    // Percabangan untuk mengecek kondisi tertentu.
    if (mounted) {
      // Memperbarui tampilan setelah data berubah.
      setState(() => loading = false);
    }
  }

  String _errorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        // Mengembalikan hasil dari function/widget.
        return 'Format email tidak valid.';

      case 'email-already-in-use':
        // Mengembalikan hasil dari function/widget.
        return 'Email sudah digunakan.';

      case 'weak-password':
        // Mengembalikan hasil dari function/widget.
        return 'Password terlalu lemah.';

      case 'operation-not-allowed':
        // Mengembalikan hasil dari function/widget.
        return 'Pendaftaran belum diaktifkan.';

      default:
        // Mengembalikan hasil dari function/widget.
        return e.message ?? 'Pendaftaran gagal: ${e.code}';
    }
  }

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
            padding: const EdgeInsets.symmetric(horizontal: 4),
            // Menyusun widget secara vertikal dari atas ke bawah.
            child: Column(
              children: [
                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const SizedBox(height: 20),

                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const AppLogo(size: 100),

                // Menampilkan tulisan di layar.
                Text(
                  'Borneo Scholar',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),

                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const SizedBox(height: 8),

                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const Text(
                  'Sign up and start your scholarship journey today',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),

                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const SizedBox(height: 22),

                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const Align(
                  alignment: Alignment.centerLeft,
                  // Menampilkan tulisan di layar.
                  child: Text(
                    'Username',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const SizedBox(height: 8),

                // Input text biasa dari user.
                TextField(
                  controller: emailC,
                  keyboardType: TextInputType.emailAddress,
                  decoration: inputStyle(
                    'Enter your Username',
                  ),
                ),

                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const SizedBox(height: 14),

                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const Align(
                  alignment: Alignment.centerLeft,
                  // Menampilkan tulisan di layar.
                  child: Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const SizedBox(height: 8),

                // Input text biasa dari user.
                TextField(
                  controller: passC,
                  obscureText: hide1,
                  decoration: inputStyle(
                    'Enter password',
                    // Widget tombol/klik untuk menjalankan aksi.
                    suffix: IconButton(
                      // Menampilkan icon pada UI.
                      icon: Icon(
                        hide1
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                      ),
                      onPressed: () {
                        // Memperbarui tampilan setelah data berubah.
                        setState(() => hide1 = !hide1);
                      },
                    ),
                  ),
                ),

                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const SizedBox(height: 14),

                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const Align(
                  alignment: Alignment.centerLeft,
                  // Menampilkan tulisan di layar.
                  child: Text(
                    'Confirm Password',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Variabel ini menyimpan data yang dipakai oleh widget/function.
                const SizedBox(height: 8),

                // Input text biasa dari user.
                TextField(
                  controller: confirmC,
                  obscureText: hide2,
                  decoration: inputStyle(
                    'Confirm your password',
                    // Widget tombol/klik untuk menjalankan aksi.
                    suffix: IconButton(
                      // Menampilkan icon pada UI.
                      icon: Icon(
                        hide2
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                      ),
                      onPressed: () {
                        // Memperbarui tampilan setelah data berubah.
                        setState(() => hide2 = !hide2);
                      },
                    ),
                  ),
                ),

                // Variabel ini menyimpan data yang dipakai oleh widget/function.
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
