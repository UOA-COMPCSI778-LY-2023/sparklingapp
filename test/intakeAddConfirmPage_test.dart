import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sugatiol/pages/IntakeAddConfirmPage.dart';

void main() {
  group('IntakeAddConfirmPage Widget Tests', () {
    testWidgets('IntakeAddConfirmPage displays necessary widgets',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: IntakeAddConfirmPage()));

      expect(find.byType(AppBar), findsOneWidget);

      expect(find.byType(CircleAvatar), findsOneWidget);

      expect(find.text('Sugar intake added!'), findsOneWidget);

      expect(find.byType(ElevatedButton), findsNWidgets(2));

      expect(find.text('Return to Home'), findsOneWidget);
      expect(find.text('Continue Adding'), findsOneWidget);
    });
  });
}
