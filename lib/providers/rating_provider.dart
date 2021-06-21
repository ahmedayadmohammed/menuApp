import 'package:flutter/material.dart';

class RatingProvider with ChangeNotifier {
  Map<int, dynamic> ratingMap = new Map();
  List<Map<String, dynamic>> jsonObject = [];
  ratingMapSequence() {
    ratingMap.forEach((key, value) {
      jsonObject.add(value);
      notifyListeners();
    });
  }

  clearJsonObject() {
    ratingMap.clear();
    jsonObject.clear();
    notifyListeners();
  }


  
}
