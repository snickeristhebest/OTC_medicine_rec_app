import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../widgets/user_profile_dialog.dart';
import '../services/user_storage.dart';
import 'sign_in_page.dart';
import '../widgets/feature_item.dart';
import '../widgets/buildMobileLayout.dart';
import '../widgets/buildDesktopLayout.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E88E5),
              Color(0xFF26C6DA),
            ],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isDesktop = constraints.maxWidth >= 1024;
            
            if (isDesktop) {
              return const DesktopLayout();
            } else {
              return const MobileLayout();
            }
          },
        ),
      ),
    );
  }

  

  

  
}
