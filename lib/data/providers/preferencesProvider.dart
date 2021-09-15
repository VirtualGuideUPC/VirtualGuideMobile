import 'dart:convert';

import 'package:tour_guide/data/datasource/userPreferences.dart';
import 'package:tour_guide/data/entities/preferences.dart';
import 'package:http/http.dart' as http;

class PreferencesProvider {
  Future<Preferences> getPreferencesByUser() async {
    final String userToken = UserPreferences().getToken();

    var id = UserPreferences().getUserId();

    final url = Uri.parse(
        'http://ec2-34-226-195-132.compute-1.amazonaws.com/api/users/preferences/$id/');

    final http.Response resp = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': userToken,
      'Cookie': 'jwt=$userToken'
    });

    print("resopnde code: " + resp.statusCode.toString());

    if (resp.statusCode == 200) {
      var decodedJson =
          json.decode(Utf8Decoder().convert(resp.bodyBytes).toString());
      var preferences = Preferences.fromJson(decodedJson);
      return preferences;
    } else {
      if (resp.statusCode == 403) {
        return Future.error('401');
      } else {
        return Future.error('500');
      }
    }
  }
}
