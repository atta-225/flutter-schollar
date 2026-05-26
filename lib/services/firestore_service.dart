// =============================================================
// PENJELASAN FILE: lib/services/firestore_service.dart
// File ini sudah diberi komentar singkat agar mudah dipresentasikan.
// Komentar tidak mengubah fungsi kode, hanya menjelaskan kegunaannya.
// =============================================================

// Import package/file yang dibutuhkan oleh halaman ini.
import 'package:cloud_firestore/cloud_firestore.dart';

// Class FirestoreService menyimpan struktur atau logic utama.
class FirestoreService {
  // Mengambil instance Firestore untuk akses database.
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // CREATE
  // Function async untuk proses yang membutuhkan waktu, seperti Firebase.
  Future<void> tambahBeasiswa({
    required String nama,
    required String category,
    required String imageUrl,
    required String deskripsi,
  }) async {
    // Mengarah ke collection Firestore yang digunakan.
    await _db.collection('beasiswa').add({
      'nama': nama,
      'category': category,
      'imageUrl': imageUrl,
      'deskripsi': deskripsi,
      'createdAt': Timestamp.now(),
    });
  }

  // READ
  Stream<QuerySnapshot> getBeasiswa() {
    // Mengarah ke collection Firestore yang digunakan.
    return _db.collection('beasiswa').snapshots();
  }

  // UPDATE
  // Function async untuk proses yang membutuhkan waktu, seperti Firebase.
  Future<void> updateBeasiswa(
    String id,
    Map<String, dynamic> data,
  ) async {
    // Mengarah ke collection Firestore yang digunakan.
    await _db.collection('beasiswa').doc(id).update(data);
  }

  // DELETE
  // Function async untuk proses yang membutuhkan waktu, seperti Firebase.
  Future<void> deleteBeasiswa(String id) async {
    // Mengarah ke collection Firestore yang digunakan.
    await _db.collection('beasiswa').doc(id).delete();
  }
}
