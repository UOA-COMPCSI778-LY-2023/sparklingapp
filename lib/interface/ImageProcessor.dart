import 'package:google_mlkit_commons/google_mlkit_commons.dart';

import '../components/DetectedObject.dart';

abstract class ImageProcessor {
  Future<List<DetectedObject>> processImage(InputImage inputImage);
}
