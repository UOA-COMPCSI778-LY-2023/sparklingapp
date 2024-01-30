import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sugatiol/components/Router.dart';

void main() {
  group('MyRouter', () {
    testWidgets('MyRouter: createRoute Test', (WidgetTester tester) async {
      Widget testPage = Scaffold(
        appBar: AppBar(title: Text('Test Page')),
        body: Center(child: Text('Hello World')),
      );

      Route route = MyRouter.createRoute(testPage, "top");

      await tester.pumpWidget(
          MaterialApp(home: Navigator(onGenerateRoute: (settings) => route)));

      expect(find.text('Hello World'), findsOneWidget);

      final slideTransitionFinder = find.byType(SlideTransition);
      final SlideTransition transition = tester.widget(slideTransitionFinder);

      final Animation<Offset> position =
          transition.position as Animation<Offset>;
      expect(position.value.dy, 0.0);
      expect(position.value.dx, 0.0);
    });
  });
}
