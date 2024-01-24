import 'package:dio/dio.dart';

import '../Business/AddSugarIntake.dart';
import '../Business/GetSugarIntakeToday.dart';
import '../Configuration/APIList.dart';
import '../Configuration/Global.dart';
import 'MyHttpRequest.dart';

class CommonBizLogic {
  static Future<void> getSugarIntakeToday() async {
    try {
      String api = APIList.lightSugarAPI["getSugarIntakeToday"];
      GetSugarIntakeToday getSugarIntakeToday = GetSugarIntakeToday();
      Response response = await MyHttpRequest.instance
          .sendRequest(api, {}, getSugarIntakeToday);

      if (response.data["ack"] == "success") {
        double sugarToday = (response.data['sugarToday'] as num).toDouble();
        TempData.todaySugarIntakeTotal.value = sugarToday;
      } else if (response.data["ack"] == "failure") {
        throw (response.data["message"]);
      }
    } catch (e) {
      throw e;
    }
  }

  static Future<void> addSugarIntake(String code, int servingCount) async {
    Map<String, dynamic> parameters = {
      "username": "jnz121",
      "date": DateTime.now().toIso8601String(),
      "code": code,
      "serving_count": servingCount
    };

    try {
      String api = APIList.lightSugarAPI["addSugarIntake"];
      AddSugarIntake addSugarIntake = AddSugarIntake(parameters);
      Response response = await MyHttpRequest.instance
          .sendRequest(api, parameters, addSugarIntake);

      if (response.data["ack"] == "success") {
        await getSugarIntakeToday();
      } else if (response.data["ack"] == "failure") {
        throw (response.data["message"]);
      }
    } catch (e) {
      throw e;
    }
  }
}