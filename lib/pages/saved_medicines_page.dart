import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../services/saved_medicines.dart';
import '../widgets/app_header.dart';
import '../pages/medicine_detail_page.dart';

class SavedMedicinesPage extends StatefulWidget {
  const SavedMedicinesPage({super.key});

  @override
  State<SavedMedicinesPage> createState() => _SavedMedicinesPageState();
}

class _SavedMedicinesPageState extends State<SavedMedicinesPage> {
  @override
  Widget build(BuildContext context) {
    List<Medicine> savedMeds = SavedMedicines.getSaved();

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
                'Saved Medicines',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Expanded(
              child: savedMeds.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.bookmark_border, size: 80, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'No saved medicines yet',
                            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Save medicines to view them here',
                            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: savedMeds.length,
                      itemBuilder: (context, index) {
                        Medicine med = savedMeds[index];
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
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      SavedMedicines.toggleSave(med);
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Removed from saved'),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MedicineDetailPage(medicine: med),
                                      ),
                                    ).then((_) {
                                      setState(() {});
                                    });
                                  },
                                  child: const Text('View'),
                                ),
                              ],
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
