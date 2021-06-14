import 'package:meta/meta.dart';
import 'dart:convert';

PostResponse postResponseFromJson(String str) => PostResponse.fromJson(json.decode(str));

String postResponseToJson(PostResponse data) => json.encode(data.toJson());

class PostResponse {
    PostResponse({
        required this.success,
        required this.message,
        required this.data,
    });

    bool? success;
    dynamic message;
    String? data;

    factory PostResponse.fromJson(Map<String, dynamic> json) => PostResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"],
        data: json["data"] == null ? null : json["data"],
    );

    Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message,
        "data": data == null ? null : data,
    };
}
