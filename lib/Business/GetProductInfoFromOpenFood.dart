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
      return response;
    } catch (e) {
      if (e is DioError) {
        Log.instance.d(e.response?.data);
        Log.instance.d(e.response?.headers);
        Log.instance.d(e.response?.requestOptions);
      } else {
        Log.instance.d(e);
      }
      throw e;
    }
  }
}
