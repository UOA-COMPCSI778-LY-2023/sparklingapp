import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sugatiol/components/Button.dart';

void main() {
  group('Button', () {
    test('Factory Instantiation and Method Returns', () {
      CustomFloatingActionButtonFactory factory =
          CustomFloatingActionButtonFactory(
              FloatingActionButtonLocation.endFloat, 10.0, 20.0);

      expect(factory, isNotNull);
      expect(
          factory.createLocation(), isA<CustomFloatingActionButtonLocation>());
      expect(factory.createAnimator(), isA<scalingAnimation>());
    });

    testWidgets('CustomFloatingActionButtonLocation Offset Calculation',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          floatingActionButton: FloatingActionButton(onPressed: () {}),
          floatingActionButtonLocation: CustomFloatingActionButtonFactory(
                  FloatingActionButtonLocation.endFloat, 10.0, 20.0)
              .createLocation(),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    test('scalingAnimation Animation Test', () {
      scalingAnimation animation = scalingAnimation();
      Offset begin = Offset.zero;
      Offset end = Offset(10, 10);
      double progress = 0.5;

      Offset result =
          animation.getOffset(begin: begin, end: end, progress: progress);
      expect(result, Offset(5, 5));

      AnimationController controller = AnimationController(
        vsync: TestVSync(),
        duration: const Duration(seconds: 1),
      );
      Animation<double> scaleAnimation =
          animation.getScaleAnimation(parent: controller);
      expect(scaleAnimation.value, 1.0);

      Animation<double> rotationAnimation =
          animation.getRotationAnimation(parent: controller);
      expect(rotationAnimation.value, 1.0);
    });
  });
}
