import 'package:dio/dio.dart';

import '../components/LogUtils.dart';
import '../interface/IHttpRequestHandler.dart';

class AddSugarIntake implements IHttpRequestHandler {
  final Map<String, dynamic> parameters;

  AddSugarIntake(this.parameters);
  
  @override
  Future<Response> handleRequest(
      Dio dio, String url, Map<String, dynamic> parameters) async {
    DateTime beginTime = DateTime.now();
    Response response = await dio.post(url, data: parameters);
    DateTime endTime = DateTime.now();
    Log.instance.i("Post Request duration: ${endTime.difference(beginTime)}");
    return response;
  }
}
