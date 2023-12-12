import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'DateUtils.dart';

class Log {
  static ValueNotifier<List> historyInfoMsg = ValueNotifier([]);
  static ValueNotifier<List> historyErrMsg = ValueNotifier([]);

  static getLogStr(ob) {
    String logMsg = "";
    if (ob is String) {
      logMsg = ob.toString();
    } else if (ob is DioError) {
      DioError tempOb = ob as DioError;
      if (tempOb.message != null) {
        logMsg = "DioError: " + tempOb.message!;
      } else if (tempOb.error != null) {
        logMsg = "DioError: " + tempOb.error.toString()!;
      }
    } else if (ob is NoSuchMethodError) {
      logMsg = "NoSuchMethodError: " +
          (ob as NoSuchMethodError).stackTrace.toString();
    } else {
      logMsg = "unknown error: " + ob.toString();
    }
    return logMsg;
  }

  static addErrLog(msg) {
    historyErrMsg.value.add({"msg": msg, "time": DateTime.now()});
    if (historyErrMsg.value.length > 1000) {
      historyErrMsg.value.removeAt(0);
    }
    var tmp = historyErrMsg.value;
    historyErrMsg.value = [];
    historyErrMsg.value = tmp;
  }

  static addInfoLog(msg) {
    historyInfoMsg.value.add({"msg": msg, "time": DateTime.now()});
    if (historyInfoMsg.value.length > 1000) {
      historyInfoMsg.value.removeAt(0);
    }
    var tmp = historyInfoMsg.value;
    historyInfoMsg.value = [];
    historyInfoMsg.value = tmp;
  }

  /**
 * logger.v("Verbose log");
logger.d("Debug log");
logger.i("Info log");
logger.w("Warning log");
logger.e("Error log");
logger.wtf("What a terrible failure log");
 */
  static var _log = Logger();

  static var v = _log.v;
  static var d = _log.d;
  static i(msg) {
    print(MyDateUtils.formatToString(DateTime.now()) + ":" + msg);
    addInfoLog(msg);
  }

  // static var w = _log.w;
  static w(e) {
    addErrLog(e);
    _log.w(e);
  }

  //static var e = _log.e;
  static e(e) {
    addErrLog(e);
    _log.e(e);
  }

  // static var wtf = _log.wtf;
  static wtf(e) {
    addErrLog(e);
    _log.wtf(e);
  }
}
