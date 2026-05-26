// =============================================================
// PENJELASAN FILE: lib/utils/auth_helpers.dart
// File ini sudah diberi komentar singkat agar mudah dipresentasikan.
// Komentar tidak mengubah fungsi kode, hanya menjelaskan kegunaannya.
// =============================================================

// Import package/file yang dibutuhkan oleh halaman ini.
import 'package:cloud_firestore/cloud_firestore.dart';
// Import package/file yang dibutuhkan oleh halaman ini.
import 'package:firebase_auth/firebase_auth.dart';

// Import package/file yang dibutuhkan oleh halaman ini.
import 'firestore_collections.dart';

String getDisplayName(User? user) {
  // Mengembalikan hasil dari function/widget.
  if (user == null) return 'User';

  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final displayName = user.displayName?.trim();
  // Percabangan untuk mengecek kondisi tertentu.
  if (displayName != null && displayName.isNotEmpty) {
    // Mengembalikan hasil dari function/widget.
    return displayName;
  }

  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final email = user.email ?? '';
  // Percabangan untuk mengecek kondisi tertentu.
  if (email.contains('@')) {
    // Variabel ini menyimpan data yang dipakai oleh widget/function.
    final name = email.split('@').first;
    // Percabangan untuk mengecek kondisi tertentu.
    if (name.isNotEmpty) {
      // Variabel ini menyimpan data yang dipakai oleh widget/function.
      final normalized = name
          .replaceAll(RegExp(r'[^A-Za-z0-9]+'), ' ')
          .trim()
          .split(' ')
          // Memfilter data dari Firestore.
          .where((part) => part.isNotEmpty)
          // Melakukan perulangan untuk mengolah banyak data.
          .map((part) => part[0].toUpperCase() + part.substring(1))
          .join(' ');
      // Percabangan untuk mengecek kondisi tertentu.
      if (normalized.isNotEmpty) {
        // Mengembalikan hasil dari function/widget.
        return normalized;
      }
    }
  }

  // Mengembalikan hasil dari function/widget.
  return 'User';
}

String getDisplayInitial(User? user) {
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final name = getDisplayName(user);
  // Mengembalikan hasil dari function/widget.
  if (name.isEmpty) return 'U';
  // Mengembalikan hasil dari function/widget.
  return name.trim()[0].toUpperCase();
}

String _normalizeEmail(String email) => email.toLowerCase().trim();

// Function async untuk proses yang membutuhkan waktu, seperti Firebase.
Future<Map<String, dynamic>?> _findUserRecordByEmail(String email) async {
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final lowerEmail = _normalizeEmail(email);
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final collectionNames = FirestoreCollections.userLookupCollections;
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final emailFields = [
    'email',
    'emailAddress',
    'email_address',
    'userEmail',
    'user_email',
  ];

  // Melakukan perulangan untuk mengolah banyak data.
  for (final collection in collectionNames) {
    // Melakukan perulangan untuk mengolah banyak data.
    for (final emailField in emailFields) {
      // Melakukan perulangan untuk mengolah banyak data.
      for (final lookupValue in {lowerEmail, email}) {
        // Mencoba menjalankan proses yang mungkin gagal.
        try {
          // Mengambil instance Firestore untuk akses database.
          final query = await FirebaseFirestore.instance
              // Mengarah ke collection Firestore yang digunakan.
              .collection(collection)
              // Memfilter data dari Firestore.
              .where(emailField, isEqualTo: lookupValue)
              .limit(1)
              // Mengambil data satu kali dari Firebase.
              .get();

          // Percabangan untuk mengecek kondisi tertentu.
          if (query.docs.isNotEmpty) {
            // Mengembalikan hasil dari function/widget.
            return query.docs.first.data() as Map<String, dynamic>?;
          }
        // Menangkap error agar aplikasi tidak langsung berhenti.
        } catch (_) {
          continue;
        }
      }
    }
  }
  // Mengembalikan hasil dari function/widget.
  return null;
}

String? _getStoredPassword(Map<String, dynamic> data) {
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final passwordFields = [
    'password',
    'pass',
    'pwd',
    'kata_sandi',
    'passwordPlain',
    'password_plain',
  ];

  // Melakukan perulangan untuk mengolah banyak data.
  for (final field in passwordFields) {
    // Variabel ini menyimpan data yang dipakai oleh widget/function.
    final value = data[field];
    // Percabangan untuk mengecek kondisi tertentu.
    if (value is String && value.isNotEmpty) {
      // Mengembalikan hasil dari function/widget.
      return value;
    }
  }
  // Mengembalikan hasil dari function/widget.
  return null;
}

String _resolveRoleFromRecord(Map<String, dynamic> record) {
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final role = record['role'] ??
      record['role_name'] ??
      record['hak_akses'] ??
      record['rolename'];
  // Mengembalikan hasil dari function/widget.
  if (role is String && role.toLowerCase() == 'admin') return 'admin';
  // Mengembalikan hasil dari function/widget.
  if (role is int && role == 1) return 'admin';
  // Mengembalikan hasil dari function/widget.
  return 'user';
}

// Function async untuk proses yang membutuhkan waktu, seperti Firebase.
Future<bool> _hasFirestoreUserDocument(User user) async {
  // Mengambil instance Firestore untuk akses database.
  final doc = await FirebaseFirestore.instance.collection(FirestoreCollections.users).doc(user.uid).get();
  // Mengembalikan hasil dari function/widget.
  return doc.exists;
}

// Function async untuk proses yang membutuhkan waktu, seperti Firebase.
Future<void> ensureFirestoreUserRecord(User user, {String role = 'user'}) async {
  // Percabangan untuk mengecek kondisi tertentu.
  if (await _hasFirestoreUserDocument(user)) return;
  // Menunggu proses async sampai selesai.
  await createFirestoreUserFromAuth(user, role: role);
}

// Function async untuk proses yang membutuhkan waktu, seperti Firebase.
Future<bool> createAuthUserFromFirestore(String email, String password) async {
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final record = await _findUserRecordByEmail(email);
  // Mengembalikan hasil dari function/widget.
  if (record == null) return false;

  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final storedPassword = _getStoredPassword(record);
  // Mengembalikan hasil dari function/widget.
  if (storedPassword == null || storedPassword != password) return false;

  // Mencoba menjalankan proses yang mungkin gagal.
  try {
    // Mengakses fitur autentikasi Firebase.
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Mengambil instance Firebase Auth untuk login/register/logout.
    final currentUser = FirebaseAuth.instance.currentUser;
    // Percabangan untuk mengecek kondisi tertentu.
    if (currentUser != null) {
      // Variabel ini menyimpan data yang dipakai oleh widget/function.
      final role = _resolveRoleFromRecord(record);
      // Menunggu proses async sampai selesai.
      await createFirestoreUserFromAuth(currentUser, role: role);
    }

    // Mengembalikan hasil dari function/widget.
    return true;
  // Menangkap error agar aplikasi tidak langsung berhenti.
  } on FirebaseAuthException catch (e) {
    // Percabangan untuk mengecek kondisi tertentu.
    if (e.code == 'email-already-in-use' ||
        e.code == 'invalid-email' ||
        e.code == 'weak-password') {
      // Mengembalikan hasil dari function/widget.
      return false;
    }
    rethrow;
  }
}

// Function async untuk proses yang membutuhkan waktu, seperti Firebase.
Future<bool> isAdminAccount(User? user) async {
  // Mengembalikan hasil dari function/widget.
  if (user == null) return false;

  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final email = _normalizeEmail(user.email ?? '');
  // Mengembalikan hasil dari function/widget.
  if (email.isEmpty) return false;

  // Mengembalikan hasil dari function/widget.
  if (email == 'athanasywan@gmail.com') return true;

  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final data = await _findUserRecordByEmail(email);
  // Mengembalikan hasil dari function/widget.
  if (data == null) return false;

  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final role = data['role'] ??
      data['role_name'] ??
      data['hak_akses'] ??
      data['rolename'];
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final adminIndicator = data['isAdmin'] ??
      data['is_admin'] ??
      data['admin'] ??
      data['isadmin'] ??
      data['role_id'];

  // Mengembalikan hasil dari function/widget.
  if (role is String && role.toLowerCase() == 'admin') return true;
  // Mengembalikan hasil dari function/widget.
  if (role is int && role == 1) return true;
  // Mengembalikan hasil dari function/widget.
  if (adminIndicator == true) return true;
  // Percabangan untuk mengecek kondisi tertentu.
  if (adminIndicator is String && adminIndicator.toLowerCase() == 'admin') {
    // Mengembalikan hasil dari function/widget.
    return true;
  }

  // Mengembalikan hasil dari function/widget.
  return false;
}

// Function async untuk proses yang membutuhkan waktu, seperti Firebase.
Future<void> createFirestoreUserFromAuth(User user, {String role = 'user'}) async {
  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final email = _normalizeEmail(user.email ?? '');
  // Percabangan untuk mengecek kondisi tertentu.
  if (email.isEmpty) return;

  // Variabel ini menyimpan data yang dipakai oleh widget/function.
  final username = getDisplayName(user);
  // Mengambil instance Firestore untuk akses database.
  final userRef = FirebaseFirestore.instance.collection(FirestoreCollections.users).doc(user.uid);

  // Menyimpan atau mengganti data ke Firestore.
  await userRef.set({
    'uid': user.uid,
    'email': email,
    'username': username,
    'role': role,
    'isAdmin': role.toLowerCase() == 'admin',
    'createdAt': FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));
}
