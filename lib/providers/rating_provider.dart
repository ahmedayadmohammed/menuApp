import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:menu_app/models/question_model.dart';
import 'package:menu_app/network_modular/api_response.dart';
import 'package:menu_app/repository/category_rep.dart';


class BillProvider with ChangeNotifier {
  late BillsRepository _billsRepository;
  ApiResponse<QuestionsResponse>? _bills;
  ApiResponse<QuestionsResponse>? get item => _bills;
  BillProvider() {
    _billsRepository = BillsRepository();
    fetchMenuDetails();
  }

  fetchMenuDetails() async {
    _bills = ApiResponse.loading(Center(
      child: CircularProgressIndicator(),
    ));
    notifyListeners();
    try {
      QuestionsResponse bills = await _billsRepository.fetchItems();
      _bills = ApiResponse.completed(bills);
      print("completed");
      notifyListeners();
    } catch (error) {
      print("Error");
      _bills = ApiResponse.error(error.toString());
      notifyListeners();
    }
  }
}