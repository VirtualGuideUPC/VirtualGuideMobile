import 'package:flutter/foundation.dart';

class Preferences {
  List<Category> categories;
  List<TypePlaces> typeplaces;
  List<Subcategory> subcategories;
  Preferences({this.categories, this.typeplaces});

  factory Preferences.fromJson(Map<String, dynamic> json) {
    var categoriesdata = json["categories"] as List;
    var typeplacesdata = json["typeplaces"] as List;

    var categories =
        categoriesdata.map((cat) => Category.fromJson(cat)).toList();

    var typeplaces =
        typeplacesdata.map((tp) => TypePlaces.fromJson(tp)).toList();

    return Preferences(categories: categories, typeplaces: typeplaces);
  }
}

class Category {
  int id;
  String name;
  String icon;
  bool status;

  Category({this.id, this.name, this.icon, this.status});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        icon: json["icon"],
        id: json["category_id"],
        name: json["name"],
        status: json["status"]);
  }
}

class TypePlaces {
  int id;
  String name;
  String icon;
  bool status;
  TypePlaces({this.id, this.name, this.icon, this.status});

  factory TypePlaces.fromJson(Map<String, dynamic> json) {
    return TypePlaces(
        icon: json["icon"],
        id: json["category_id"],
        name: json["name"],
        status: json["status"]);
  }
}

class Subcategory {}
