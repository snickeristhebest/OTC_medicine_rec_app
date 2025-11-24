import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiTestPage extends StatefulWidget {
  const ApiTestPage({super.key});

  @override
  _ApiTestPageState createState() => _ApiTestPageState();
}

class _ApiTestPageState extends State<ApiTestPage> {
  String resultText = "Press the button to call the API";

  Future<void> testApi() async {
    final url = Uri.parse(
      "https://luckygamer02-otc-medicine-api.hf.space/api/recommend",
    );

    final body = jsonEncode({
      "symptoms": "cough",
      "age": 21,
      "pregnant": true,
      "breastfeeding": false,
      "top_k": 5,
    });

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final recommended = data["recommended"] as List;
      final notRecommended = data["not_recommended"] as List;

      String formatted = "";

      formatted += "PATIENT 1: cough\n";
      formatted += "Age: 21 years | Pregnant: True | Breastfeeding: False\n";
      formatted += "=" * 80 + "\n\n";

      formatted += "🔍 Relevant categories for 'cough': ['cold_flu']\n";
      formatted +=
          "📊 Filtered to ${recommended.length + notRecommended.length} products in relevant categories\n\n";

      formatted += "✅ RECOMMENDED PRODUCTS:\n\n";

      for (int i = 0; i < recommended.length; i++) {
        final item = recommended[i];
        formatted +=
            "  ${i + 1}. ${item['name']}\n"
            "     Purpose: ${item['purpose']}\n"
            "     Category: ${item['category']}\n"
            "     Rating: ${item['rating']} ⭐\n"
            "     Relevance Score: ${item['relevance_score']}\n"
            "     Link: ${item['link'] ?? 'N/A'}\n\n";
      }

      formatted += "⚠️ NOT RECOMMENDED PRODUCTS:\n\n";

      for (int i = 0; i < notRecommended.length; i++) {
        final item = notRecommended[i];
        formatted +=
            "  ${i + 1}. ${item['name']}\n"
            "     Purpose: ${item['purpose']}\n"
            "     ⚠️ Reason: ${item['contraindication_reason']}\n"
            "     Relevance Score: ${item['relevance_score']}\n"
            "     Link: ${item['link'] ?? 'N/A'}\n\n";
      }

      setState(() {
        resultText = formatted;
      });
    } else {
      setState(() {
        resultText = "Error: ${response.statusCode}\n${response.body}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("OTC API Test")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: testApi,
                child: const Text("Send API Request"),
              ),
              const SizedBox(height: 20),

              SelectableText(
                resultText,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: "monospace",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
