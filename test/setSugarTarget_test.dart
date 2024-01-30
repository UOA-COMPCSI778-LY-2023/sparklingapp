import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sugatiol/Business/AddSugarIntake.dart';
import 'package:sugatiol/Business/SetSugarTarget.dart';
import 'package:sugatiol/Configuration/APIList.dart';
import 'package:sugatiol/components/MyHttpRequest.dart';

void main() {
  group('SetSugarTarget', () {
    test('SetSugarTarget.handleRequest: Correctly set sugar intake target',
        () async {
      Map<String, dynamic> parameters = {
        "username": "jnz121",
        "sugarTarget": 300 //int.parse(_controller.text)
      };
      String api = APIList.lightSugarAPI["setSugarTarget"];
      SetSugarTarget setSugarTarget = SetSugarTarget(parameters);

      Response response = await MyHttpRequest.instance
          .sendRequest(api, parameters, setSugarTarget);
      expect(response.data["ack"], equals("success"));
    });
  });
}
