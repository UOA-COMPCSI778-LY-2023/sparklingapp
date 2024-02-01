class APIList {
  static const String _ip = "54.153.236.50";
  // static const String _ip = "172.23.89.162";
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
    "getPredictionbymodel":
        "http://$_ip:$_port/users/jnz121/intake-model-prediction",
    "getFoodByBarcode": "http://$_ip:$_port/packaged-food/{0}",
  };
  static Map geminiPrompt = {
    "identifyFood":
        "Identify what foods are in the camera and give health advice. Your answer should be a paragraph. Your paragraph needs to include the following: 1. the food group; 2. the health score of the food; 3. the amount of sugar per 100g of that food group in general; 4. the health advice for the food; and 6. your health advice should be centred around sugar;",
  };
}
