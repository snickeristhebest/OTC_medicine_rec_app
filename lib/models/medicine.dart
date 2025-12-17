class Medicine {
  final String name;
  final String? genericName;
  final String? manufacturer;
  final String purpose;
  final String? uses;
  final String? category;
  final String? route;
  final String? activeIngredient;
  final String dosage;
  final String warning;
  final List<String> symptoms;
  final double rating;
  final double relevanceScore;
  final double price;
  final String? link;

  Medicine({
    required this.name,
    this.genericName,
    this.manufacturer,
    required this.purpose,
    this.uses,
    this.category,
    this.route,
    this.activeIngredient,
    required this.dosage,
    required this.warning,
    required this.symptoms,
    this.rating = 0.0,
    this.relevanceScore = 0.0,
    this.price = 0.0,
    this.link,
  });

  // Factory constructor to create Medicine from JSON (API response)
  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      name: json['name'] ?? 'Unknown Product',
      genericName: json['generic name'] != 'Unknown Product' ? json['generic name'] : null,
      manufacturer: json['manufacturer'] != 'N/A' ? json['manufacturer'] : null,
      purpose: json['purpose'] ?? 'N/A',
      uses: json['uses'] != 'N/A' ? json['uses'] : null,
      category: json['category'] != 'unknown' ? json['category'] : null,
      route: json['route'] != 'N/A' ? json['route'] : null,
      activeIngredient: json['active_ingredient'] != 'N/A' ? json['active_ingredient'] : null,
      dosage: json['dosage'] ?? 'N/A',
      warning: json['warnings'] ?? 'N/A',
      symptoms: json['symptoms'] != null 
          ? List<String>.from(json['symptoms'])
          : [],
      rating: _parseDouble(json['rating']),
      relevanceScore: _parseDouble(json['relevance_score']),
      price: _parseDouble(json['price']),
      link: json['link'] != 'N/A' ? json['link'] : null,
    );
  }

  // Helper method to safely parse doubles from various types
  static double _parseDouble(dynamic value) {
    if (value == null || value == 'N/A') return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  // Convert Medicine to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'generic name': genericName ?? 'Unknown Product',
      'manufacturer': manufacturer ?? 'N/A',
      'purpose': purpose,
      'uses': uses ?? 'N/A',
      'category': category ?? 'unknown',
      'route': route ?? 'N/A',
      'active_ingredient': activeIngredient ?? 'N/A',
      'dosage': dosage,
      'warnings': warning,
      'symptoms': symptoms,
      'rating': rating,
      'relevance_score': relevanceScore,
      'price': price.toString(),
      'link': link ?? 'N/A',
    };
  }
}