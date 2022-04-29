// To parse this JSON data, do
//
//     final versionResponse = versionResponseFromJson(jsonString);

import 'dart:convert';

VersionResponse versionResponseFromJson(String str) => VersionResponse.fromJson(json.decode(str));

String versionResponseToJson(VersionResponse data) => json.encode(data.toJson());

class VersionResponse {
    VersionResponse({
        this.success,
        this.message,
        this.data,
    });

    bool? success;
    dynamic? message;
    VersionInfo? data;

    factory VersionResponse.fromJson(Map<String, dynamic> json) => VersionResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"],
        data: json["data"] == null ? null : VersionInfo.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message,
        "data": data == null ? null : data?.toJson(),
    };
}

class VersionInfo {
    VersionInfo({
        this.appVersion,
        this.apkUrl,
    });

    String? appVersion;
    String? apkUrl;

    factory VersionInfo.fromJson(Map<String, dynamic> json) => VersionInfo(
        appVersion: json["app_version"] == null ? null : json["app_version"],
        apkUrl: json["apk_url"] == null ? null : json["apk_url"],
    );

    Map<String, dynamic> toJson() => {
        "app_version": appVersion == null ? null : appVersion,
        "apk_url": apkUrl == null ? null : apkUrl,
    };
}
