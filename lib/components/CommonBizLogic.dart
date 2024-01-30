import 'package:dio/dio.dart';
import 'package:sugatiol/components/LogUtils.dart';

import '../Business/AddSugarIntake.dart';
import '../Business/GetSugarIntakeToday.dart';
import '../Business/ListSugarIntakesToday.dart';
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
      "date": "",
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


static Future<List<dynamic>> listSugarIntakesToday() async {
    try {
      String api = APIList.lightSugarAPI["listSugarIntakesToday"];
      ListSugarIntakesToday listSugarIntakesToday = ListSugarIntakesToday();
      Response response = await MyHttpRequest.instance
          .sendRequest(api, {}, listSugarIntakesToday);
      if (response.data["ack"] == "success") {
          return Future.value(response.data['list'].reversed.toList());
      } else if (response.data["ack"] == "failure") {
        return Future.error(response.data["message"]);
      }else{
        Log.instance.e("Unknown Error");
        return Future.error("Unknown Error");
      }
    } catch (e) {
      return Future.error(e);
    }
    
  }

  static getIntakeListToday() async {
    Future<List<dynamic>> tempIntakeListToday;
    tempIntakeListToday = CommonBizLogic.listSugarIntakesToday();
    TempData.intakeListToday.value = await tempIntakeListToday;
  }
}