// To parse this JSON data, do
//
//     final foodresponse = foodresponseFromJson(jsonString);

import 'dart:convert';

Foodresponse foodresponseFromJson(String str) => Foodresponse.fromJson(json.decode(str));

String foodresponseToJson(Foodresponse data) => json.encode(data.toJson());

class Foodresponse {
    Foodresponse({
        this.success,
        this.message,
        this.data,
    });

    bool? success;
    dynamic message;
    Data? data;

    factory Foodresponse.fromJson(Map<String, dynamic> json) => Foodresponse(
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
        this.appVersion,
        this.storageUrl,
        this.sliders,
        this.categories,
        this.food,
    });

    String? appVersion;
    String? storageUrl;
    List<Slider>? sliders;
    List<Category>? categories;
    List<Food>? food;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        appVersion: json["app_version"] == null ? null : json["app_version"],
        storageUrl: json["storage_url"] == null ? null : json["storage_url"],
        sliders: json["sliders"] == null ? null : List<Slider>.from(json["sliders"].map((x) => Slider.fromJson(x))),
        categories: json["categories"] == null ? null : List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
        food: json["food"] == null ? null : List<Food>.from(json["food"].map((x) => Food.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "app_version": appVersion == null ? null : appVersion,
        "storage_url": storageUrl == null ? null : storageUrl,
        "sliders": sliders == null ? null : List<dynamic>.from(sliders!.map((x) => x.toJson())),
        "categories": categories == null ? null : List<dynamic>.from(categories!.map((x) => x.toJson())),
        "food": food == null ? null : List<dynamic>.from(food!.map((x) => x.toJson())),
    };
}

class Category {
    Category({
        this.id,
        this.nameAr,
        this.nameEn,
        this.image,
    });

    int? id;
    String? nameAr;
    String? nameEn;
    String? image;

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"] == null ? null : json["id"],
        nameAr: json["name_ar"] == null ? null : json["name_ar"],
        nameEn: json["name_en"] == null ? null : json["name_en"],
        image: json["image"] == null ? null : json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name_ar": nameAr == null ? null : nameAr,
        "name_en": nameEn == null ? null : nameEn,
        "image": image == null ? null : image,
    };
}

class Food {
    Food({
        this.id,
        this.nameAr,
        this.nameEn,
        this.descriptionAr,
        this.descriptionEn,
        this.price,
        this.priceDiscounted,
        this.status,
        this.image,
    });

    int? id;
    String? nameAr;
    String? nameEn;
    String? descriptionAr;
    String? descriptionEn;
    String? price;
    dynamic priceDiscounted;
    int? status;
    String? image;

    factory Food.fromJson(Map<String, dynamic> json) => Food(
        id: json["id"] == null ? null : json["id"],
        nameAr: json["name_ar"] == null ? null : json["name_ar"],
        nameEn: json["name_en"] == null ? null : json["name_en"],
        descriptionAr: json["description_ar"] == null ? null : json["description_ar"],
        descriptionEn: json["description_en"] == null ? null : json["description_en"],
        price: json["price"] == null ? null : json["price"],
        priceDiscounted: json["price_discounted"],
        status: json["status"] == null ? null : json["status"],
        image: json["image"] == null ? null : json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name_ar": nameAr == null ? null : nameAr,
        "name_en": nameEn == null ? null : nameEn,
        "description_ar": descriptionAr == null ? null : descriptionAr,
        "description_en": descriptionEn == null ? null : descriptionEn,
        "price": price == null ? null : price,
        "price_discounted": priceDiscounted,
        "status": status == null ? null : status,
        "image": image == null ? null : image,
    };
}

class Slider {
    Slider({
        this.image,
    });

    String? image;

    factory Slider.fromJson(Map<String, dynamic> json) => Slider(
        image: json["image"] == null ? null : json["image"],
    );

    Map<String, dynamic> toJson() => {
        "image": image == null ? null : image,
    };
}
