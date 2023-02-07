import 'package:flutter/material.dart';
import 'package:menu_app/models/cat_model.dart';

import '../network_modular/api_response.dart';
import '../repository/home_category_repo.dart';

class HomeProvider with ChangeNotifier {
  late HomeRepository _homeRepository;
  ApiResponse<Foodresponse>? _company;
  ApiResponse<Foodresponse>? get item => _company;
  int skip = 0;
  HomeProvider() {
    _homeRepository = HomeRepository();
    fetchMenuDetails();
  }

  fetchMenuDetails() async {
    _company = ApiResponse.loading(Center(
      child: CircularProgressIndicator(),
    ));
    notifyListeners();
    try {
      Foodresponse co = await _homeRepository.fetchItems();
      _company = ApiResponse.completed(co);
      print("completed");
      notifyListeners();
    } catch (error) {
      print("Error");
      _company = ApiResponse.error(error.toString());
      notifyListeners();
    }
  }
}
