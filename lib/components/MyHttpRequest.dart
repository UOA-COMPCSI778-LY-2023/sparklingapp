import 'package:dio/dio.dart';

import '../Configuration/Global.dart';
import '../interface/IHttpRequestHandler.dart';
import 'DataUtils.dart';

class MyHttpRequest {
  MyHttpRequest._privateConstructor();

  static final MyHttpRequest _instance = MyHttpRequest._privateConstructor();
  static MyHttpRequest get instance => _instance;

  Map<String, Dio> _dios = {};

  Future<Response> sendRequest(String url, Map<String, dynamic> parameters,
      IHttpRequestHandler handler) {
    String ip = DataUtils.getIpFromUrl(url);
    Dio dio = getDio(ip);
    return handler.handleRequest(dio, url, parameters);
  }

  Dio getDio(String ip) {
    BaseOptions options = BaseOptions(
      connectTimeout:
          Duration(milliseconds: NetworkCfg.maxNetConnectionWaitTime),
      receiveTimeout: Duration(milliseconds: NetworkCfg.maxNetRecieveWaitTime),
    );

    if (_dios[ip] != null) {
      return _dios[ip]!;
    } else {
      Dio dio = Dio(options);
      _dios[ip] = dio;
      return dio;
    }
  }
}
