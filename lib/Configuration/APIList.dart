class APIList {
  static const String _ip = "172.23.46.128";
  static const String _port = "3000";
  static Map openFoodAPI = {
    "getFoodByBarcode": "https://world.openfoodfacts.org/api/v3/product/{0}",
  };
  static Map lightSugarAPI = {
    "setSugarTarget": "http://$_ip:$_port/users/sugar-intake/target",
    "getSugarTarget": "http://$_ip:$_port/users/jnz121/target",
    "getSugarIntakeToday": "http://$_ip:$_port/users/jnz121/sugar-intake-today",
    "getIntakePrediction": "http://$_ip:$_port/users/jnz121/intake-prediction",
    "addSugarIntake": "http://$_ip:$_port/users/sugar-intake/add",
    "get7daysSugar": "http://$_ip:$_port/users/jnz121/report/7",
    "getIntakeListLastWeek":
        "http://$_ip:$_port/users/jnz121/intakes-list-weekly",
    "listSugarIntakesToday":
        "http://$_ip:$_port/users/jnz121/intakes-list-today",
    "removeSugarIntake": "http://$_ip:$_port/users/sugar-intake/remove",
    "getFoodByBarcode": "http://$_ip:$_port/packaged-food/{0}",
  };
  static Map geminiPrompt = {
    "identifyFood":
        "请识别照相机里有哪些食物并给出健康建议。你的回答应该为一段话。你的一段话中，需要包括以下内容：1. 食物的类别；2. 食物的健康评分；3. 一般情况下该类食物每100g糖分含量；4. 食物的健康建议；6.你的健康建议应该围绕糖； ",
  };
}
