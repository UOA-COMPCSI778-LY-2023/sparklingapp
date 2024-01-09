import 'package:intl/intl.dart';

import 'LogUtils.dart';

class MyDateUtils {
  static const num ONE_MINUTE = 60000;
  static const num ONE_HOUR = 3600000;
  static const num ONE_DAY = 86400000;
  static const num ONE_WEEK = 604800000;
  static const num ONE_YEAR = 31536000000;

  static const String ONE_SECOND_AGO = "second ago";
  static const String ONE_MINUTE_AGO = "minitue ago";
  static const String ONE_HOUR_AGO = "hour ago";
  static const String ONE_DAY_AGO = "day ago";
  static const String ONE_MONTH_AGO = "moth ago";
  static const String ONE_YEAR_AGO = "year ago";
  static const String ONE_YEAR_CENTURY_AGO = "century ago";

  static const String ONE_SECOND_AFTER = "second after";
  static const String ONE_MINUTE_AFTER = "miniute after";
  static const String ONE_HOUR_AFTER = "hour after";
  static const String ONE_DAY_AFTER = "day after";
  static const String ONE_MONTH_AFTER = "month after";
  static const String ONE_YEAR_AFTER = "year after";
  static const String ONE_YEAR_CENTURY_AFTER = "century after";

  static String formatToString(DateTime date) {
    return DateFormat("yyyy-MM-dd HH:mm:ss").format(date);
  }

  /**
 * yyy-MM-dd
 */
  static String formatToHHmmss(DateTime date) {
    if (date != null) {
      return DateFormat("HH:mm:ss").format(date);
    } else {
      Log.instance.wtf("Null value：${date}");
      return DateFormat("yyyy-MM-dd").format(DateTime.now());
    }
  }

  static String formatToyyyMMdd(DateTime date) {
    if (date != null) {
      return DateFormat("yyyy-MM-dd").format(date);
    } else {
      Log.instance.wtf("Null value：${date}");
      return DateFormat("yyyy-MM-dd").format(DateTime.now());
    }
  }

  /**
 * yyy-MM-dd，If no time then automately adding 00:00
 */
  static DateTime yyyMMddToDate(String date) {
    if (date != null) {
      return DateTime.parse(date);
    } else {
      throw Exception("Null value：${date}");
    }
  }

  static String format(DateTime date) {
    num delta =
        DateTime.now().millisecondsSinceEpoch - date.millisecondsSinceEpoch;

    if (delta < -100 * ONE_YEAR) {
      num centurys = toCenturys(delta);
      return (centurys = centurys).abs().toInt().toString() +
          ONE_YEAR_CENTURY_AFTER;
    }
    if (delta < -1 * ONE_YEAR) {
      num years = toYears(delta);
      return (years = years).abs().toInt().toString() + ONE_YEAR_AFTER;
    }
    if (delta < -30 * ONE_DAY) {
      num months = toMonths(delta);
      return (months = months).abs().toInt().toString() + ONE_MONTH_AFTER;
    }
    if (delta < -48 * ONE_HOUR) {
      num days = toDays(delta);
      return (days = days).abs().toInt().toString() + ONE_DAY_AFTER;
    }
    if (delta < -24 * ONE_HOUR) {
      return "tomorrow";
    }
    if (delta < -60 * ONE_MINUTE) {
      num hours = toHours(delta);
      return (hours = hours).abs().toInt().toString() + ONE_HOUR_AFTER;
    }
    if (delta < -1 * ONE_MINUTE) {
      num minutes = toMinutes(delta);
      return (minutes = minutes).abs().toInt().toString() + ONE_MINUTE_AFTER;
    }
    if (delta < 0) {
      num seconds = toSeconds(delta);
      return (seconds = seconds).abs().toInt().toString() + ONE_SECOND_AFTER;
    }

    if (delta < 1 * ONE_MINUTE) {
      num seconds = toSeconds(delta);
      return (seconds = seconds).abs().toInt().toString() + ONE_SECOND_AGO;
    }
    if (delta < 60 * ONE_MINUTE) {
      num minutes = toMinutes(delta);
      return (minutes = minutes).abs().toInt().toString() + ONE_MINUTE_AGO;
    }
    if (delta < 24 * ONE_HOUR) {
      num hours = toHours(delta);
      return (hours = hours).abs().toInt().toString() + ONE_HOUR_AGO;
    }
    if (delta < 48 * ONE_HOUR) {
      return "yesterday";
    }
    if (delta < 30 * ONE_DAY) {
      num days = toDays(delta);
      return (days = days).abs().toInt().toString() + ONE_DAY_AGO;
    }
    if (delta < 12 * 4 * ONE_WEEK) {
      num months = toMonths(delta);
      return (months = months).abs().toInt().toString() + ONE_MONTH_AGO;
    }
    if (delta < 100 * ONE_YEAR) {
      num years = toYears(delta);
      return (years = years).abs().toInt().toString() + ONE_YEAR_AGO;
    } else {
      num centurys = toCenturys(delta);
      return (centurys = centurys).abs().toInt().toString() +
          ONE_YEAR_CENTURY_AGO;
    }
  }

  static num toSeconds(num date) {
    return date / 1000;
  }

  static num toMinutes(num date) {
    return toSeconds(date) / 60;
  }

  static num toHours(num date) {
    return toMinutes(date) / 60;
  }

  static num toDays(num date) {
    return toHours(date) / 24;
  }

  static num toMonths(num date) {
    return toDays(date) / 30;
  }

  static num toYears(num date) {
    return toMonths(date) / 12;
  }

  static num toCenturys(num date) {
    return toYears(date) / 100;
  }
}
