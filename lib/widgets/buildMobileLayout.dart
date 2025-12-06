import 'package:flutter/material.dart';
import '../pages/sign_in_page.dart';
import 'feature_item.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 320,
        constraints: const BoxConstraints(minHeight: 500, maxHeight: 640),
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E88E5),
              Color(0xFF26C6DA),
            ],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Camera/notch indicator
            Positioned(
              top: 10,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            // Main content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  // Logo and title section
                  Column(
                    children: [
                      // Stethoscope icon container
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.medical_services,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // App title
                      const Text(
                        'OTCRecs',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 2,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Feature items
                  Column(
                    children: [
                      MobileFeatureItem(
                        icon: Icons.search,
                        title: 'Find medicines for your',
                        subtitle: 'symptoms',
                      ),
                      const SizedBox(height: 10),
                      MobileFeatureItem(
                        icon: Icons.healing,
                        title: 'Check medicine',
                        subtitle: 'compatibility',
                      ),
                      const SizedBox(height: 10),
                      MobileFeatureItem(
                        icon: Icons.info_outline,
                        title: 'Learn about precautions',
                        subtitle: '',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Get Started button
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1E88E5),
                        elevation: 4,
                        shadowColor: Colors.white.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Disclaimer
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      'Not a substitute for professional medical advice.\nAlways consult healthcare providers.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white70,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}