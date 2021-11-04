import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:tour_guide/data/datasource/userPreferences.dart';
import 'package:tour_guide/data/entities/category.dart';
import 'package:tour_guide/data/entities/preferences.dart';
import 'package:tour_guide/data/entities/subcategory.dart';
import 'package:tour_guide/data/entities/typePlace.dart';
import 'package:tour_guide/data/entities/user.dart';
import 'package:tour_guide/data/providers/preferencesProvider.dart';
import 'package:tour_guide/ui/helpers/utils.dart';
import 'package:tour_guide/ui/routes/routes.dart';

class UserProvider {
  final String _url = "https://vguidebe.herokuapp.com";
  final _prefs = new UserPreferences();

  Future<String> signinUser(
      String name,
      String lastName,
      String email,
      String password,
      String birthDate,
      String country,
      String icon,
      List<int> typePlaces,
      List<int> categories,
      List<int> subcategories) async {
    final url = Uri.parse(
        'http://ec2-18-212-234-179.compute-1.amazonaws.com/api/users/register/');
    final authData = {
      'email': email,
      'password': password,
      'name': name,
      'last_name': lastName,
      'birthday': birthDate,
      'country': country,
      'icon': icon,
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

      print("hey3");
      return 'ok';
    } else {

      print("hey4");
      List<dynamic> responseValues = decodedJson.values.toList();
      if (responseValues.length > 0 &&
          responseValues[0] is List &&
          responseValues[0].length > 0) {
        print("hey5");
        print("message " + responseValues[0][0]);
        return Future.error(responseValues[0][0]);

      } else {
        print("hey6");
        return Future.error('Ocurrió un error, inténtelo mas tarde');
      }
    }
  }

  Future<String> loginUser(String email) async {
    //final url = Uri.parse('https://vguidebe.herokuapp.com/api/users/login/');
    final url = Uri.parse(
        'http://ec2-18-212-234-179.compute-1.amazonaws.com/api/users/login/');
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
    final url = Uri.parse(
        'http://ec2-18-212-234-179.compute-1.amazonaws.com/api/users/getAllCategories');
    final resp = await http.get(url);

    List<dynamic> decodedJson =
        json.decode(Utf8Decoder().convert(resp.bodyBytes).toString());
    List<Category> categories = decodedJson.map((categoryJson) {
      return Category.fromJson(categoryJson);
    }).toList();
    print("==========");
    print(categories);
    return categories;
  }

  Future<List<TypePlace>> getAllTypePlaces() async {
    final url = Uri.parse(
        'http://ec2-18-212-234-179.compute-1.amazonaws.com/api/users/getAllTypePlaces');
    final resp = await http.get(url);
    List<dynamic> decodedJson =
        json.decode(Utf8Decoder().convert(resp.bodyBytes).toString());
    List<TypePlace> typePlaces = decodedJson.map((typePlaceJson) {
      return TypePlace.fromJson(typePlaceJson);
    }).toList();
    print("==========");
    print(typePlaces);
    return typePlaces;
  }

  Future<List<Subcategory>> getAllSubcategories() async {
    final url = Uri.parse(
        'http://ec2-18-212-234-179.compute-1.amazonaws.com/api/users/getAllSubcategories');
    final resp = await http.get(url);
    List<dynamic> decodedJson =
        json.decode(Utf8Decoder().convert(resp.bodyBytes).toString());
    List<Subcategory> subcategories = decodedJson.map((subcategoriesJson) {
      return Subcategory.fromJson(subcategoriesJson);
    }).toList();
    print("==========");
    print(subcategories);
    return subcategories;
  }

  Future<User> updateUserProfile(
      UserUpdateDto userUpdateDto, File image) async {
    final url = Uri.parse(
        'http://ec2-18-212-234-179.compute-1.amazonaws.com/api/users/user/update/');
    final String userToken = UserPreferences().getToken();

    var formData = FormData.fromMap({
      "user": _prefs.getUserId(),
      "name": userUpdateDto.name,
      "last_name": userUpdateDto.lastName,
      "birthday": userUpdateDto.birthday,
      "country": userUpdateDto.country,
      if (image.path.isNotEmpty)
        "image": await MultipartFile.fromFile(image.path),
    });

    var resp = await Dio().put(url.toString(),
        data: formData,
        options: Options(headers: <String, String>{
          'Authorization': userToken,
          'Cookie': 'jwt=$userToken'
        }));
    print("resopnde code: " + resp.statusCode.toString());

    if (resp.statusCode == 200) {
      var data = resp.data as Map<String, dynamic>;
      var userProfile = User(
          name: data["name"],
          birthday: data["birthday"],
          lastName: data["last_name"],
          countryId: data["country"]);

      return userProfile;
    } else {
      if (resp.statusCode == 403) {
        logOut();
      } else {
        return Future.error('500');
      }
    }
  }

  Future<User> getUserProfile() async {
    final url = Uri.parse(
        'http://ec2-18-212-234-179.compute-1.amazonaws.com/api/users/user/');

    final String userToken = UserPreferences().getToken();

    final http.Response resp = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': userToken,
      'Cookie': 'jwt=$userToken'
    });

    if (resp.statusCode == 200) {
      var decodedJson = json.decode(resp.body);
      print(decodedJson);
      var userProfile = User.fromJson(decodedJson);
      return userProfile;
    } else {
      if (resp.statusCode == 403) {
        logOut();
      } else {
        return Future.error('500');
      }
    }
  }

  Future<void> updateCategory(Category category) async {
    var pref = await PreferencesProvider().getPreferencesByUser();
    final url = Uri.parse(
        'http://ec2-18-212-234-179.compute-1.amazonaws.com/api/users/preference/category/update/');
    var categories = pref.categories;
    var userId = UserPreferences().getUserId();
    final String userToken = UserPreferences().getToken();

    final body = {
      "user": userId,
      "category": category.id,
      "status": category.isSelected
    };

    final http.Response resp =
        await http.put(url, body: jsonEncode(body), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': userToken,
      'Cookie': 'jwt=$userToken'
    });
  }

  Future<void> updateTypePlace(TypePlace typePlace) async {
    final url = Uri.parse(
        'http://ec2-18-212-234-179.compute-1.amazonaws.com/api/users/preference/typeplace/update/');
    var userId = UserPreferences().getUserId();
    final String userToken = UserPreferences().getToken();

    final body = {
      "user": userId,
      "type_place": typePlace.id,
      "status": typePlace.isSelected
    };

    final http.Response resp =
        await http.put(url, body: jsonEncode(body), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': userToken,
      'Cookie': 'jwt=$userToken'
    });
    print(resp);
  }

  Future<void> updateSubCategory(Subcategory subcategory) async {
    final url = Uri.parse(
        'http://ec2-18-212-234-179.compute-1.amazonaws.com/api/users/preference/subcategory/update/');
    var userId = UserPreferences().getUserId();
    final String userToken = UserPreferences().getToken();

    final body = {
      "user": userId,
      "subcategory": subcategory.id,
      "status": subcategory.isSelected
    };

    final http.Response resp =
        await http.put(url, body: jsonEncode(body), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': userToken,
      'Cookie': 'jwt=$userToken'
    });
    print(resp);
  }

  void logOut() {
    final futures = <Future>[];

    final _prefs = UserPreferences();
    futures.add(_prefs.removeToken());
    futures.add(_prefs.removeUserId());

    Future.wait(futures).then((value) {
      Utils.mainNavigator.currentState.pushReplacementNamed(routeLogin);
    });
  }
}
