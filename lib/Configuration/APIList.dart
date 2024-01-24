class APIList {
  static const String _ip = "172.23.59.18";
  static Map openFoodAPI = {
    "getFoodByBarcode": "https://world.openfoodfacts.org/api/v3/product/{0}",
  };
  static Map lightSugarAPI = {
    "setSugarTarget": "http://$_ip:3000/users/sugar-intake/target",
    "getSugarTarget": "http://$_ip:3000/users/jnz121/target",
    "getSugarIntakeToday": "http://$_ip:3000/users/jnz121/sugar-intake-today",
    "getIntakePrediction": "http://$_ip:3000/users/jnz121/intake-prediction",
    "addSugarIntake": "http://$_ip:3000/users/sugar-intake/add",
    "getIntakeListLastWeek": "http://$_ip:3000/users/jnz121/intakes-list-weekly",
    "listSugarIntakesToday": "http://$_ip:3000/users/jnz121/intakes-list-today",
    "removeSugarIntake": "http://$_ip:3000/users/sugar-intake/remove",
  };
}
