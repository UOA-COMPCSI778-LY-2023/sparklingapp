class DataUtils {
  static String getIpFromUrl(String url) {
    String ip = "";
    url = url.replaceAll(RegExp(r"http://"), "");
    int endIndex = url.replaceAll(RegExp(r"http://"), "").indexOf(":");
    if (endIndex < 0) {
      endIndex = url.length - 1;
    }
    ip = url.substring(0, endIndex);
    return ip;
  }
}
