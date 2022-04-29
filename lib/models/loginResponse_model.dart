// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    this.success,
    this.token,
  });

  bool? success;
  String? token;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        success: json["success"] == null ? null : json["success"],
        token: json["token"] == null ? null : json["token"],
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "token": token == null ? null : token,
      };
}
