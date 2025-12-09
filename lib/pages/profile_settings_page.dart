import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  final _ageController = TextEditingController();
  final _tempController = TextEditingController();
  String? _selectedGender;
  bool? _isPregnant;

  @override
  void initState() {
    super.initState();
    // Pre-populate from UserProfile if available
    if (UserProfile.age != null) {
      _ageController.text = UserProfile.age.toString();
    }
    if (UserProfile.temperature != null) {
      _tempController.text = UserProfile.temperature.toString();
    }
    _selectedGender = UserProfile.gender;
    _isPregnant = UserProfile.isPregnant;
  }

  @override
  void dispose() {
    _ageController.dispose();
    _tempController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_ageController.text.isEmpty || _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in required fields (Age, Gender)'),
        ),
      );
      return;
    }

    if (_selectedGender == 'Female' && _isPregnant == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please indicate if you are pregnant')),
      );
      return;
    }

    UserProfile.age = int.tryParse(_ageController.text);
    UserProfile.gender = _selectedGender;
    UserProfile.isPregnant = _isPregnant ?? false;
    UserProfile.temperature = _tempController.text.isNotEmpty
        ? double.tryParse(_tempController.text)
        : null;

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings'),
        backgroundColor: Colors.blue[700],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Help us provide better recommendations',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Age
              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Age *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
              ),
              const SizedBox(height: 16),

              // Gender
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(
                  labelText: 'Gender *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                    if (value != 'Female') {
                      _isPregnant = false;
                    } else {
                      // leave as-is (may be null until user picks)
                      if (_isPregnant == null) _isPregnant = null;
                    }
                  });
                },
              ),
              const SizedBox(height: 16),

              // Pregnant (only for females)
              if (_selectedGender == 'Female')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Are you pregnant? *',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<bool>(
                            title: const Text('Yes'),
                            value: true,
                            groupValue: _isPregnant,
                            onChanged: (value) {
                              setState(() {
                                _isPregnant = value;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<bool>(
                            title: const Text('No'),
                            value: false,
                            groupValue: _isPregnant,
                            onChanged: (value) {
                              setState(() {
                                _isPregnant = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),

              // Temperature (optional)
              TextField(
                controller: _tempController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Temperature (°F) - Optional',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.thermostat),
                  hintText: 'e.g., 98.6',
                ),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                      ),
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
