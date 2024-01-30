import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sugatiol/pages/IntakeLimitEditPage.dart';

void main() {
  group('IntakeLimitEditPage Widget Tests', () {
    testWidgets('IntakeLimitEditPage displays necessary widgets', 
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: IntakeLimitEditPage(sugarTarget: 50)));

      expect(find.byType(AppBar), findsOneWidget);

      expect(find.byType(TextField), findsOneWidget);

      expect(find.byType(ElevatedButton), findsOneWidget);

      expect(find.text('New Daily Sugar Intake Limit'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
      
      expect(find.byIcon(Icons.edit), findsOneWidget);
    });
  });
}
