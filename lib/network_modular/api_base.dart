import 'package:flutter/foundation.dart';

class APIBase {
  static String get baseURL {
    if (kReleaseMode) {
      return "https://menu.baythalab.com/api/";
    } else {
      return "https://menu.baythalab.com/api/";
    }
  }
}
