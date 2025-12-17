import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/medicine.dart';
import '../models/user_profile.dart';
import '../widgets/app_header.dart';
import '../pages/medicine_detail_page.dart';

class ResultsPage extends StatefulWidget {
  final List<String> symptoms;

  const ResultsPage({super.key, required this.symptoms});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  bool isLoading = false;
  List<Medicine> results = [];

  @override
  void initState() {
    super.initState();
    fetchMedicines();
  }

  String _cleanText(String? text) {
    if (text == null || text == 'N/A' || text.isEmpty) {
      return '';
    }
    return text.trim();
  }

  Future<void> fetchMedicines() async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse(
      "https://luckygamer02-otc-medicine-api.hf.space/api/recommend",
    );

    final symptomsString = widget.symptoms.join(", ");

    final body = jsonEncode({
      "symptoms": symptomsString,
      "age": UserProfile.age ?? 21,
      "pregnant": false,
      "breastfeeding": false,
      "top_k": 10,
    });
    double _parseDouble(dynamic value) {
      if (value == null) return 0.0;

      if (value is double) return value;
      if (value is int) return value.toDouble();

      if (value is String) {
        // Remove $ or other symbols, trim whitespace
        final cleaned = value.replaceAll(RegExp(r'[^0-9.]'), '').trim();
        return double.tryParse(cleaned) ?? 0.0;
      }

      return 0.0;
    }

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final recommended = data["recommended"] as List<dynamic>;

        List<Medicine> medicineList = [];
         for (var item in recommended) {
        medicineList.add(Medicine(
          name: item['name']?.toString() ?? 'Unknown Product',
          genericName: _cleanText(item['generic_name']),
          manufacturer: _cleanText(item['manufacturer']),
          purpose: _cleanText(item['purpose']) != '' ? _cleanText(item['purpose']) : 'OTC medication',
          uses: _cleanText(item['uses']),
          category: _cleanText(item['category']),
          route: _cleanText(item['route']),
          activeIngredient: _cleanText(item['active_ingredient']),
          dosage: _cleanText(item['dosage']) != '' ? _cleanText(item['dosage']) : 'Follow package instructions.',
          warning: _cleanText(item['warnings']) != '' 
              ? _cleanText(item['warnings']) 
              : 'Read all warnings and directions on product packaging before use.',
          symptoms: widget.symptoms,
          rating: _parseDouble(item['rating']),
          price: _parseDouble(item['price']),
          link: _cleanText(item['link']).isNotEmpty ? _cleanText(item['link']) : null,

      
        ));
      }

        setState(() {
          results = medicineList;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.statusCode}')),
          );
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(showBackButton: true),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.blue[500],
              child: const Text(
                'Recommended Medicines',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : results.isEmpty
                      ? const Center(child: Text('No medicines found'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            Medicine med = results[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                leading: const Icon(Icons.medication,
                                    size: 40, color: Colors.orange),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      med.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    if (med.rating > 0)
                                      Row(
                                        children: [
                                          const Icon(Icons.star,
                                              color: Colors.amber, size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                            med.rating.toStringAsFixed(1),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[700],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                                subtitle: Text(med.purpose),
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MedicineDetailPage(medicine: med),
                                      ),
                                    );
                                  },
                                  child: const Text('View'),
                                ),
                              ),
                            );
                          },
                        ),
            ),
            Container(
              width: double.infinity,
              color: Colors.grey[800],
              padding: const EdgeInsets.all(12),
              child: const Text(
                'Not a substitute for professional medical advice. Always consult healthcare providers.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}