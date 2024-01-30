import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sugatiol/Business/AddSugarIntake.dart';
import 'package:sugatiol/Configuration/APIList.dart';
import 'package:sugatiol/components/MyHttpRequest.dart';

void main() {
  group('AddSugarIntake', () {
    test('AddSugarIntake.handleRequest: Correctly add sugar intake', () async {
      Map<String, dynamic> parameters = {
        "username": "jnz121",
        "date": "",
        "code": "9417056003977",
        "serving_count": 1
      };
      String api = APIList.lightSugarAPI["addSugarIntake"];
      AddSugarIntake addSugarIntake = AddSugarIntake(parameters);
      Response response = await MyHttpRequest.instance
          .sendRequest(api, parameters, addSugarIntake);
      expect(response.data["ack"], equals("success"));
    });
  });
}
