import 'package:dio/dio.dart';

import '../components/LogUtils.dart';
import '../interface/IHttpRequestHandler.dart';

class GetProductInfoFromOpenFood implements IHttpRequestHandler {
  @override
  Future<Response> handleRequest(
      Dio dio, String url, Map<String, dynamic> parameters) async {
    try {
      DateTime beginTime = DateTime.now();
      Response response = await dio.get(url, queryParameters: parameters);
      DateTime endTime = DateTime.now();
      Log.instance.i("Get Request duration: ${endTime.difference(beginTime)}");
      return Future.value(response);
    } catch (e) {
      if (e is DioError) {
        switch (e.response?.statusCode) {
          case 400:
            {
              Log.instance.d("400 Not Found: $url");
              return Response(
                requestOptions: e.requestOptions,
                statusCode: 400,
                data: "Product not found",
              );
            }
          case 404:
            {
              Log.instance.d("404 Not Found: $url");
              return Response(
                requestOptions: e.requestOptions,
                statusCode: 404,
                data: "Product not found",
              );
            }
          default:
            {
              Log.instance.e(e.response?.data);
              Log.instance.e(e.response?.headers);
              Log.instance.e(e.response?.requestOptions);
            }
        }
      } else {
        Log.instance.d(e);
      }
      return Future.error(e);
    }
  }
}
