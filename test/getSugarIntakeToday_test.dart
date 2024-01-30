import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sugatiol/Business/GetSugarTarget.dart';
import 'package:sugatiol/Configuration/APIList.dart';
import 'package:sugatiol/components/MyHttpRequest.dart';

void main() {
  group('GetSugarIntakeToday', () {
    test('GetSugarIntakeToday.handleRequest: Correctly get today sugar target',
        () async {
      String api = APIList.lightSugarAPI["getSugarIntakeToday"];
      GetSugarTarget getTarget = GetSugarTarget();
      Response response =
          await MyHttpRequest.instance.sendRequest(api, {}, getTarget);
      expect(response.data["ack"], equals("success"));
    });
  });
}
