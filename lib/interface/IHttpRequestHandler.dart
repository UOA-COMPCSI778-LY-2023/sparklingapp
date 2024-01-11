import 'package:dio/dio.dart';

abstract class IHttpRequestHandler {
  Future<Response> handleRequest(
      Dio dio, String url, Map<String, dynamic> parameters);
}
