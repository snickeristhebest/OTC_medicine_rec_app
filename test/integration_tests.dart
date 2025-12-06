import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otc_recs/main.dart';

void main() {
  group('Integration Tests', () {
    testWidgets(
      'MyApp should render without errors',
      (WidgetTester tester) async {
        // Build our app and trigger a frame.
        await tester.pumpWidget(const MyApp());
        
        // Verify that the app renders
        expect(find.byType(MaterialApp), findsOneWidget);
      },
    );

    testWidgets(
      'LandingPage should display correctly',
      (WidgetTester tester) async {
        // TODO: Implement landing page test
      },
      skip: true,
    );
  });
}
