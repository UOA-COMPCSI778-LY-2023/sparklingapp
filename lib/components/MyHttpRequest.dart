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

// class MyHttpRequest {
//   MyHttpRequest._privateConstructor();

//   static final MyHttpRequest _instance = MyHttpRequest._privateConstructor();

//   static MyHttpRequest get instance => _instance;

//   Map<String, Dio> _dios = {};

//   ValueNotifier<int> iCurMultiCount = ValueNotifier(0);
//   ValueNotifier<int> iNetWaitQueueCount = ValueNotifier(0);

//   Dio getDio(String ip) {
//     BaseOptions options = new BaseOptions(
//       // baseUrl: ip,
//       connectTimeout:
//           Duration(milliseconds: NetworkCfg.maxNetConnectionWaitTime),
//       receiveTimeout: Duration(milliseconds: NetworkCfg.maxNetRecieveWaitTime),
//     );

//     if (_dios[ip] != null) {
//       return _dios[ip]!;
//     } else {
//       Dio dio = Dio(options);
//       dio.httpClientAdapter = IOHttpClientAdapter()
//         ..onHttpClientCreate = (httpClient) =>
//             httpClient..maxConnectionsPerHost = NetworkCfg.maxMultiCastDio;
//       _dios[ip] = dio;
//       return dio;
//     }
//   }

//   Future<Map> sendFutureGetRequest<T>(String url, [int? iRety]) async {
//     Map data = {};
//     String ip = DataUtils.getIpFromUrl(url);
//     Dio dio = getDio(ip);
//     try {
//       Log.instance.i("Start HTTp GET request: ${url}");
//       iCurMultiCount.value++;
//       var response = await dio.get(
//         url,
//         options: Options(
//           headers: {
//             'accept': 'application/json',
//           },
//         ),
//       );
//       iCurMultiCount.value--;
//       // dio.httpClientAdapter.close();
//       // dio.close();
//       print(response);
//       data = response.data;
//       return Future.value(data);
//     } on DioError catch (e) {
//       iCurMultiCount.value--;
//       // dio.httpClientAdapter.close();
//       // dio.close();
//       switch (e.type) {
//         case DioErrorType.badResponse:
//           {
//             Log.instance.d(e.response);
//             if (e.response?.data["status"] == 'failure') {
//               //Product not found
//               return Future.error("Product not found");
//             } else {
//               return Future.error("Unkonwn error");
//             }
//           }
//         case DioErrorType.connectionTimeout:
//           {
//             iRety ??= 0;
//             if (iRety < NetworkCfg.maxNetConnectRetryCount) {
//               Log.instance
//                   .i("Network connection timeout,${iRety + 1}th retry:${url}");
//               return sendFutureGetRequest(url, ++iRety);
//             } else {
//               Log.instance
//                   .i("Network connection timeout,tried ${iRety} times:${url}");
//               return Future.error("Timeout");
//             }
//           }
//         case DioErrorType.receiveTimeout:
//           {
//             iRety ??= 0;
//             if (iRety < NetworkCfg.maxNetConnectRetryCount) {
//               Log.instance
//                   .i("Network receive timeout, ${iRety + 1}th retry:${url}");
//               return sendFutureGetRequest(url, ++iRety);
//             } else {
//               Log.instance
//                   .i("Network reveive timeout, tried ${iRety} times:${url}");
//               return Future.error("Timeout");
//             }
//           }
//         case DioErrorType.sendTimeout:
//           {
//             iRety ??= 0;
//             if (iRety < NetworkCfg.maxNetConnectRetryCount) {
//               Log.instance
//                   .i("Network sending timeout, ${iRety + 1}th retry:${url}");
//               return sendFutureGetRequest(url, ++iRety);
//             } else {
//               Log.instance
//                   .i("Network sending timeout, tried ${iRety} times:${url}");
//               return Future.error("Timeout");
//             }
//           }
//         default:
//           {
//             if (e.toString().contains("Too many open files")) {
//               iRety ??= 0;
//               if (iRety < NetworkCfg.maxNetMutialRetryCount) {
//                 Log.instance.i(
//                     "Too many mutialRequest, waiting for retry:${url} | ${e}");
//                 // await waitNetRestore();
//                 return sendFutureGetRequest(url, ++iRety);
//               } else {
//                 Log.instance
//                     .i("Too many mutialRequest, tried ${iRety} times:${url}");
//                 return Future.error("Too many open files");
//               }
//             } else if (e.toString().contains("Connection closed")) {
//               iRety ??= 0;
//               _dios.remove(ip);
//               Log.instance.i(
//                   "The network disconnected and rebuild connection already, waiting for retry:${url} | ${e}");
//               // await waitNetRestore();
//               return sendFutureGetRequest(url, ++iRety);
//             } else {
//               Log.instance.wtf("HTTP GET has a error ${url}：${e}");
//               return Future.error(e);
//             }
//           }
//       }
//     } on Error catch (e) {
//       iCurMultiCount.value--;
//       // dio.httpClientAdapter.close();
//       // dio.close();
//       Log.instance.wtf(e);
//       Log.instance.i("The URL：" + url);
//       Log.instance.i(e.stackTrace);
//       return Future.error(e);
//     }
//   }
// }
