import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:sugatiol/components/DetectedObject.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ObjectDetector', () {
    const MethodChannel channel = MethodChannel('google_mlkit_object_detector');

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        if (methodCall.method == 'vision#startObjectDetector') {
          return [
            {
              'rect': {'left': 0.0, 'top': 0.0, 'right': 0.5, 'bottom': 0.5},
              'labels': [
                {'confidence': 0.9, 'index': 1, 'text': 'mockLabel'}
              ],
              'trackingId': 123
            }
          ];
        }
        return null;
      });
    });

    tearDown(() {
      channel.setMockMethodCallHandler(null);
    });

    test('ObjectDetector: processImage Test', () async {
      final detector = ObjectDetector(
          options: ObjectDetectorOptions(
        mode: DetectionMode.single,
        classifyObjects: true,
        multipleObjects: true,
      ));
      final inputImage = InputImage.fromFilePath('path/to/image');
      final objects = await detector.processImage(inputImage);
      expect(objects, isNotEmpty);
      expect(objects.first.trackingId, 123);
      expect(objects.first.labels.first.text, 'mockLabel');
    });
  });
}
