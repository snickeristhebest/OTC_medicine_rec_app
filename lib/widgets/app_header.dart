import 'package:flutter/material.dart';
import '../services/saved_medicines.dart';
import '../pages/home_page.dart';
import '../pages/saved_medicines_page.dart';
import '../models/user_profile.dart';
import 'user_profile_dialog.dart';
import '../pages/landing_page.dart';

class AppHeader extends StatelessWidget {
  final bool showBackButton;
  
  const AppHeader({super.key, this.showBackButton = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[700],
      ),
      child: Row(
        children: [
          if (showBackButton)
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          // Home button
          if (!showBackButton)
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white, size: 28),
              tooltip: 'Home',
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false,
                );
              },
            ),
          // Logo and Title centered
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue[300],
                  child: const Icon(Icons.medical_services, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Text(
                  'OTC Recs',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Cart button
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart, color: Colors.white, size: 28),
                if (SavedMedicines.getSaved().isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${SavedMedicines.getSaved().length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SavedMedicinesPage(),
                ),
              );
            },
          ),
          // Profile button
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white, size: 28),
            tooltip: 'Profile',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const UserProfileDialog(),
              );
            },
          ),
          // Logout button
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white, size: 28),
            tooltip: 'Logout',
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          UserProfile.clear();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LandingPage(),
                            ),
                            (route) => false,
                          );
                        },
                        child: const Text('Logout', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
