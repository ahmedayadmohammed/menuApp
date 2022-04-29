import 'dart:async';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:menu_app/extensions/color.dart';
import 'package:menu_app/models/cat_model.dart';
import 'package:menu_app/models/error_response.dart';
import 'package:menu_app/models/loginResponse_model.dart';
import 'package:menu_app/models/question_model.dart';
import 'package:menu_app/network_modular/api_base.dart';
import 'package:menu_app/network_modular/api_exption.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpClient {
  static final HttpClient _singleton = HttpClient();

  static HttpClient get instance => _singleton;

  late Dio dio;

  var baseOptions = BaseOptions(
    // sendTimeout: 1000,
    // connectTimeout: 1000,
    // receiveTimeout: 1000,
    followRedirects: true,
    baseUrl: APIBase.baseURL,
  );

  HttpClient() {
    dio = Dio(baseOptions);
    dio.interceptors.add(AppInterceptors());

    if (!kIsWeb) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) {
          return true;
        };
      };
    }
  }

  Future<dynamic> fetchData(String url,
      {Map<String, dynamic>? params, Map<String, dynamic>? headers}) async {
    var responseJson;
    print(url);
    if (headers != null) {
      dio.options.headers = headers;
    }

    if (params != null) {
      dio.options.queryParameters = params;
    } else {
      dio.options.queryParameters = {};
    }

    try {
      Response response = await dio.get(url);
      responseJson = response.data;
    } on DioError catch (error) {
      throwError(error);
    }

    return responseJson;
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

    Response response;
    response = await dio.post(url, data: para);
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

  Future<dynamic> login(
      String url,
      BuildContext context,
      Map<String, dynamic> para,
      completionHandler(bool success, LoginResponse? data)) async {
    try {
      var response = await dio.post(url, data: para);
      print(response.data);
      if (response.statusCode == 200) {
        Map<String, dynamic> data =
            new Map<String, dynamic>.from(response.data);
        completionHandler(true,
            LoginResponse.fromJson(Map<String, dynamic>.from(response.data)));

        return LoginResponse.fromJson(data);
      }
      print(response);
    } on DioError catch (e) {
      switch (e.response?.statusCode ?? -1080) {
        case 400:
          completionHandler(
              false,
              LoginResponse.fromJson(
                  Map<String, dynamic>.from(e.response?.data)));

          break;
        case 401:
          completionHandler(
              false,
              LoginResponse.fromJson(
                  Map<String, dynamic>.from(e.response?.data)));

          break;
        case 403:
          completionHandler(
              false,
              LoginResponse.fromJson(
                  Map<String, dynamic>.from(e.response?.data)));

          break;
        case 404:
          completionHandler(
              false,
              LoginResponse.fromJson(
                  Map<String, dynamic>.from(e.response?.data)));

          break;
        case 500:
          completionHandler(
              false,
              LoginResponse.fromJson(
                  Map<String, dynamic>.from(e.response?.data)));
          break;
      }
      print(e.error);
    }
  }

  throwError(DioError error) {
    switch (error.response?.statusCode ?? -1080) {
      case 400:
        throw BadRequestException(error.message);
      case 401:
        throw UnauthorisedException(error.message);
      case 403:
        throw UnauthorisedException(error.message);
      case 500:
        throw UnauthorisedException(error.message);

      default:
        throw FetchDataException("No internet connection");
    }
  }
}

class AppInterceptors extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String token = await read("token");
    if ((token) != '') {
      options.headers.addAll({'Authorization': 'Bearer $token'});
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    if ((err.response?.statusCode ?? 0) == 401) {
      debugPrint(
          'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
      // refresh token

      super.onError(err, handler);
    } else {
      debugPrint(
          'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
      super.onError(err, handler);
    }
  }

  save(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
    prefs.setString(key, value);
  }

  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) == null ? '' : prefs.getString(key);
  }
}
