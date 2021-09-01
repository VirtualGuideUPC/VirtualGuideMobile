import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tour_guide/data/datasource/userPreferences.dart';
import 'package:tour_guide/data/entities/department.dart';
import 'package:tour_guide/data/entities/experience.dart';
import 'package:tour_guide/data/entities/experienceDetailed.dart';

class ExperienceProvider{  
  Future<List<Experience>> getExperiences(String userId, double lat, double lng) async{
    final url=Uri.parse('https://virtualguide2.herokuapp.com/api/places/nearby/');
    final body = {
      'user_id':userId,
      'latitude':lat,
      'longitude':lng
    };
    final http.Response resp =
        await http.post(url,headers:{'Content-Type': 'application/json; charset=UTF-8',}, body: json.encode(body));

    if(resp.statusCode==200){
      List<dynamic> decodedJson = json.decode(resp.body);
      List<Experience>experiences=decodedJson.map((experienceJson){
        return Experience.fromJson(experienceJson);
      }).toList();
      return experiences;
    }else{
      return Future.error('500 Server Error');
    }

  }
  Future<ExperienceDetailed>getExperienceDetail(String experienceId) async{
    final url=Uri.parse('https://vguidebe.herokuapp.com/api/places/tp/$experienceId/');

    final String userToken=UserPreferences().getToken();
    
    final http.Response resp = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': userToken,
        'Cookie':'jwt=$userToken'
      }
    );
    print("resopnde c ode: " + resp.statusCode.toString());
    if(resp.statusCode==200){
      dynamic decodedJson = json.decode(resp.body);
      print(decodedJson);
      ExperienceDetailed experienceDetailed=ExperienceDetailed.fromJson(decodedJson);
      return experienceDetailed;
    }else{
      if(resp.statusCode==403){
        return Future.error('401');
      }else{
        return Future.error('500');
      }

    }
  }
  Future<List<Department>> getFavoriteExperiencesDepartments()async{
    final String userToken=UserPreferences().getToken();
    final int userId=UserPreferences().getUserId();

    final url=Uri.parse('https://vguidebe.herokuapp.com/api/users/$userId/favourites/departments/');//TODO: Correct url

    final http.Response resp = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': userToken,
        'Cookie':'jwt=$userToken'
      },
    );

    if(resp.statusCode==200){

      dynamic decodedJson = json.decode(resp.body); 
      List<Department> favoriteDepartments=decodedJson.map((item){return Department.fromJson(item);}).toList().cast<Department>();
      return favoriteDepartments;
    }else{
      if(resp.statusCode==403){
        return Future.error('401');
      }else{
        return Future.error('500');
      }
    }
  }
  
  Future<List<Experience>> getFavoriteExperiences(String departmentId) async{
    final String userToken=UserPreferences().getToken();
    final int userId=UserPreferences().getUserId();
    final url=Uri.parse('https://vguidebe.herokuapp.com/api/users/$userId/favourites/departments/$departmentId/');//TODO: Correct url

    final http.Response resp = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': userToken,
        'Cookie':'jwt=$userToken'
      },
    );
    print(resp.statusCode.toString());
    if(resp.statusCode==200){
      dynamic decodedJson = json.decode(resp.body);

      List<Experience> favoriteExperiences=decodedJson.map((item){return Experience.fromJson(item['touristic_place_detail']);}).toList().cast<Experience>();
      return favoriteExperiences;
    }else{
      if(resp.statusCode==403){
        return Future.error('401');
      }else{
        return Future.error('500');
      }
    }
  }
  Future postAddFavoriteExperience(String experienceId) async{
    final url=Uri.parse('https://vguidebe.herokuapp.com/api/users/favourite/create/');//TODO: Correct url
    
    final String userToken=UserPreferences().getToken();
    final int userId=UserPreferences().getUserId();

    final body = {
      'user':userId,
      'touristic_place':experienceId
    };

    final http.Response resp = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': userToken,
        'Cookie':'jwt=$userToken'
      },
      body:json.encode(body)
    );
      print("responde->>>" + resp.statusCode.toString());
  }

}