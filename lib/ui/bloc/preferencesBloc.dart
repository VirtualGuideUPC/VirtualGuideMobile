import 'package:rxdart/rxdart.dart';
import 'package:tour_guide/data/datasource/userPreferences.dart';
import 'package:tour_guide/data/entities/category.dart';
import 'package:tour_guide/data/entities/preferences.dart';
import 'package:tour_guide/data/entities/subcategory.dart';
import 'package:tour_guide/data/entities/typePlace.dart';
import 'package:tour_guide/data/providers/preferencesProvider.dart';
import 'package:tour_guide/data/providers/userProvider.dart';

class PreferencesBloc {
  BehaviorSubject<Preferences> _preferencesController =
      BehaviorSubject<Preferences>();

  Stream<Preferences> get preferencesStream => _preferencesController.stream;
  Function get changePreferences => _preferencesController.sink.add;
  Preferences get getPreferences => _preferencesController.value;

  BehaviorSubject<List<Category>> _categoriesController =
      BehaviorSubject<List<Category>>();
  Stream<List<Category>> get categoriesStream => _categoriesController.stream;
  Function get changeCategories => _categoriesController.sink.add;
  List<Category> get getCategories => _categoriesController.value;

  BehaviorSubject<List<TypePlace>> _typeplacesController =
      BehaviorSubject<List<TypePlace>>();
  Stream<List<TypePlace>> get typeplacesControllerStream =>
      _typeplacesController.stream;
  Function get changeTypeplaces => _typeplacesController.sink.add;
  List<TypePlace> get getTypeplacesController => _typeplacesController.value;

  BehaviorSubject<List<Subcategory>> _SubcategoriesController =
      BehaviorSubject<List<Subcategory>>();
  Stream<List<Subcategory>> get subCategoryControllerStream =>
      _SubcategoriesController.stream;
  Function get changeSubCategory => _SubcategoriesController.sink.add;
  List<Subcategory> get getSubCategoryController =>
      _SubcategoriesController.value;

  void getPreferencesData() async {
    final result = await PreferencesProvider().getPreferencesByUser();
    changePreferences(result);
  }

  void getCategoriesData() async {
    final result = await PreferencesProvider().getPreferencesByUser();
    changeCategories(result.categories);
  }

  void getSubCategoriesData() async {
    final result = await PreferencesProvider().getPreferencesByUser();
    changeSubCategory(result.subcategories);
  }

  void getTypeplacesData() async {
    final result = await PreferencesProvider().getPreferencesByUser();
    changeTypeplaces(result.typeplaces);
  }

  Future<void> updateCategory(Category category) async {
    await UserProvider()
        .updateCategory(category)
        .whenComplete(() => getCategoriesData());
  }

  Future<void> updateSubCategory(Subcategory subcategory) async {
    await UserProvider()
        .updateSubCategory(subcategory)
        .whenComplete(() => getSubCategoriesData());
  }

  Future<void> updateTypePlace(TypePlace typePlace) async {
    await UserProvider()
        .updateTypePlace(typePlace)
        .whenComplete(() => getTypeplacesData());
  }
}
