import 'package:tour_guide/data/entities/category.dart';
import 'package:tour_guide/data/entities/subcategory.dart';
import 'package:tour_guide/data/entities/typePlace.dart';

class Preferences {
  List<Category> categories;
  List<TypePlace> typeplaces;
  List<Subcategory> subcategories;
  Preferences({this.categories, this.typeplaces, this.subcategories});

  factory Preferences.fromJson(Map<String, dynamic> json) {
    var categoriesdata = json["categories"] as List;
    var typeplacesdata = json["typeplaces"] as List;
    var subcategoriesdata = json["subcategories"] as List;

    var categories =
        categoriesdata.map((cat) => Category.fromJson(cat)).toList();

    var typeplaces =
        typeplacesdata.map((tp) => TypePlace.fromJson(tp)).toList();

    var subcategories =
        subcategoriesdata.map((tp) => Subcategory.fromJson(tp)).toList();

    return Preferences(
        categories: categories,
        typeplaces: typeplaces,
        subcategories: subcategories);
  }
}
