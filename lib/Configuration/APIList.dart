class APIList {
  static const String _ip = "127.0.0.1";
  static Map openFoodAPI = {
    "getFoodByBarcode": "https://world.openfoodfacts.org/api/v3/product/{0}",
  };
  static Map lightSugarAPI = {
    "setSugarTarget": "http://$_ip:3000/users/sugar-intake/target",
    "getSugarTarget": "http://$_ip:3000/users/jnz121/target",
    "getSugarIntakeToday": "http://$_ip:3000/users/jnz121/sugar-intake-today",
  };
}
