class APIList {
  static const String _backendServiceIp = "172.23.60.144";
  static Map openFoodAPI = {
    "getFoodByBarcode": "https://world.openfoodfacts.org/api/v3/product/{0}",
  };
  static Map lightSugarAPI = {
    "setSugarTarget": "http://$_backendServiceIp:3000/users/sugar-intake/target",
    "getSugarTarget": "http://$_backendServiceIp:3000/users/jnz121/target",
    "getSugarIntakeToday": "http://$_backendServiceIp:3000/users/jnz121/sugar-intake-today",
    "getIntakePrediction": "http://$_backendServiceIp:3000/users/jnz121/intake-prediction",
    "addSugarIntake": "http://$_backendServiceIp:3000/users/sugar-intake/add"
  };
}
