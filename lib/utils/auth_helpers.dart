import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firestore_collections.dart';

String getDisplayName(User? user) {
  if (user == null) return 'User';

  final displayName = user.displayName?.trim();
  if (displayName != null && displayName.isNotEmpty) {
    return displayName;
  }

  final email = user.email ?? '';
  if (email.contains('@')) {
    final name = email.split('@').first;
    if (name.isNotEmpty) {
      final normalized = name
          .replaceAll(RegExp(r'[^A-Za-z0-9]+'), ' ')
          .trim()
          .split(' ')
          .where((part) => part.isNotEmpty)
          .map((part) => part[0].toUpperCase() + part.substring(1))
          .join(' ');
      if (normalized.isNotEmpty) {
        return normalized;
      }
    }
  }

  return 'User';
}

String getDisplayInitial(User? user) {
  final name = getDisplayName(user);
  if (name.isEmpty) return 'U';
  return name.trim()[0].toUpperCase();
}

String _normalizeEmail(String email) => email.toLowerCase().trim();

Future<Map<String, dynamic>?> _findUserRecordByEmail(String email) async {
  final lowerEmail = _normalizeEmail(email);
  final collectionNames = FirestoreCollections.userLookupCollections;
  final emailFields = [
    'email',
    'emailAddress',
    'email_address',
    'userEmail',
    'user_email',
  ];

  for (final collection in collectionNames) {
    for (final emailField in emailFields) {
      for (final lookupValue in {lowerEmail, email}) {
        try {
          final query = await FirebaseFirestore.instance
              .collection(collection)
              .where(emailField, isEqualTo: lookupValue)
              .limit(1)
              .get();

          if (query.docs.isNotEmpty) {
            return query.docs.first.data() as Map<String, dynamic>?;
          }
        } catch (_) {
          continue;
        }
      }
    }
  }
  return null;
}

String? _getStoredPassword(Map<String, dynamic> data) {
  final passwordFields = [
    'password',
    'pass',
    'pwd',
    'kata_sandi',
    'passwordPlain',
    'password_plain',
  ];

  for (final field in passwordFields) {
    final value = data[field];
    if (value is String && value.isNotEmpty) {
      return value;
    }
  }
  return null;
}

String _resolveRoleFromRecord(Map<String, dynamic> record) {
  final role = record['role'] ??
      record['role_name'] ??
      record['hak_akses'] ??
      record['rolename'];
  if (role is String && role.toLowerCase() == 'admin') return 'admin';
  if (role is int && role == 1) return 'admin';
  return 'user';
}

Future<bool> _hasFirestoreUserDocument(User user) async {
  final doc = await FirebaseFirestore.instance.collection(FirestoreCollections.users).doc(user.uid).get();
  return doc.exists;
}

Future<void> ensureFirestoreUserRecord(User user, {String role = 'user'}) async {
  if (await _hasFirestoreUserDocument(user)) return;
  await createFirestoreUserFromAuth(user, role: role);
}

Future<bool> createAuthUserFromFirestore(String email, String password) async {
  final record = await _findUserRecordByEmail(email);
  if (record == null) return false;

  final storedPassword = _getStoredPassword(record);
  if (storedPassword == null || storedPassword != password) return false;

  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final role = _resolveRoleFromRecord(record);
      await createFirestoreUserFromAuth(currentUser, role: role);
    }

    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use' ||
        e.code == 'invalid-email' ||
        e.code == 'weak-password') {
      return false;
    }
    rethrow;
  }
}

Future<bool> isAdminAccount(User? user) async {
  if (user == null) return false;

  final email = _normalizeEmail(user.email ?? '');
  if (email.isEmpty) return false;

  if (email == 'athanasywan@gmail.com') return true;

  final data = await _findUserRecordByEmail(email);
  if (data == null) return false;

  final role = data['role'] ??
      data['role_name'] ??
      data['hak_akses'] ??
      data['rolename'];
  final adminIndicator = data['isAdmin'] ??
      data['is_admin'] ??
      data['admin'] ??
      data['isadmin'] ??
      data['role_id'];

  if (role is String && role.toLowerCase() == 'admin') return true;
  if (role is int && role == 1) return true;
  if (adminIndicator == true) return true;
  if (adminIndicator is String && adminIndicator.toLowerCase() == 'admin') {
    return true;
  }

  return false;
}

Future<void> createFirestoreUserFromAuth(User user, {String role = 'user'}) async {
  final email = _normalizeEmail(user.email ?? '');
  if (email.isEmpty) return;

  final username = getDisplayName(user);
  final userRef = FirebaseFirestore.instance.collection(FirestoreCollections.users).doc(user.uid);

  await userRef.set({
    'uid': user.uid,
    'email': email,
    'username': username,
    'role': role,
    'isAdmin': role.toLowerCase() == 'admin',
    'createdAt': FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));
}
