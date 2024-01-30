import 'package:flutter_test/flutter_test.dart';
import 'package:sugatiol/Business/GetProductInfoFromOpenFood.dart';
import 'package:sugatiol/Configuration/APIList.dart';
import 'package:sugatiol/components/MyHttpRequest.dart';
import 'package:sugatiol/interface/IHttpRequestHandler.dart';

void main() {
  group('MyHttpRequest', () {
    late MyHttpRequest myHttpRequest;
    late IHttpRequestHandler simpleHandler;

    setUp(() {
      myHttpRequest = MyHttpRequest.instance;
      simpleHandler = GetProductInfoFromOpenFood();
    });

    test('sendRequest returns expected Response', () async {
      final Map<String, dynamic> testParams = {};
      String api = APIList.openFoodAPI["getFoodByBarcode"];
      String testUrl = api.replaceAll('{0}', "737628064502");
      // 调用 sendRequest 并获取结果
      final result =
          await myHttpRequest.sendRequest(testUrl, testParams, simpleHandler);

      // 验证返回的 Response 是否符合预期
      expect(result.data["code"], equals("0737628064502"));
    });
  });
}
