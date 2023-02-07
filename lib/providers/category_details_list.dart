import 'package:flutter/material.dart';
import 'package:menu_app/models/cat_model.dart';

import '../network_modular/api_response.dart';
import '../repository/category_rep.dart';
import '../repository/home_category_repo.dart';

class CategoryDetailsProvider with ChangeNotifier {
  late CategoriesListRepo _categoriesListRepo;
  ApiResponse<Foodresponse>? _company;
  ApiResponse<Foodresponse>? get item => _company;
  int skip = 0;
  String catId;
  CategoryDetailsProvider(this.catId) {
    _categoriesListRepo = CategoriesListRepo(catId);
    fetchMenuDetails();
  }

  fetchMenuDetails() async {
    _company = ApiResponse.loading(Center(
      child: CircularProgressIndicator(),
    ));
    notifyListeners();
    try {
      Foodresponse co = await _categoriesListRepo.fetchItems();
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
