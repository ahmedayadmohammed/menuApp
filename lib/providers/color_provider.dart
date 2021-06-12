import 'package:flutter/cupertino.dart';

class ColorSelector with ChangeNotifier {
  int selectedIndex = 0;

  changeSelection(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}