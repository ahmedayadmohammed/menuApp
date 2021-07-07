import 'package:flutter/material.dart';
import 'package:menu_app/models/cat_model.dart';
import 'package:menu_app/network_modular/api_response.dart';
import 'package:menu_app/network_modular/http_request.dart';

class FoodResponseProvider with ChangeNotifier {
  HttpClient? _foodRepository;
  ApiResponse<Foodresponse>? _food;
  ApiResponse<Foodresponse>? get food => _food;

  FoodResponseProvider() {
    _foodRepository = HttpClient();
  }

  fetchingFood() async {
    notifyListeners();
    try {
      Foodresponse foods = await _foodRepository!
          .getAllDataofHome("http://192.168.1.1:8080/category");
      print(Foodresponse);
      _food = ApiResponse.completed(foods);
      notifyListeners();
    } catch (error) {
      print(error);
      notifyListeners();
    }
  }
}
