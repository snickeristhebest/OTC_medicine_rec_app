import '../models/medicine.dart';

class SavedMedicines {
  static final List<Medicine> _savedMedicines = [];

  static List<Medicine> getSaved() => _savedMedicines;

  static bool isSaved(Medicine medicine) {
    return _savedMedicines.any((m) => m.name == medicine.name);
  }

  static void toggleSave(Medicine medicine) {
    if (isSaved(medicine)) {
      _savedMedicines.removeWhere((m) => m.name == medicine.name);
    } else {
      _savedMedicines.add(medicine);
    }
  }
}
