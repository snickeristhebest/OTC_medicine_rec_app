import 'package:flutter/material.dart';
import '../pages/results_page.dart';

class ApiTestPage extends StatelessWidget {
  const ApiTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("OTC API Test")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to ResultsPage with test symptoms
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ResultsPage(
                  symptoms: ['cough'],
                ),
              ),
            );
          },
          child: const Text("Test API with Cough Symptom"),
        ),
      ),
    );
  }
}