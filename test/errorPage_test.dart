import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sugatiol/pages/ErrorPage.dart';

void main() {
  group('ErrorPage Widget Tests', () {
    testWidgets('ErrorPage displays necessary widgets and error message',
        (WidgetTester tester) async {
      String testErrorMessage = 'Test Error Message';

      await tester.pumpWidget(MaterialApp(home: ErrorPage(errorMessage: testErrorMessage)));

      expect(find.byType(AppBar), findsOneWidget);

      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);

      expect(find.text(testErrorMessage), findsOneWidget);

      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Back to home'), findsOneWidget);
    });
  });
}
