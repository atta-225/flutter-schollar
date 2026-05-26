class FirestoreCollections {
  FirestoreCollections._();

  static const String users = 'users';
  static const String scholarships = 'beasiswa';
  static const String savedScholarships = 'saved_beasiswa';

  static const List<String> userLookupCollections = [
    'users',
    'pengguna',
    'akun',
    'accounts',
    'admins',
    'admin',
  ];

  static const List<String> scholarshipsAliases = [
    'beasiswa',
    'scholarship',
  ];

  static const List<String> savedScholarshipsAliases = [
    'saved_beasiswa',
    'user_favorite',
    'favorites',
    'userfavorites',
  ];
}
