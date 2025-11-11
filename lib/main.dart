import 'package:flutter/material.dart';
import 'pages/landing_page.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OTC Recs',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/landing',
      routes: {
        '/landing': (context) => const LandingPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

