import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/medicine.dart';
import '../services/saved_medicines.dart';
import '../widgets/app_header.dart';

class MedicineDetailPage extends StatefulWidget {
  final Medicine medicine;

  const MedicineDetailPage({super.key, required this.medicine});

  @override
  State<MedicineDetailPage> createState() => _MedicineDetailPageState();
}

class _MedicineDetailPageState extends State<MedicineDetailPage> {
  Future<void> _launchURL() async {
    if (widget.medicine.link != null && widget.medicine.link!.isNotEmpty) {
      final Uri url = Uri.parse(widget.medicine.link!);
      try {
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Could not open link'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error opening link: $e'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSaved = SavedMedicines.isSaved(widget.medicine);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(showBackButton: true),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.blue[500],
              child: Text(
                widget.medicine.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.medication,
                          size: 100,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Rating Display
                    if (widget.medicine.rating > 0)
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.amber[200]!),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 28),
                              const SizedBox(width: 8),
                              Text(
                                widget.medicine.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                '/ 5.0',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    
                    _buildInfoSection('Purpose', widget.medicine.purpose),
                    _buildInfoSection('Price', '\$${widget.medicine.price.toStringAsFixed(2)}'),
                    _buildInfoSection('Warning', widget.medicine.warning),
                    _buildInfoSection('Dosage', widget.medicine.dosage),
                    
                    // Product Link - Show clickable link
                    if (widget.medicine.link != null && widget.medicine.link!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Product Website',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: _launchURL,
                            child: Text(
                              widget.medicine.link!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    
                    const SizedBox(height: 24),
                    
                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              SavedMedicines.toggleSave(widget.medicine);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  SavedMedicines.isSaved(widget.medicine) 
                                      ? 'Saved!' 
                                      : 'Removed from saved'
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
                          label: Text(isSaved ? 'Saved' : 'Save'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSaved ? Colors.green : Colors.blue[700],
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                          ),
                        ),
                        if (widget.medicine.link != null && widget.medicine.link!.isNotEmpty) ...[
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: _launchURL,
                            icon: const Icon(Icons.open_in_new),
                            label: const Text('Visit Link'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[700],
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
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

  Widget _buildInfoSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}