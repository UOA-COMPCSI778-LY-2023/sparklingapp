import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sugatiol/Business/ListSugarIntakesToday.dart';
import 'package:sugatiol/Configuration/APIList.dart';
import 'package:sugatiol/components/MyHttpRequest.dart';

void main() {
  group('ListSugarIntakesToday', () {
    test(
        'ListSugarIntakesToday.handleRequest: Correctly get today sugar intakes',
        () async {
      String api = APIList.lightSugarAPI["listSugarIntakesToday"];
      ListSugarIntakesToday getIntakes = ListSugarIntakesToday();
      Response response =
          await MyHttpRequest.instance.sendRequest(api, {}, getIntakes);
      expect(response.data["ack"], equals("success"));
    });
  });
}
