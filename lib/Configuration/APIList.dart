class APIList {
  static const String _ip = "127.0.0.1";
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
  };
}
