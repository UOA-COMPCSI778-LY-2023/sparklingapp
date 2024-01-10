import 'package:google_mlkit_commons/google_mlkit_commons.dart';

import '../components/Object_detector.dart';

abstract class ImageProcessor {
  Future<List<DetectedObject>> processImage(InputImage inputImage);
}
