import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sugatiol/components/CustomBarChat.dart';

void main() {
  group('CustomBarChart', () {
    testWidgets('CustomBarChart: Bar Chart Rendering and Property Validation',
        (WidgetTester tester) async {
      // 创建模拟数据
      List<double> mockData = [50.0, 100.0, 150.0, 75, 12, 85, 102];
      List<String> mockLabels = [
        "mon",
        "tue",
        "wed",
        "thu",
        "fri",
        "stu",
        "sun"
      ];
      String mockTitle = "Title";
      String mockSubTitle = "SubTitle";

      // 构建CustomBarChart控件
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CustomBarChart(
            data: mockData,
            labels: mockLabels,
            title: mockTitle,
            subTitle: mockSubTitle,
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.grey),
          ),
        ),
      ));

      // 检查控件是否被渲染
      expect(find.byType(CustomBarChart), findsOneWidget);

      // 检查布局属性
      final Container container = tester.widget(find.byType(Container));
      expect(container.padding, EdgeInsets.all(8));
      expect(container.margin, EdgeInsets.all(8));
      expect(container.decoration, isA<BoxDecoration>());
    });
  });
}
