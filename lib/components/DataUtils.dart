class DataUtils {
  static String getIpFromUrl(String url) {
    Uri uri = Uri.parse(url);
    return uri.host;
  }

  static String getDayFromDateString(String sDate) {
    DateTime dateTime = DateTime.parse(sDate);
    int weekdayNumber = dateTime.weekday;
    List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[weekdayNumber - 1];
  }

  static String capitalizeFirstLetter(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1);
  }
}
