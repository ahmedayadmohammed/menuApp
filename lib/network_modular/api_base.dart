import 'package:flutter/foundation.dart';

class APIBase {
  static String get baseURL {
    if (kReleaseMode) {
      return "http://192.168.123.1:9000/api/";
    } else {
      return "http://192.168.123.1:9000/api/";
    }
  }
}
