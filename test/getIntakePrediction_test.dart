import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sugatiol/Business/GetIntakePrediction.dart';
import 'package:sugatiol/Configuration/APIList.dart';
import 'package:sugatiol/components/MyHttpRequest.dart';

void main() {
  group('GetIntakePrediction', () {
    test(
        'GetIntakePrediction.handleRequest: Correctly get sugar intake prediction',
        () async {
      String api = APIList.lightSugarAPI["getIntakePrediction"];
      GetIntakePrediction getPrediction = GetIntakePrediction();
      Response response =
          await MyHttpRequest.instance.sendRequest(api, {}, getPrediction);
      expect(response.data["ack"], equals("success"));
    });
  });
}
