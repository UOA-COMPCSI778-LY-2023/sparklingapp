import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sugatiol/components/NumberAdjuster.dart';

void main() {
  group("NumberAdjuster", () {
    testWidgets(
        'Component NumberAdjuster: correctly show and increate value and minus value',
        (WidgetTester tester) async {
      int latestValue = 0;
      await tester.pumpWidget(MaterialApp(
        home: NumberAdjuster(
          minNumber: 0,
          maxNumber: 10,
          initialValue: 5,
          onValueChanged: (value) {
            latestValue = value;
          },
        ),
      ));

      expect(find.text('5'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(find.text('6'), findsOneWidget);
      expect(latestValue, 6);

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      expect(find.text('5'), findsOneWidget);
      expect(latestValue, 5);
    });
  });
}
