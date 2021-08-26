import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tour_guide/data/datasource/userPreferences.dart';
import 'package:tour_guide/data/entities/user.dart';
import 'package:tour_guide/ui/helpers/utils.dart';
import 'package:tour_guide/ui/routes/routes.dart';

class UserProvider {
  final _prefs = new UserPreferences();
  Future<String> signinUser(String name, String lastName, String email,
      String password, String birthDate, String country) async {
    final url =
        Uri.parse('https://virtualguide2.herokuapp.com/api/users/register/');
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
    final url =
        Uri.parse('https://virtualguide2.herokuapp.com/api/users/login/');
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

  Future<User> getUserProfile() async {
    final url =
        Uri.parse('https://virtualguide2.herokuapp.com/api/users/user/');

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
