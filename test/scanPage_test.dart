import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sugatiol/components/barcode/detector_view.dart';
import 'package:sugatiol/pages/ScanPage.dart';

void main() {
  testWidgets('ScanPage loads and displays its UI elements', (WidgetTester tester) async {

    await tester.pumpWidget(MaterialApp(home: ScanPage()));

    expect(find.text("Scan Barcode"), findsOneWidget);

    expect(find.byType(DetectorView), findsOneWidget);

  });
}
