import 'package:menu_app/models/version_model.dart';
import 'package:menu_app/network_modular/api_path.dart';
import 'package:menu_app/network_modular/http_request.dart';

class VersionRepository {
  Future<VersionResponse> fetchItems() async {
    final response = await HttpClient.instance.fetchData(
      APIPathHelper.getValue(APIPath.version),
    );
    Map<String, dynamic> data = new Map<String, dynamic>.from(response);
    return VersionResponse.fromJson(data);
  }
}
