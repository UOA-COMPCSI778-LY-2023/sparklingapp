import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sugatiol/Business/AddSugarIntake.dart';
import 'package:sugatiol/Business/ListSugarIntakesToday.dart';
import 'package:sugatiol/Business/RemoveSugarIntake.dart';
import 'package:sugatiol/Configuration/APIList.dart';
import 'package:sugatiol/components/MyHttpRequest.dart';

void main() {
  group('RemoveSugarIntake', () {
    test('RemoveSugarIntake.handleRequest: Correctly get daily sugar target',
        () async {
      Map<String, dynamic> parametersAddSugar = {
        "username": "jnz121",
        "date": "",
        "code": "9417056003977",
        "serving_count": 1
      };
      String apiAddSugar = APIList.lightSugarAPI["addSugarIntake"];
      AddSugarIntake addSugarIntake = AddSugarIntake(parametersAddSugar);
      Response response = await MyHttpRequest.instance
          .sendRequest(apiAddSugar, parametersAddSugar, addSugarIntake);

      String apiGetList = APIList.lightSugarAPI["listSugarIntakesToday"];
      ListSugarIntakesToday getIntakes = ListSugarIntakesToday();
      response =
          await MyHttpRequest.instance.sendRequest(apiGetList, {}, getIntakes);
      String recordId = response.data["list"]["_id"].toString();

      String api = APIList.lightSugarAPI["removeSugarIntake"];
      Map<String, dynamic> parameters = {
        "username": "jnz121",
        "record_id": recordId
      };
      RemoveSugarIntake removeIntake = RemoveSugarIntake(parameters);
      response =
          await MyHttpRequest.instance.sendRequest(api, {}, removeIntake);
      expect(response.data["ack"], equals("success"));
    });
  });
}
