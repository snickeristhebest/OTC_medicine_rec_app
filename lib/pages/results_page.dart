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
          String productName = item['name']?.toString() ?? 'Unknown Product';
          String purpose = _cleanText(item['purpose']);
          String link = _cleanText(item['link']);
          String activeIngredient = _cleanText(item['active_ingredient']);
          //Handle price
          double price = 0.0;
            if (item['price'] != null) {
              if (item['price'] is num) {
                price = (item['price'] as num).toDouble();
              } else if (item['price'] is String) {
                price = double.tryParse(item['price'].replaceAll("\$", "")) ?? 0.0;
              }
            }
          // Handle rating conversion
          double rating = 0.0;
          if (item['rating'] != null) {
            if (item['rating'] is num) {
              rating = (item['rating'] as num).toDouble();
            } else if (item['rating'] is String && item['rating'] != 'N/A') {
              rating = double.tryParse(item['rating']) ?? 0.0;
            }
          }

          // Build warning text from active ingredient
          String warningText = 'Read all warnings and directions on product packaging before use.';
          if (activeIngredient.isNotEmpty) {
            warningText = '$activeIngredient\n\n$warningText';
          }

          medicineList.add(Medicine(
            name: productName,
            purpose: purpose.isNotEmpty ? purpose : 'OTC medication',
            warning: warningText,
            dosage: 'Follow package instructions. Use as directed on product label.',
            symptoms: widget.symptoms,
            rating: rating,
            link: link.isNotEmpty && link != 'N/A' ? link : null,
            price: price, 
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