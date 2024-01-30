import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sugatiol/components/Toast.dart';

void main() {
  group('Toast Tests', () {
    testWidgets('Toast Display and Dismiss Test', (WidgetTester tester) async {
      const int toastDurationMs = 5000;

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  Toast.toast(context,
                      msg: "Test Message", position: ToastPostion.center);
                },
                child: Text('Show Toast'),
              ),
            );
          },
        ),
      ));

      await tester.tap(find.text('Show Toast'));
      await tester.pump();

      expect(find.text('Test Message'), findsOneWidget);

      await tester.pump(Duration(milliseconds: toastDurationMs));

      await tester.pump(Duration(milliseconds: 400));
    });
  });
}
