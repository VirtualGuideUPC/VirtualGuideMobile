import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tour_guide/data/datasource/userPreferences.dart';
import 'package:tour_guide/data/entities/category.dart';

class UserProvider {
  final String _url = "https://vguidebe.herokuapp.com";
  final _prefs = new UserPreferences();

  Future<String> signinUser(String name, String lastName, String email,
      String password, String birthDate, String country) async {
    final url = Uri.parse('https://vguidebe.herokuapp.com/api/users/register/');
    final authData = {
      'email': email,
      'password': password,
      'name': name,
      'last_name': lastName,
      'birthday': birthDate,
      'country': country
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

  Future<String> loginUser(String email, String password) async {
    final url = Uri.parse('https://vguidebe.herokuapp.com/api/users/login/');
    final authData = {'email': email, 'password': password};

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
    final url =
        Uri.parse('https://mocki.io/v1/d8971998-d482-4517-9d48-c376d4a5e0f1');
    final resp = await http.get(url);
    List<dynamic> decodedJson = json.decode(resp.body);
    List<Category> categories = decodedJson.map((categoryJson) {
      return Category.fromJson(categoryJson);
    }).toList();
    print("==========");
    print(categories);
    return categories;
  }
}
