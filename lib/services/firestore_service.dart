import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // CREATE
  Future<void> tambahBeasiswa({
    required String nama,
    required String category,
    required String imageUrl,
    required String deskripsi,
  }) async {
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
    return _db.collection('beasiswa').snapshots();
  }

  // UPDATE
  Future<void> updateBeasiswa(
    String id,
    Map<String, dynamic> data,
  ) async {
    await _db.collection('beasiswa').doc(id).update(data);
  }

  // DELETE
  Future<void> deleteBeasiswa(String id) async {
    await _db.collection('beasiswa').doc(id).delete();
  }
}