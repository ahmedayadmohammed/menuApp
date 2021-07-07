import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:menu_app/models/cat_model.dart';
import 'package:menu_app/models/error_response.dart';
import 'package:menu_app/models/question_model.dart';
import 'package:menu_app/network_modular/api_exption.dart';

class HttpClient {
  static final HttpClient _singleton = HttpClient();

  static HttpClient get instance => _singleton;
  var dio = Dio();

  Future<dynamic> fetchData(String url, {Map<String, String>? params}) async {
    try {
      var response = await dio.get(
        url,
      );
      print(response.data);
      print(response.statusCode);
      return response.data;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  String queryParameters(Map<String, String> params) {
    if (params != null) {
      final jsonString = Uri(queryParameters: params);
      return '?${jsonString.query}';
    }
    return '';
  }

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

  Future<QuestionsResponse> getAllQuestions(String url) async {
    Response response;
    print('getting questions');
    response = await dio.get(url);
    Map<String, dynamic> data = new Map<String, dynamic>.from(response.data);

    return QuestionsResponse.fromJson(data);
  }

  Future<PostResponse> postRating(String url, Map<String, dynamic> para,
      completionHandler(bool success, PostResponse? data)) async {
    var dios = Dio();

    Response response;
    response = await dios.post(url, data: para);
    switch (response.statusCode) {
      case 200:
        completionHandler(true,
            PostResponse.fromJson(Map<String, dynamic>.from(response.data)));

        break;
      case 400:
        completionHandler(false,
            PostResponse.fromJson(Map<String, dynamic>.from(response.data)));
        break;
      case 500:
        completionHandler(false,
            PostResponse.fromJson(Map<String, dynamic>.from(response.data)));
        break;
      default:
        completionHandler(false,
            PostResponse.fromJson(Map<String, dynamic>.from(response.data)));
    }
    Map<String, dynamic> data = new Map<String, dynamic>.from(response.data);
    return PostResponse.fromJson(data);
  }
}
