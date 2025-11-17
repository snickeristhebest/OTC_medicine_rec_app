class UserProfile {
  static int? age;
  static String? gender;
  static bool? isPregnant;
  static double? temperature;
  
  static bool isComplete() {
    return age != null && gender != null && isPregnant != null;
  }
  
  static void clear() {
    age = null;
    gender = null;
    isPregnant = null;
    temperature = null;
  }
}
