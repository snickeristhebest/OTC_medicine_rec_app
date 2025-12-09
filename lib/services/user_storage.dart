import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';

class UserStorage {
  static final Map<String, String> _users = {'test': 'password'};

  static bool validateUser(String email, String password) {
    return _users[email] == password;
  }

  static void registerUser(String email, String password) {
    _users[email] = password;
  }

  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Save the current `UserProfile` to Firestore for the signed-in user.
  static Future<void> saveUserProfileForCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('UserStorage.saveUserProfileForCurrentUser: no signed-in user');
      return;
    }
    final data = UserProfile.toMap();
    try {
      print('UserStorage: saving profile for uid=${user.uid} data=$data');
      await _db
          .collection('users')
          .doc(user.uid)
          .set(data, SetOptions(merge: true));
      print('UserStorage: profile saved for uid=${user.uid}');
    } catch (e) {
      print('UserStorage: error saving profile for uid=${user.uid}: $e');
      rethrow;
    }
  }

  /// Load the `UserProfile` from Firestore into the static `UserProfile` fields.
  static Future<void> loadUserProfileForCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('UserStorage.loadUserProfileForCurrentUser: no signed-in user');
      return;
    }
    try {
      print('UserStorage: loading profile for uid=${user.uid}');
      final doc = await _db.collection('users').doc(user.uid).get();
      if (doc.exists) {
        UserProfile.fromMap(doc.data());
        print('UserStorage: loaded profile for uid=${user.uid}');
      } else {
        print('UserStorage: no profile document for uid=${user.uid}');
      }
    } catch (e) {
      print('UserStorage: error loading profile for uid=${user.uid}: $e');
    }
  }
}
