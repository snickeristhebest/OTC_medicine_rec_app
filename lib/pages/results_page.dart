import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../services/medicine_database.dart';
import '../services/saved_medicines.dart';
import '../widgets/app_header.dart';
import '../pages/medicine_detail_page.dart';

class ResultsPage extends StatelessWidget {
  final List<String> symptoms;

  const ResultsPage({super.key, required this.symptoms});

  @override
  Widget build(BuildContext context) {
    List<Medicine> results = MedicineDatabase.searchBySymptoms(symptoms);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button
            const AppHeader(showBackButton: true),

            // Page title
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
              child: results.isEmpty
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
                            leading: const Icon(Icons.medication, size: 40, color: Colors.orange),
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
                                      const Icon(Icons.star, color: Colors.amber, size: 16),
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
                                    builder: (context) => MedicineDetailPage(medicine: med),
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
