import 'package:flutter/cupertino.dart';

class ColorSelector with ChangeNotifier {
  int selectedIndex = 0;

  changeSelection(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}

class ChangeInformations with ChangeNotifier {
  String? englishName;
  String? arabicName;
  String? description;
  String? price;
  String? image;
  bool isSelectionStarted = false;
  fillOutInofrmation(String? englishNames, String arabicNames,
      String descriptions, String prices, String images) {
    englishName = englishNames;
    arabicName = arabicNames;
    description = descriptions;
    price = prices;
    image = images;
    notifyListeners();
  }
}
