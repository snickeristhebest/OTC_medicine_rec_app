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
}
