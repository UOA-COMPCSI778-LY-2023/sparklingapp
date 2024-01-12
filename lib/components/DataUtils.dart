class DataUtils {
  static String getIpFromUrl(String url) {
    Uri uri = Uri.parse(url);
    return uri.host;
  }
}
