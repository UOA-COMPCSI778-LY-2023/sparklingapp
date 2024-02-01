import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import '../Configuration/Global.dart';
import '../interface/IHttpRequestHandler.dart';
import 'DataUtils.dart';
import 'LogUtils.dart';

class MyHttpRequest {
  MyHttpRequest._privateConstructor();

  static final MyHttpRequest _instance = MyHttpRequest._privateConstructor();
  static MyHttpRequest get instance => _instance;

  Map<String, Dio> _dios = {};

  Future<Response> sendRequest(String url, Map<String, dynamic> parameters,
      IHttpRequestHandler handler) {
    try {
      String ip = DataUtils.getIpFromUrl(url);
      Dio dio = getDio(ip);

      // dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      //   Log.instance
      //       .d("send request：path:${options.path}，data:${options.data}");
      //   // return handler.next(options); //continue
      // }, onResponse: (response, handler) {
      //   Log.instance.d("received response：data:${response.data}");
      //   // return handler.next(response); // continue
      // }, onError: (DioError e, handler) {
      //   Log.instance.d("request error：message:${e.message}");
      //   // return handler.next(e); //continue
      // }));

      return handler.handleRequest(dio, url, parameters);
    } catch (e) {
      Log.instance.wtf(e);
      return Future.error(e);
    }
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
      dio.httpClientAdapter = IOHttpClientAdapter()
        ..onHttpClientCreate =
            (httpClient) => httpClient..maxConnectionsPerHost = 10;
      _dios[ip] = dio;
      return dio;
    }
  }
}
