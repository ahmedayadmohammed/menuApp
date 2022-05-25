import 'package:menu_app/models/question_model.dart';
import 'package:menu_app/network_modular/http_request.dart';

class BillsRepository {
  Future<QuestionsResponse> fetchItems() async {
    final response = await HttpClient.instance
        .fetchData("http://192.168.123.1:9000/api/form");
    Map<String, dynamic> data = new Map<String, dynamic>.from(response);
    return QuestionsResponse.fromJson(data);
  }
}
