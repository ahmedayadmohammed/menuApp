import 'package:flutter/foundation.dart';

class APIBase {
  static String get baseURL {
    if (kReleaseMode) {
      return "http://192.168.1.1:8080/api/";
    } else {
      return "http://192.168.1.1:8080/api/";
    }
  }
}
