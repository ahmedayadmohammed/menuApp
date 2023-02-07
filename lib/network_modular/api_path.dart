enum APIPath { login, version, home }

class APIPathHelper {
  static String getValue(APIPath path) {
    switch (path) {
      case APIPath.login:
        return "login";
      case APIPath.version:
        return "check-update";
      case APIPath.home:
        return "category";
      
      default:
        return "";
    }
  }
}
