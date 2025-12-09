import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../widgets/app_header.dart';
import '../pages/profile_settings_page.dart';
import '../pages/results_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> selectedSymptoms = [];
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  final Map<String, List<String>> symptomCategories = {
    'Pain & Fever': [
      'headache',
      'muscle aches',
      'back pain',
      'joint pain',
      'fever',
    ],
    'Cold & Allergy': [
      'runny nose',
      'itchy eyes',
      'sneezing',
      'nasal congestion',
      'sinus pressure',
    ],
    'Cough & Chest': ['cough', 'dry cough', 'wet cough', 'chest tightness'],
    'Digestive': ['heartburn', 'nausea', 'diarrhea', 'upset stomach'],
  };

  @override
  void initState() {
    super.initState();
    // Show profile dialog if not complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!UserProfile.isComplete()) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileSettingsPage()),
        );
      }
    });
  }

  void toggleSymptom(String symptom) {
    setState(() {
      if (selectedSymptoms.contains(symptom)) {
        selectedSymptoms.remove(symptom);
      } else {
        selectedSymptoms.add(symptom);
      }
    });
  }

  void searchMedicines() {
    if (selectedSymptoms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one symptom')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsPage(symptoms: selectedSymptoms),
      ),
    );
  }

  Map<String, List<String>> getFilteredCategories() {
    if (searchQuery.isEmpty) {
      return symptomCategories;
    }

    Map<String, List<String>> filtered = {};

    symptomCategories.forEach((category, symptoms) {
      List<String> matchingSymptoms = symptoms.where((symptom) {
        return symptom.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();

      if (matchingSymptoms.isNotEmpty) {
        filtered[category] = matchingSymptoms;
      }
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<String>> filteredCategories = getFilteredCategories();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            const AppHeader(showBackButton: false),

            // User Info Banner (if profile is complete)
            if (UserProfile.isComplete())
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Colors.blue[50],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      'Age: ${UserProfile.age} | ${UserProfile.gender}${UserProfile.temperature != null ? " | Temp: ${UserProfile.temperature}°F" : ""}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

            // Search Bar
            Container(
              color: Colors.blue[500],
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search symptoms...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: searchMedicines,
                    child: const Text('Search'),
                  ),
                ],
              ),
            ),

            // Selected Symptoms
            if (selectedSymptoms.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey[100],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selected Symptoms',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: selectedSymptoms.map((symptom) {
                        return Chip(
                          label: Text(symptom),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: () => toggleSymptom(symptom),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

            // Symptom Categories
            Expanded(
              child: filteredCategories.isEmpty
                  ? Center(
                      child: Text(
                        'No symptoms match "$searchQuery"',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: filteredCategories.entries.map((entry) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.key,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: entry.value.map((symptom) {
                                bool isSelected = selectedSymptoms.contains(
                                  symptom,
                                );
                                return GestureDetector(
                                  onTap: () => toggleSymptom(symptom),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.blue[700]
                                          : Colors.white,
                                      border: Border.all(
                                        color: Colors.blue[700]!,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      symptom,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.blue[700],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      }).toList(),
                    ),
            ),

            // Find Medicines Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: searchMedicines,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Find Medicines',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

            // Footer
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
