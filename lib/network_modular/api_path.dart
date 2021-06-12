enum APIPath {
  fetch_album,
}

class APIPathHelper {
  static String getValue(APIPath path) {
    switch (path) {
      case APIPath.fetch_album:
        return "/category";
      default:
        return "";
    }
  }
}
