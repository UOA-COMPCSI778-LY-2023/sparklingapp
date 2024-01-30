import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sugatiol/Business/Get7DaysAverage.dart';
import 'package:sugatiol/Configuration/APIList.dart';
import 'package:sugatiol/components/MyHttpRequest.dart';

void main() {
  group('Get7DaysAverage', () {
    test('Get7DaysAverage.handleRequest: Correctly get 7 days average sugar',
        () async {
      String api = APIList.lightSugarAPI["get7daysSugar"];
      Get7DaysAverage get7 = Get7DaysAverage();
      Response response =
          await MyHttpRequest.instance.sendRequest(api, {}, get7);
      expect(response.data["ack"], equals("success"));
    });
  });
}
