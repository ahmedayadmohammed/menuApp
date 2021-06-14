// To parse this JSON data, do
//
//     final questionsResponse = questionsResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

QuestionsResponse questionsResponseFromJson(String str) =>
    QuestionsResponse.fromJson(json.decode(str));

String questionsResponseToJson(QuestionsResponse data) =>
    json.encode(data.toJson());

class QuestionsResponse {
  QuestionsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  bool? success;
  dynamic message;
  Data? data;

  factory QuestionsResponse.fromJson(Map<String, dynamic> json) =>
      QuestionsResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message,
        "data": data == null ? null : data?.toJson(),
      };
}

class Data {
  Data({
    required this.questions,
  });

  List<Question>? questions;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        questions: json["questions"] == null
            ? null
            : List<Question>.from(
                json["questions"].map((x) => Question.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "questions": questions == null
            ? null
            : List<dynamic>.from(questions!.map((x) => x.toJson())),
      };
}

class Question {
  Question({
    required this.id,
    required this.titleAr,
    required this.titleEn,
  });

  int? id;
  String? titleAr;
  String? titleEn;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json["id"] == null ? null : json["id"],
        titleAr: json["title_ar"] == null ? null : json["title_ar"],
        titleEn: json["title_en"] == null ? null : json["title_en"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title_ar": titleAr == null ? null : titleAr,
        "title_en": titleEn == null ? null : titleEn,
      };
}
