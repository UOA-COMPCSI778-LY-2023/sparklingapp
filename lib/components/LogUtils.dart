import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'DateUtils.dart';

class Log {
  Log._privateConstructor();

  static final Log _instance = Log._privateConstructor();

  static Log get instance => _instance;

  ValueNotifier<List> historyInfoMsg = ValueNotifier([]);
  ValueNotifier<List> historyErrMsg = ValueNotifier([]);

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

  addErrLog(msg) {
    historyErrMsg.value.add({"msg": msg, "time": DateTime.now()});
    if (historyErrMsg.value.length > 1000) {
      historyErrMsg.value.removeAt(0);
    }
    var tmp = historyErrMsg.value;
    historyErrMsg.value = [];
    historyErrMsg.value = tmp;
  }

  addInfoLog(msg) {
    historyInfoMsg.value.add({"msg": msg, "time": DateTime.now()});
    if (historyInfoMsg.value.length > 1000) {
      historyInfoMsg.value.removeAt(0);
    }
    var tmp = historyInfoMsg.value;
    historyInfoMsg.value = [];
    historyInfoMsg.value = tmp;
  }

  Logger _log = Logger();

  v(msg) => _log.v(msg);
  d(msg) => _log.d(msg);

  i(msg) {
    print(MyDateUtils.formatToString(DateTime.now()) + ":" + msg);
    addInfoLog(msg);
  }

  w(e) {
    addErrLog(e);
    _log.w(e);
  }

  e(e) {
    addErrLog(e);
    _log.e(e);
  }

  wtf(e) {
    addErrLog(e);
    _log.wtf(e);
  }
}
