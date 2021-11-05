import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tour_guide/data/datasource/userPreferences.dart';
import 'package:tour_guide/data/entities/department.dart';
import 'package:tour_guide/data/entities/experience.dart';
import 'package:tour_guide/data/entities/experienceDetailed.dart';

class ExperienceProvider {
  Future<List<Experience>> getExperiences(
      int userId, double lat, double lng) async {
    //final url = Uri.parse('http://demo9889835.mockable.io/alpakitaPlaces');
    final url = Uri.parse(
        'http://ec2-18-212-234-179.compute-1.amazonaws.com/api/places/nearby/');
    print("hey! user id $userId");
    print("hey! lat $lat");
    print("hey! lng $lng");
    final body = {'user_id': userId, 'latitude': lat, 'longitude': lng};
    final http.Response resp = await http.post(url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(body));

    if (resp.statusCode == 200) {
      List<dynamic> decodedJson = json.decode(resp.body);
      List<Experience> experiences = decodedJson.map((experienceJson) {
        return Experience.fromJson(experienceJson);
      }).toList();
      return experiences;
    } else {
      return Future.error('500 Server Error');
    }
  }

  Future<ExperienceDetailed> getExperienceDetail(String experienceId) async {
    final int userId = UserPreferences().getUserId();

    final url = Uri.parse(
        'http://ec2-18-212-234-179.compute-1.amazonaws.com/api/places/tp/$experienceId/$userId');

    //final url = Uri.parse('http://demo7092181.mockable.io/detail');

    final String userToken = UserPreferences().getToken();

    final http.Response resp = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': userToken,
        'Cookie': 'jwt=$userToken',
      },
    );

    print("resopnde c ode: " + resp.statusCode.toString());
    if (resp.statusCode == 200) {
      dynamic decodedJson =
          json.decode(Utf8Decoder().convert(resp.bodyBytes).toString());
      ExperienceDetailed experienceDetailed =
          ExperienceDetailed.fromJson(decodedJson);
      return experienceDetailed;
    } else {
      if (resp.statusCode == 403) {
        return Future.error('401');
      } else {
        return Future.error('500');
      }
    }
  }

  Future<List<Department>> getFavoriteExperiencesDepartments() async {
    final String userToken = UserPreferences().getToken();
    final int userId = UserPreferences().getUserId();

    final url = Uri.parse(
        'http://ec2-18-212-234-179.compute-1.amazonaws.com/api/users/$userId/favourites/departments/');

    final http.Response resp = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': userToken,
        'Cookie': 'jwt=$userToken'
      },
    );

    if (resp.statusCode == 200) {
      dynamic decodedJson = json.decode(resp.body);
      List<Department> favoriteDepartments = decodedJson
          .map((item) {
            return Department.fromJson(item);
          })
          .toList()
          .cast<Department>();
      return favoriteDepartments;
    } else {
      if (resp.statusCode == 403) {
        return Future.error('401');
      } else {
        return Future.error('500');
      }
    }
  }

  Future<List<Experience>> getFavoriteExperiences(String departmentId) async {
    final String userToken = UserPreferences().getToken();
    final int userId = UserPreferences().getUserId();
    final url = Uri.parse(
        'http://ec2-18-212-234-179.compute-1.amazonaws.com/api/users/$userId/favourites/departments/$departmentId/');

    final http.Response resp = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': userToken,
        'Cookie': 'jwt=$userToken'
      },
    );
    print(resp.statusCode.toString());
    if (resp.statusCode == 200) {
      dynamic decodedJson = json.decode(resp.body);

      List<Experience> favoriteExperiences = decodedJson
          .map((item) {
            return Experience.fromJson(item['touristic_place_detail']);
          })
          .toList()
          .cast<Experience>();
      return favoriteExperiences;
    } else {
      if (resp.statusCode == 403) {
        return Future.error('401');
      } else {
        return Future.error('500');
      }
    }
  }

  Future<bool> postAddFavoriteExperience(String experienceId) async {
    final url = Uri.parse(
        'http://ec2-18-212-234-179.compute-1.amazonaws.com/api/users/favourite/create/');
    final String userToken = UserPreferences().getToken();
    final int userId = UserPreferences().getUserId();

    final body = {'user': userId, 'touristic_place': int.parse(experienceId)};

    final http.Response resp = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': userToken,
          'Cookie': 'jwt=$userToken'
        },
        body: json.encode(body));
    if (resp.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteFavoriteExperience(String experienceId) async {
    final String userToken = UserPreferences().getToken();
    final int userId = UserPreferences().getUserId();

    final url = Uri.parse(
        'http://ec2-18-212-234-179.compute-1.amazonaws.com/api/users/favourite/${userId}/${experienceId}/');

    final http.Response resp = await http.delete(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': userToken,
      'Cookie': 'jwt=$userToken'
    });

    if (resp.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
