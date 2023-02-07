import 'package:menu_app/models/cat_model.dart';
import 'package:menu_app/models/question_model.dart';
import 'package:menu_app/network_modular/http_request.dart';

import '../network_modular/api_path.dart';

class BillsRepository {
  Future<QuestionsResponse> fetchItems() async {
    final response = await HttpClient.instance
        .fetchData("https://menu.baythalab.com/api/form");
    Map<String, dynamic> data = new Map<String, dynamic>.from(response);
    return QuestionsResponse.fromJson(data);
  }
}

class CategoriesListRepo {
  final String catId;

  CategoriesListRepo(this.catId);
  Future<Foodresponse> fetchItems() async {
    final response = await HttpClient.instance
        .fetchData("${APIPathHelper.getValue(APIPath.home)}/$catId");

    Map<String, dynamic> data = new Map<String, dynamic>.from(response);
    return Foodresponse.fromJson(data);
  }
}
