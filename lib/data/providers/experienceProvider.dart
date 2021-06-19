import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tour_guide/data/entities/experience.dart';

class ExperienceProvider{  
  Future<List<Experience>> getExperiences(String userId, double lat, double lng) async{
    final url=Uri.parse('https://vguidebe.herokuapp.com/api/places/nearby/');
    final body = {
      'user_id':userId,
      'latitude':lat,
      'longitude':lng
    };
    final http.Response resp =
        await http.post(url,headers:{'Content-Type': 'application/json; charset=UTF-8',}, body: json.encode(body));
    List<dynamic> decodedJson = json.decode(resp.body);
    List<Experience>experiences=decodedJson.map((experienceJson){
      return Experience.fromJson(experienceJson);
    }).toList();
    return experiences;
  }
}