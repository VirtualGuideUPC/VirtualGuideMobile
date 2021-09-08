import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tour_guide/data/datasource/userPreferences.dart';
import 'package:tour_guide/data/entities/category.dart';
import 'package:tour_guide/data/entities/subcategory.dart';
import 'package:tour_guide/data/entities/typePlace.dart';

class UserProvider {
  final String _url = "https://vguidebe.herokuapp.com";
  final _prefs = new UserPreferences();

  Future<String> signinUser(String name, String lastName, String email,
      String password, String birthDate, String country, List<int> typePlaces, List<int> categories, List<int> subcategories) async {
    final url = Uri.parse('https://virtualguide2.herokuapp.com/api/users/register/');
    //final url = Uri.parse('https://vguidebe.herokuapp.com/api/users/register/');
    final authData = {
      'email': email,
      'password': password,
      'name': name,
      'last_name': lastName,
      'birthday': birthDate,
      'country': country,
      'type_place': typePlaces,
      'category': categories,
      'subcategory': subcategories
    };
    final http.Response resp = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(authData));
    Map decodedJson = json.decode(resp.body);
    if (resp.statusCode == 200) {
      return 'ok';
    } else {
      List<dynamic> responseValues = decodedJson.values.toList();
      if (responseValues.length > 0 &&
          responseValues[0] is List &&
          responseValues[0].length > 0) {
        return Future.error(responseValues[0][0]);
      } else {
        return Future.error('Ocurrió un error, inténtelo mas tarde');
      }
    }
  }

  Future<String> loginUser(String email) async {
    //final url = Uri.parse('https://vguidebe.herokuapp.com/api/users/login/');
    final url = Uri.parse('https://virtualguide2.herokuapp.com/api/users/login/');
    final authData = {'email': email};

    final http.Response resp = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(authData));

    Map decodedJson = json.decode(resp.body);
    if (resp.statusCode == 200 && decodedJson.containsKey('jwt')) {
      _prefs.setToken(decodedJson['jwt']);
      _prefs.setUserId(decodedJson['id']);
      return decodedJson['jwt'];
    } else {
      if (decodedJson.containsKey('detail')) {
        return Future.error(decodedJson['detail']);
      } else {
        return Future.error('Ocurrió un error, inténtelo mas tarde');
      }
    }
  }

  Future<List<Category>> getCategories() async {
    final url = Uri.parse('https://virtualguide2.herokuapp.com/api/users/getAllCategories');
    final resp = await http.get(url);
    List<dynamic> decodedJson = json.decode(resp.body);
    List<Category> categories = decodedJson.map((categoryJson) {
      return Category.fromJson(categoryJson);
    }).toList();
    print("==========");
    print(categories);
    return categories;
  }

  Future<List<TypePlace>> getAllTypePlaces() async {
    final url = Uri.parse('https://virtualguide2.herokuapp.com/api/users/getAllTypePlaces');
    final resp = await http.get(url);
    List<dynamic> decodedJson = json.decode(resp.body);
    List<TypePlace> typePlaces = decodedJson.map((typePlaceJson) {
      return TypePlace.fromJson(typePlaceJson);
    }).toList();
    print("==========");
    print(typePlaces);
    return typePlaces;
  }

  Future<List<Subcategory>> getAllSubcategories() async {
    final url = Uri.parse('https://virtualguide2.herokuapp.com/api/users/getAllSubcategories');
    final resp = await http.get(url);
    List<dynamic> decodedJson = json.decode(resp.body);
    List<Subcategory> subcategories = decodedJson.map((subcategoriesJson) {
      return Subcategory.fromJson(subcategoriesJson);
    }).toList();
    print("==========");
    print(subcategories);
    return subcategories;
  }

}
