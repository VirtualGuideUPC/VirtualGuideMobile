import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tour_guide/data/datasource/userPreferences.dart';

class UserProvider {
  final String _url = "https://vguidebe.herokuapp.com";
  final _prefs = new UserPreferences();
  Future<Map<String, dynamic>> signinUser(String name, String lastName,
      String email, String password, String birthDate, String country) async {
    final url = Uri.parse('https://vguidebe.herokuapp.com/api/users/register/');
    final authData = {
      'email': email,
      'password': password,
      'name': name,
      'last_name': lastName,
      'birthday': birthDate,
      'country': country
    };
    final http.Response resp =
        await http.post(url,headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',}, body: json.encode(authData));
    Map decodedJson = json.decode(resp.body);
    if (resp.statusCode==200) {
      //_prefs.token = decodedJson['jwt'];
      return {'ok': true, 'message':'operacion realizada con exito'};
    } else {
      String errorMsg;
      print(decodedJson);
      List<dynamic> responseValues=decodedJson.values.toList();
      if (responseValues.length>0 && responseValues[0] is List && responseValues[0].length>0) {
        errorMsg = responseValues[0][0];
      } else {
        errorMsg='Ocurrio un error, inténtelo nuevamente';
      }
      return {'ok': false, 'message': errorMsg};
    }
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final url = Uri.parse('https://vguidebe.herokuapp.com/api/users/login/');
    final authData = {'email': email, 'password': password};
    
    final http.Response resp =
        await http.post(
          url, 
          headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
          body: json.encode(authData)
        );

    Map decodedJson = json.decode(resp.body);
    if (resp.statusCode==200 && decodedJson.containsKey('jwt')){
      _prefs.token = decodedJson['jwt'];
      return {'ok': true, 'token': decodedJson['jwt']};
    } else {
      String errorMsg;
      if (decodedJson.containsKey('detail')) {
        errorMsg = decodedJson['detail'];
      } else {
        errorMsg='Ocurrio un error, inténtelo nuevamente';
      }
      return {'ok': false, 'message': errorMsg};
    }
  }
}
