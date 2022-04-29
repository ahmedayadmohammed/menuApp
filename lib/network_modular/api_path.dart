enum APIPath {
  login,
  version
}

class APIPathHelper {
  static String getValue(APIPath path) {
    switch (path) {
      case APIPath.login:
        return "login";
         case APIPath.version:
        return "check-update";
      default:
        return "";
    }
  }
}
