import 'package:dio/dio.dart';

import '../interface/IHttpRequestHandler.dart';

class GetProductInfoFromOpenFood implements IHttpRequestHandler {
  @override
  Future<Response> handleRequest(
      Dio dio, String url, Map<String, dynamic> parameters) async {
    DateTime beginTime = DateTime.now();
    Response response = await dio.get(url, queryParameters: parameters);
    DateTime endTime = DateTime.now();
    print("Request duration: ${endTime.difference(beginTime)}");
    return response;
  }
}
