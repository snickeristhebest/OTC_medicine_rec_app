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

  // New symptom categories schema
  final Map<String, Map<String, String>> symptomCategories = {
    'Sleep & Relax': {
      'fatigue': 'Fatigue',
      'sleep': 'Sleep Issues',
    },
    'Digestive': {
      'stomach_upset': 'Stomach Upset',
      'constipation': 'Constipation',
      'diarrhea': 'Diarrhea',
    },
    'Pain & Fever': {
      'general_pain': 'General Pain',
      'muscle_joint': 'Muscle & Joint Pain',
      'fever': 'Fever',
    },
    'Cold & Flu': {
      'throat': 'Sore Throat',
      'respiratory': 'Respiratory Issues',
      'cold': 'Cold & Cough',
      'flu': 'Flu',
    },
    'Skin': {
      'irritation': 'Skin Irritation',
      'rash': 'Rash',
      'acne': 'Acne',
    },
    'Sunscreen': {
      'sun_protection': 'Sun Protection',
    },
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

  Map<String, Map<String, String>> getFilteredCategories() {
    if (searchQuery.isEmpty) {
      return symptomCategories;
    }

    Map<String, Map<String, String>> filtered = {};

    symptomCategories.forEach((category, symptoms) {
      Map<String, String> matchingSymptoms = {};
      
      symptoms.forEach((key, displayName) {
        if (displayName.toLowerCase().contains(searchQuery.toLowerCase()) ||
            key.toLowerCase().contains(searchQuery.toLowerCase())) {
          matchingSymptoms[key] = displayName;
        }
      });

      if (matchingSymptoms.isNotEmpty) {
        filtered[category] = matchingSymptoms;
      }
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Map<String, String>> filteredCategories = getFilteredCategories();

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
                      children: selectedSymptoms.map((symptomKey) {
                        // Find display name for the symptom key
                        String displayName = symptomKey;
                        symptomCategories.forEach((category, symptoms) {
                          if (symptoms.containsKey(symptomKey)) {
                            displayName = symptoms[symptomKey]!;
                          }
                        });
                        
                        return Chip(
                          label: Text(displayName),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: () => toggleSymptom(symptomKey),
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
                              children: entry.value.entries.map((symptom) {
                                String symptomKey = symptom.key;
                                String displayName = symptom.value;
                                bool isSelected = selectedSymptoms.contains(symptomKey);
                                
                                return GestureDetector(
                                  onTap: () => toggleSymptom(symptomKey),
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
                                      displayName,
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