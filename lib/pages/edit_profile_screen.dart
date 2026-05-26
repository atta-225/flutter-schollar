// =============================================================
// PENJELASAN FILE: lib/pages/edit_profile_screen.dart
// File ini sudah diberi komentar singkat agar mudah dipresentasikan.
// Komentar tidak mengubah fungsi kode, hanya menjelaskan kegunaannya.
// =============================================================

// Import package/file yang dibutuhkan oleh halaman ini.
import 'package:flutter/material.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import 'package:firebase_auth/firebase_auth.dart';

// Class EditProfileScreen adalah halaman tampilan pada aplikasi.
class EditProfileScreen extends StatefulWidget {
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  const EditProfileScreen({super.key});

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

// Class _EditProfileScreenState adalah halaman tampilan pada aplikasi.
class _EditProfileScreenState extends State<EditProfileScreen> {
  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool isLoading = false;

  // Controller untuk membaca dan mengatur isi input text.
  final TextEditingController usernameController = TextEditingController();
  // Controller untuk membaca dan mengatur isi input text.
  final TextEditingController passwordController = TextEditingController();
  // Controller untuk membaca dan mengatur isi input text.
  final TextEditingController confirmPasswordController =
      TextEditingController();

  User? user;

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  // Method ini berjalan pertama kali saat halaman dibuka.
  void initState() {
    super.initState();
    // Mengakses fitur autentikasi Firebase.
    user = FirebaseAuth.instance.currentUser;

    usernameController.text =
        user?.displayName?.isNotEmpty == true ? user!.displayName! : 'User';
  }

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  // Method ini membersihkan controller agar tidak boros memori.
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // Function async untuk proses yang membutuhkan waktu, seperti Firebase.
  Future<void> saveProfile() async {
    // Variabel ini menyimpan data yang dipakai oleh widget/function.
    final username = usernameController.text.trim();
    // Variabel ini menyimpan data yang dipakai oleh widget/function.
    final password = passwordController.text.trim();
    // Variabel ini menyimpan data yang dipakai oleh widget/function.
    final confirmPassword = confirmPasswordController.text.trim();

    // Percabangan untuk mengecek kondisi tertentu.
    if (username.isEmpty) {
      showMessage('Username tidak boleh kosong', Colors.red);
      return;
    }

    // Percabangan untuk mengecek kondisi tertentu.
    if (password.isNotEmpty && password.length < 6) {
      showMessage('Password minimal 6 karakter', Colors.red);
      return;
    }

    // Percabangan untuk mengecek kondisi tertentu.
    if (password.isNotEmpty && password != confirmPassword) {
      showMessage('Password tidak sama', Colors.red);
      return;
    }

    // Mencoba menjalankan proses yang mungkin gagal.
    try {
      // Memperbarui tampilan setelah data berubah.
      setState(() => isLoading = true);

      // Mengambil instance Firebase Auth untuk login/register/logout.
      final currentUser = FirebaseAuth.instance.currentUser;

      // Percabangan untuk mengecek kondisi tertentu.
      if (currentUser == null) {
        showMessage('User belum login', Colors.red);
        return;
      }

      // Menunggu proses async sampai selesai.
      await currentUser.updateDisplayName(username);

      // Percabangan untuk mengecek kondisi tertentu.
      if (password.isNotEmpty) {
        // Menunggu proses async sampai selesai.
        await currentUser.updatePassword(password);
      }

      // Menunggu proses async sampai selesai.
      await currentUser.reload();

      // Percabangan untuk mengecek kondisi tertentu.
      if (!mounted) return;

      showMessage('Profile berhasil disimpan', const Color(0xFF176653));

      // Kembali ke halaman sebelumnya.
      Navigator.pop(context, true);
    // Menangkap error agar aplikasi tidak langsung berhenti.
    } on FirebaseAuthException catch (e) {
      // Percabangan untuk mengecek kondisi tertentu.
      if (e.code == 'requires-recent-login') {
        showMessage(
          'Silakan logout lalu login ulang sebelum ganti password',
          Colors.red,
        );
      // Bagian ini dijalankan jika kondisi sebelumnya tidak terpenuhi.
      } else {
        showMessage(e.message ?? 'Gagal menyimpan profile', Colors.red);
      }
    // Menangkap error agar aplikasi tidak langsung berhenti.
    } catch (e) {
      showMessage('Error: $e', Colors.red);
    } finally {
      // Percabangan untuk mengecek kondisi tertentu.
      if (mounted) {
        // Memperbarui tampilan setelah data berubah.
        setState(() => isLoading = false);
      }
    }
  }

  // Function ini menjalankan aksi tertentu pada halaman.
  void showMessage(String text, Color color) {
    // Menampilkan pesan singkat di bawah layar.
    ScaffoldMessenger.of(context).showSnackBar(
      // Menampilkan pesan singkat di bawah layar.
      SnackBar(
        // Menampilkan tulisan di layar.
        content: Text(text),
        backgroundColor: color,
      ),
    );
  }

  // Menandakan method ini mengganti method bawaan dari parent class.
  @override
  // Method build dipakai Flutter untuk menggambar tampilan layar.
  Widget build(BuildContext context) {
    // Variabel ini menyimpan data yang dipakai oleh widget/function.
    final initial = usernameController.text.isNotEmpty
        ? usernameController.text[0].toUpperCase()
        : 'U';

    // Kerangka utama halaman Flutter.
    return Scaffold(
      backgroundColor: const Color(0xFFEFFFF6),
      // Menumpuk widget di atas widget lain.
      body: Stack(
        children: [
          // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
          Container(
            height: 405,
            width: double.infinity,
            // Mengatur dekorasi seperti warna, radius, shadow, atau border.
            decoration: const BoxDecoration(
              color: Color(0xFF5F8B76),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(70),
                bottomRight: Radius.circular(70),
              ),
            ),
          ),

          // Menjaga UI agar tidak tertutup notch/status bar.
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(25, 18, 25, 40),
              // Menyusun widget secara vertikal dari atas ke bawah.
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    // Widget tombol/klik untuk menjalankan aksi.
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                      // Kembali ke halaman sebelumnya.
                      onPressed: () => Navigator.pop(context),
                      // Menampilkan icon pada UI.
                      icon: const Icon(
                        Icons.keyboard_backspace_rounded,
                        size: 31,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  // Variabel ini menyimpan data yang dipakai oleh widget/function.
                  const SizedBox(height: 6),

                  // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(12, 48, 12, 95),
                    // Mengatur dekorasi seperti warna, radius, shadow, atau border.
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(26),
                    ),
                    // Menyusun widget secara vertikal dari atas ke bawah.
                    child: Column(
                      children: [
                        // Container untuk membungkus widget dan mengatur ukuran/dekorasi.
                        Container(
                          width: 94,
                          height: 94,
                          alignment: Alignment.center,
                          // Mengatur dekorasi seperti warna, radius, shadow, atau border.
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
                          // Menampilkan tulisan di layar.
                          child: Text(
                            initial,
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2E1748),
                            ),
                          ),
                        ),

                        // Variabel ini menyimpan data yang dipakai oleh widget/function.
                        const SizedBox(height: 34),

                        // Variabel ini menyimpan data yang dipakai oleh widget/function.
                        const Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),

                        // Variabel ini menyimpan data yang dipakai oleh widget/function.
                        const SizedBox(height: 22),

                        _label('Username'),
                        _input(
                          controller: usernameController,
                          hint: 'Username',
                        ),

                        // Variabel ini menyimpan data yang dipakai oleh widget/function.
                        const SizedBox(height: 14),

                        _label('New Password'),
                        _input(
                          controller: passwordController,
                          hint: 'Kosongkan jika tidak ingin ganti',
                          obscure: hidePassword,
                          // Widget tombol/klik untuk menjalankan aksi.
                          suffix: IconButton(
                            onPressed: () {
                              // Memperbarui tampilan setelah data berubah.
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            },
                            // Menampilkan icon pada UI.
                            icon: Icon(
                              hidePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 19,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        // Variabel ini menyimpan data yang dipakai oleh widget/function.
                        const SizedBox(height: 14),

                        _label('Confirm New Password'),
                        _input(
                          controller: confirmPasswordController,
                          hint: 'Ulangi password baru',
                          obscure: hideConfirmPassword,
                          // Widget tombol/klik untuk menjalankan aksi.
                          suffix: IconButton(
                            onPressed: () {
                              // Memperbarui tampilan setelah data berubah.
                              setState(() {
                                hideConfirmPassword = !hideConfirmPassword;
                              });
                            },
                            // Menampilkan icon pada UI.
                            icon: Icon(
                              hideConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 19,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        // Variabel ini menyimpan data yang dipakai oleh widget/function.
                        const SizedBox(height: 25),

                        // Memberi jarak kosong atau ukuran tetap.
                        SizedBox(
                          width: double.infinity,
                          height: 39,
                          // Widget tombol/klik untuk menjalankan aksi.
                          child: ElevatedButton(
                            onPressed: isLoading ? null : saveProfile,
                            // Widget tombol/klik untuk menjalankan aksi.
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF176653),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                            // Menampilkan tulisan di layar.
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
    // Memberi jarak bagian dalam di sekitar widget.
    return Padding(
      padding: const EdgeInsets.only(left: 1, bottom: 7),
      child: Align(
        alignment: Alignment.centerLeft,
        // Menampilkan tulisan di layar.
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
    // Memberi jarak kosong atau ukuran tetap.
    return SizedBox(
      height: 46,
      // Input text biasa dari user.
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.black87,
        ),
        // Mengatur tampilan input seperti label, hint, dan border.
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
