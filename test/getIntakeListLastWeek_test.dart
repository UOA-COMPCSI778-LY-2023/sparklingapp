import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sugatiol/Business/GetIntakeListLastWeek.dart';
import 'package:sugatiol/Configuration/APIList.dart';
import 'package:sugatiol/components/MyHttpRequest.dart';

void main() {
  group('GetIntakeListLastWeek', () {
    test(
        'GetIntakeListLastWeek.handleRequest: Correctly get last week sugar intake',
        () async {
      String api = APIList.lightSugarAPI["getIntakeListLastWeek"];
      GetIntakeListLastWeek getIntakeListLastWeek = GetIntakeListLastWeek();
      Response response = await MyHttpRequest.instance
          .sendRequest(api, {}, getIntakeListLastWeek);
      expect(response.data["ack"], equals("success"));
    });
  });
}
