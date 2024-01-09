import 'package:flutter/material.dart';

class NetworkCfg {
  static const int maxNetConnectionWaitTime = 5000;
  static const int maxNetRecieveWaitTime = 10000;
  static const int maxMultiCastDio = 100;
  static const int maxNetConnectRetryCount = 3;
  static const int maxNetMutialRetryCount = 3;
}

class TempData {
  static ValueNotifier<double> todaySugarIntakeTotal = ValueNotifier(0);
}

class PreferencesCfg {
  static const String todaySugarIntake =
      "todaySugarIntake_"; //todaySugarIntake_20231215
}

class DebugCfg {
  static const bool isDebug = true;
}
