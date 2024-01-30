import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sugatiol/pages/IntakeGoalConfirmPage.dart';

void main() {
  group('IntakeGoalConfirmPage Widget Tests', () {
    testWidgets('IntakeGoalConfirmPage displays necessary widgets',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: IntakeGoalConfirmPage()));

      expect(find.byType(AppBar), findsOneWidget);

      expect(find.byType(CircleAvatar), findsOneWidget);

      expect(find.text('Sugar Intake Goal\nhas been set!'), findsOneWidget);

      expect(find.byType(ElevatedButton), findsOneWidget);

      expect(find.text('OK'), findsOneWidget);
    });
  });
}
