import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sugatiol/Business/GetProductInfoFromOpenFood.dart';
import 'package:sugatiol/Configuration/APIList.dart';
import 'package:sugatiol/components/MyHttpRequest.dart';

void main() {
  group('GetProductInfoFromOpenFood', () {
    test(
        'GetProductInfoFromOpenFood.handleRequest: Correctly get production information from OpenFood',
        () async {
      String api = APIList.openFoodAPI["getFoodByBarcode"];
      String url = api.replaceAll('{0}', "737628064502");
      GetProductInfoFromOpenFood getProductionInfo =
          GetProductInfoFromOpenFood();
      Response response =
          await MyHttpRequest.instance.sendRequest(url, {}, getProductionInfo);
      expect(response.data["code"], equals("0737628064502"));
    });
  });
}
