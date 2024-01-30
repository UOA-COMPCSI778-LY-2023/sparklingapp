import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sugatiol/pages/OneClickConfirmPage.dart';

void main() {
  group('OneClickConfirmPage Widget Tests', () {
    testWidgets('OneClickConfirmPage displays necessary widgets and message', 
        (WidgetTester tester) async {
      String testMessage = 'Test Message';

      await tester.pumpWidget(MaterialApp(home: OneClickConfirmPage(msg: testMessage)));

      expect(find.byType(AppBar), findsOneWidget);

      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);

      expect(find.text(testMessage), findsOneWidget);

      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
    });
  });
}
