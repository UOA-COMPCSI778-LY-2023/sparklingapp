import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sugatiol/pages/StartPage.dart';

void main() {
  group('StartPage Widget Tests', () {
    testWidgets('StartPage displays necessary widgets', 
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: StartPage()));

      expect(find.text('Health & wellbeing'), findsOneWidget);
      expect(find.text('tracking made easy.'), findsOneWidget);
      expect(find.text('Get Started'), findsOneWidget);
      expect(find.text('Already tracking your sugar intake? Sign in'), findsOneWidget);

      expect(find.byType(ElevatedButton), findsOneWidget);

      expect(find.byType(TextButton), findsOneWidget);
    });
  });
}
