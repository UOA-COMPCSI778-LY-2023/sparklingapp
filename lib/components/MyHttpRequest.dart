import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';

import '../Configuration/Global.dart';
import 'DataUtils.dart';
import 'LogUtils.dart';

class MyHttpRequest {
  static Map<String, Dio> dios = {};
  static ValueNotifier<int> iCurMultiCount = ValueNotifier(0);
  static ValueNotifier<int> iNetWaitQueueCount = ValueNotifier(0);

  static Dio getDio(String ip) {
    BaseOptions options = new BaseOptions(
      // baseUrl: ip,
      connectTimeout:
          Duration(milliseconds: NetworkCfg.maxNetConnectionWaitTime),
      receiveTimeout: Duration(milliseconds: NetworkCfg.maxNetRecieveWaitTime),
    );

    if (dios[ip] != null) {
      return dios[ip]!;
    } else {
      Dio dio = Dio(options);
      dio.httpClientAdapter = IOHttpClientAdapter()
        ..onHttpClientCreate = (httpClient) =>
            httpClient..maxConnectionsPerHost = NetworkCfg.maxMultiCastDio;
      dios[ip] = dio;
      return dio;
    }
  }

  static Future<Map> sendFutureGetRequest<T>(String url, [int? iRety]) async {
    Map data = {};
    String ip = DataUtils.getIpFromUrl(url);
    Dio dio = getDio(ip);
    try {
      Log.i("Start HTTp GET request: ${url}");
      iCurMultiCount.value++;
      var response = await dio.get(
        url,
        options: Options(
          headers: {
            'accept': 'application/json',
          },
        ),
      );
      iCurMultiCount.value--;
      // dio.httpClientAdapter.close();
      // dio.close();
      print(response);
      data = response.data;
      return Future.value(data);
    } on DioError catch (e) {
      iCurMultiCount.value--;
      // dio.httpClientAdapter.close();
      // dio.close();
      switch (e.type) {
        case DioErrorType.badResponse:
          {
            Log.d(e.response);
            if (e.response?.data["status"] == 'failure') {
              //Product not found
              return Future.error("Product not found");
            } else {
              return Future.error("Unkonwn error");
            }
          }
        case DioErrorType.connectionTimeout:
          {
            iRety ??= 0;
            if (iRety < NetworkCfg.maxNetConnectRetryCount) {
              Log.i("Network connection timeout,${iRety + 1}th retry:${url}");
              return sendFutureGetRequest(url, ++iRety);
            } else {
              Log.i("Network connection timeout,tried ${iRety} times:${url}");
              return Future.error("Timeout");
            }
          }
        case DioErrorType.receiveTimeout:
          {
            iRety ??= 0;
            if (iRety < NetworkCfg.maxNetConnectRetryCount) {
              Log.i("Network receive timeout, ${iRety + 1}th retry:${url}");
              return sendFutureGetRequest(url, ++iRety);
            } else {
              Log.i("Network reveive timeout, tried ${iRety} times:${url}");
              return Future.error("Timeout");
            }
          }
        case DioErrorType.sendTimeout:
          {
            iRety ??= 0;
            if (iRety < NetworkCfg.maxNetConnectRetryCount) {
              Log.i("Network sending timeout, ${iRety + 1}th retry:${url}");
              return sendFutureGetRequest(url, ++iRety);
            } else {
              Log.i("Network sending timeout, tried ${iRety} times:${url}");
              return Future.error("Timeout");
            }
          }
        default:
          {
            if (e.toString().contains("Too many open files")) {
              iRety ??= 0;
              if (iRety < NetworkCfg.maxNetMutialRetryCount) {
                Log.i(
                    "Too many mutialRequest, waiting for retry:${url} | ${e}");
                // await waitNetRestore();
                return sendFutureGetRequest(url, ++iRety);
              } else {
                Log.i("Too many mutialRequest, tried ${iRety} times:${url}");
                return Future.error("Too many open files");
              }
            } else if (e.toString().contains("Connection closed")) {
              iRety ??= 0;
              dios.remove(ip);
              Log.i(
                  "The network disconnected and rebuild connection already, waiting for retry:${url} | ${e}");
              // await waitNetRestore();
              return sendFutureGetRequest(url, ++iRety);
            } else {
              Log.wtf("HTTP GET has a error ${url}：${e}");
              return Future.error(e);
            }
          }
      }
    } on Error catch (e) {
      iCurMultiCount.value--;
      // dio.httpClientAdapter.close();
      // dio.close();
      Log.wtf(e);
      Log.i("The URL：" + url);
      Log.i(e.stackTrace);
      return Future.error(e);
    }
  }
}
