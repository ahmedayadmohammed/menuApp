import 'dart:async';
import 'package:dio/dio.dart';
import 'package:menu_app/models/cat_model.dart';

class HttpClient {
  static final HttpClient _singleton = HttpClient();

  static HttpClient get instance => _singleton;
  var dio = Dio();

  Future<Foodresponse> getAllDataofHome(String url) async {
    Response response;
    dio.options.connectTimeout = 6000;
    response = await dio.get(url,
        options: Options(
          sendTimeout: 60 * 1000,
          receiveTimeout: 60 * 1000,
        ));
    Map<String, dynamic> data = new Map<String, dynamic>.from(response.data);

    return Foodresponse.fromJson(data);
  }

  Future<Foodresponse> getCategoryItemList(String url) async {
    Response response;
    response = await dio.get(url);
    Map<String, dynamic> data = new Map<String, dynamic>.from(response.data);

    return Foodresponse.fromJson(data);
  }
}
