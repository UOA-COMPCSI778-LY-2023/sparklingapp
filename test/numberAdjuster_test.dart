import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sugatiol/components/NumberAdjuster.dart';

void main() {
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

    // 验证初始值
    expect(find.text('5'), findsOneWidget);

    // 测试增加按钮
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump(); // 重新构建widget
    expect(find.text('6'), findsOneWidget);
    expect(latestValue, 6);

    // 测试减少按钮
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump(); // 重新构建widget
    expect(find.text('5'), findsOneWidget);
    expect(latestValue, 5);
  });
}
