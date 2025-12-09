class Medicine {
  final String name;
  final String purpose;
  final String warning;
  final String dosage;
  final List<String> symptoms;
  final double rating;
  final String? link;

  Medicine({
    required this.name,
    required this.purpose,
    required this.warning,
    required this.dosage,
    required this.symptoms,
    this.rating = 0.0,
    this.link,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'purpose': purpose,
      'warning': warning,
      'dosage': dosage,
      'symptoms': symptoms,
      'rating': rating,
      'link': link,
    };
  }

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      name: map['name'] ?? '',
      purpose: map['purpose'] ?? '',
      warning: map['warning'] ?? '',
      dosage: map['dosage'] ?? '',
      symptoms: map['symptoms'] != null
          ? List<String>.from(map['symptoms'])
          : <String>[],
      rating: map['rating'] != null
          ? (map['rating'] is int
                ? (map['rating'] as int).toDouble()
                : map['rating'] as double)
          : 0.0,
      link: map['link'],
    );
  }
}
