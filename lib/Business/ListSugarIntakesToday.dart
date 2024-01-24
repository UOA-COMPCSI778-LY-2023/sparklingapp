import 'package:dio/dio.dart';

import '../components/LogUtils.dart';
import '../interface/IHttpRequestHandler.dart';

class ListSugarIntakesToday implements IHttpRequestHandler {
  @override
  Future<Response> handleRequest(
      Dio dio, String url, Map<String, dynamic> parameters) async {
    DateTime beginTime = DateTime.now();
    Response response = await dio.get(url, queryParameters: parameters);
    DateTime endTime = DateTime.now();
    Log.instance.i("Get Request duration: ${endTime.difference(beginTime)}");
    return response;
  }
}
