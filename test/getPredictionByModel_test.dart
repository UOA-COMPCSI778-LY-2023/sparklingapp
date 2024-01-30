import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sugatiol/Business/GetPredictionByModel.dart';
import 'package:sugatiol/Configuration/APIList.dart';
import 'package:sugatiol/components/MyHttpRequest.dart';

void main() {
  group('GetPredictionByModel', () {
    test(
        'GetPredictionByModel.handleRequest: Correctly get sugar intake prediction by model',
        () async {
      String api = APIList.lightSugarAPI["getPredictionbymodel"];
      GetPredictionByModel getPrediction = GetPredictionByModel();
      Response response =
          await MyHttpRequest.instance.sendRequest(api, {}, getPrediction);
      expect(response.data["ack"], equals("success"));
    });
  });
}
