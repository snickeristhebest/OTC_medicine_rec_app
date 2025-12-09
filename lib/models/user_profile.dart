import 'package:flutter/foundation.dart';

class UserProfile {
  static int? age;
  static String? gender;
  static bool? isPregnant;
  static double? temperature;

  // Notifier to allow UI to react to profile changes
  static final ValueNotifier<int> profileVersion = ValueNotifier<int>(0);

  static bool isComplete() {
    return age != null && gender != null && isPregnant != null;
  }

  static void clear() {
    age = null;
    gender = null;
    isPregnant = null;
    temperature = null;
    notifyListeners();
  }

  static void notifyListeners() {
    profileVersion.value = profileVersion.value + 1;
  }

  static Map<String, dynamic> toMap() {
    return {
      'age': age,
      'gender': gender,
      'isPregnant': isPregnant,
      'temperature': temperature,
    };
  }

  static void fromMap(Map<String, dynamic>? map) {
    if (map == null) return;
    age = map['age'] is int ? map['age'] as int : (map['age'] != null ? (map['age'] as num).toInt() : null);
    gender = map['gender'] as String?;
    isPregnant = map['isPregnant'] as bool?;
    temperature = map['temperature'] != null ? (map['temperature'] as num).toDouble() : null;
    notifyListeners();
  }
}
