import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sugatiol/pages/IntakeAddConfirmPage.dart';

void main() {
  group('IntakeAddConfirmPage Widget Tests', () {
    testWidgets('IntakeAddConfirmPage displays necessary widgets',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(home: IntakeAddConfirmPage()));

      // Verify the presence of an AppBar
      expect(find.byType(AppBar), findsOneWidget);

      // Verify the presence of a CircleAvatar
      expect(find.byType(CircleAvatar), findsOneWidget);

      // Verify the presence of the confirmation Text
      expect(find.text('Sugar intake added!'), findsOneWidget);

      // Verify the presence of ElevatedButtons
      expect(find.byType(ElevatedButton), findsNWidgets(2));

      // Verify the specific buttons if needed
      expect(find.text('Return to Home'), findsOneWidget);
      expect(find.text('Continue Adding'), findsOneWidget);
    });
  });
}
