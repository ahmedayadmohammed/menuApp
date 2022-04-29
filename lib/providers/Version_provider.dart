import 'package:flutter/material.dart';
import 'package:menu_app/models/version_model.dart';
import 'package:menu_app/network_modular/api_response.dart';
import 'package:menu_app/repository/VerionRepository.dart';

class VersionProvider with ChangeNotifier {
    late VersionRepository _versionRepository;
  ApiResponse<VersionResponse>? _version;
  ApiResponse<VersionResponse>? get version => _version;
  VersionProvider() {
    _versionRepository = VersionRepository();
    fetchMenuDetails();
  }

  fetchMenuDetails() async {
    _version = ApiResponse.loading(Center(
      child: CircularProgressIndicator(),
    ));
    notifyListeners();
    try {
      VersionResponse groupes = await _versionRepository.fetchItems();
      _version = ApiResponse.completed(groupes);
      print("completed");
      notifyListeners();
    } catch (error) {
      print("Error");
      _version = ApiResponse.error(error.toString());
      notifyListeners();
    }
  }
}