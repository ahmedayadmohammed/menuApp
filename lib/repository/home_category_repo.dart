import 'package:menu_app/network_modular/api_path.dart';

import '../models/cat_model.dart';
import '../network_modular/http_request.dart';

class HomeRepository {
  Future<Foodresponse> fetchItems() async {
    final response = await HttpClient.instance
        .fetchData(APIPathHelper.getValue(APIPath.home));
    Map<String, dynamic> data = new Map<String, dynamic>.from(response);
    return Foodresponse.fromJson(data);
  }
}
