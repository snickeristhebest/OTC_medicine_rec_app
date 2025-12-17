import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/medicine.dart';

class SavedMedicines {
  static final List<Medicine> _savedMedicines = [];
  static final ValueNotifier<int> savedCount = ValueNotifier<int>(
    _savedMedicines.length,
  );

  static List<Medicine> getSaved() => _savedMedicines;

  static bool isSaved(Medicine medicine) {
    return _savedMedicines.any((m) => m.name == medicine.name);
  }

  /// Load saved medicines for the currently signed-in user from Firestore.
  static Future<void> loadSavedForCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final col = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('saved_medicines');
    final snapshot = await col.get();
    _savedMedicines.clear();
    for (final doc in snapshot.docs) {
      try {
        _savedMedicines.add(Medicine.fromMap(doc.data()));
      } catch (_) {}
    }
    // Notify listeners about the new count
    savedCount.value = _savedMedicines.length;
  }

  /// Toggle saved state and persist change to Firestore when a user is signed in.
  static Future<void> toggleSave(Medicine medicine) async {
    final user = FirebaseAuth.instance.currentUser;
    final bool currentlySaved = isSaved(medicine);

    if (user == null) {
      // No signed-in user: keep local-only behavior
      if (currentlySaved) {
        _savedMedicines.removeWhere((m) => m.name == medicine.name);
      } else {
        _savedMedicines.add(medicine);
      }
      savedCount.value = _savedMedicines.length;
      return;
    }

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('saved_medicines')
        .doc(medicine.name);

    if (currentlySaved) {
      await docRef.delete();
      _savedMedicines.removeWhere((m) => m.name == medicine.name);
      savedCount.value = _savedMedicines.length;
    } else {
      await docRef.set(medicine.toMap());
      _savedMedicines.add(medicine);
      savedCount.value = _savedMedicines.length;
    }
  }
}
