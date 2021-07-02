import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tour_guide/data/datasource/userPreferences.dart';
import 'package:tour_guide/data/entities/department.dart';
import 'package:tour_guide/data/entities/experience.dart';
import 'package:tour_guide/data/entities/experienceDetailed.dart';

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

    // List<dynamic> decodedJson = json.decode(resp.body);
    List<dynamic> decodedJson = json.decode('''
    [
            {"id":5,"name": "Catedral Metropolitana de Lima","short_info": "Erigida en 1535 sobre un lugar de culto inca y el palacio del príncipe Sinchi Puma","latitude": "-12.176940560146516","longitude": "-77.19363137211922","picture": "https://res.cloudinary.com/djtqhafqe/image/upload/v1624847818/taller-desempe%C3%B1o-profesional/zvh35k5prbjy55p8m3hc.jpg","tp_range": 2,"province": "Lima","type_place": 1,"is_favorite": false,"avg_ranking": 4.5,"n_comments": 5},
            {"id":6,"name": "El Chocomuseo del centro de lima","short_info": "Una vez más, no es realmente un museo (aunque hay una sección que muestra el proceso de fabricación del chocolate)","latitude": "-11.076940560146516","longitude": "-76.09363137211922","picture": "https://res.cloudinary.com/djtqhafqe/image/upload/v1624848041/taller-desempe%C3%B1o-profesional/okg7ig82m8x7flfbw2dn.jpg","tp_range": 2,"province": "Lima","type_place": 1,"is_favorite": false,"avg_ranking": 2.5,"n_comments": 5},
            {"id":7,"name": "La Casa de Aliaga","short_info": "A una cuadra de la plaza se encuentra la residencia colonial más antigua de Lima (Principios del siglo XVI)","latitude": "-12.071940560146516","longitude": "-77.29363137211922","picture": "https://res.cloudinary.com/djtqhafqe/image/upload/v1624848140/taller-desempe%C3%B1o-profesional/cty7abflxmllr1pqefzf.jpg","tp_range": 2,"province": "Lima","type_place": 1,"is_favorite": false,"avg_ranking": 3.5,"n_comments": 5},
            {"id":8,"name": "Casa de Osambela","short_info": "cerca del Convento Santo Domingo, está la también llamada Casa de Oquendo, que fue una de las más grandes de su época.","latitude": "-13.076940560146516","longitude": "-78.09363137211922","picture": "https://res.cloudinary.com/djtqhafqe/image/upload/v1624848224/taller-desempe%C3%B1o-profesional/fb009tv0lutiw7zivzp3.jpg","tp_range": 2,"province": "Lima","type_place": 1,"is_favorite": false,"avg_ranking": 2.5,"n_comments": 5}
    ] 
    ''');
    ///////////////////////////
    List<Experience>experiences=decodedJson.map((experienceJson){
      return Experience.fromJson(experienceJson);
    }).toList();
    return experiences;
  }
  Future<ExperienceDetailed>getExperienceDetail(String experienceId) async{
    /*TODO: delete this*/ experienceId='5';
    final url=Uri.parse('https://vguidebe.herokuapp.com/api/places/tp/5/');

    final String userToken=UserPreferences().token;
    print("user token:->>>> "+ userToken);
    if(userToken==''){return Future.error('401');}
    print("user tokasdfasdfaen:->>>> "+ userToken.trim());
    
    final http.Response resp = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': userToken.trim()
      }
    );

    if(resp.statusCode==200){
      dynamic decodedJson = json.decode(resp.body);
      print(decodedJson);
      ExperienceDetailed experienceDetailed=ExperienceDetailed.fromJson(decodedJson);
      return experienceDetailed;
    }else{
      //return Future.error('500');
          dynamic decodedJson=json.decode('''
      {
  "pictures": [
    "https://res.cloudinary.com/djtqhafqe/image/upload/v1624852920/taller-desempe%C3%B1o-profesional/izqmkplkglmgjjvjpqqg.jpg",
    "https://res.cloudinary.com/djtqhafqe/image/upload/v1624852939/taller-desempe%C3%B1o-profesional/uujhmkfk4cz4slraq1nb.jpg",
    "https://res.cloudinary.com/djtqhafqe/image/upload/v1624852973/taller-desempe%C3%B1o-profesional/exzxys7naw3ilzrl4rqo.jpg",
    "https://res.cloudinary.com/djtqhafqe/image/upload/v1624853005/taller-desempe%C3%B1o-profesional/lxm8gjyb6arzv2j5jsmd.jpg"
  ],
  "name": "Machu Picchu",
  "long_info": "Machu Picchu (pronunciado /mɑtchu ˈpiktchu/ en quechua, «Monte viejo») es el nombre contemporáneo que se da a una llacta —antiguo poblado incaico andino— construida antes del siglo xv, ubicada en la Cordillera Oriental del sur de Perú, en la cadena montañosa de Los Andes a 2430 metros sobre el nivel del mar.",
  "types": [
    {
      "id": 6,
      "name": "Senderismo",
      "n_experiences": 8
    },
    {
      "id": 6,
      "name": "Senderismo",
      "n_experiences": 8
    }
  ],
  "latitude": "-12.076940560146516",
  "longitude": "-77.09363137211922",
  "ranking": 4.5,
  "number_comments": 12,
  "reviews": [
    {
      "id": 1,
      "user_name": "Diego",
      "profile_pic": "www.pic.com",
      "date": "2021-06-11",
      "comment": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec molestie odio id tellus aliquet sodales. Maecenas sed imperdiet est, ut aliquet quam. Sed varius condimentum interdum. Integer sit amet nisi eros. Aenean quis viverra leo. Proin iaculis convallis luctus. Sed pretium urna ut sem finibus, ac tempus justo bibendum. Aliquam erat volutpat. Phasellus dapibus enim eget tellus fringilla, ac finibus erat fermentum. In pulvinar finibus neque, sit amet posuere odio rutrum eu. Fusce pretium suscipit ultricies. In nisl mauris, scelerisque non dui eu, iaculis porttitor sem.",
      "ranking": 3
    },
    {
      "id": 2,
      "user_name": "Pepe",
      "profile_pic": "www.pic.com",
      "date": "2021-06-14",
      "comment": "Maecenas accumsan, risus eu fermentum varius, massa quam molestie libero, at fringilla dui magna eget dui. Nunc egestas ipsum eu cursus tincidunt. Sed velit dolor, euismod sit amet turpis id, fermentum pretium nisi. Duis at vestibulum tortor. Morbi vel leo ut enim fringilla iaculis. Suspendisse urna dolor, venenatis v!",
      "ranking": 4
    }
  ],
  "similar_experience": [
    {
      "id": 1,
      "name": "Montaña 7 colores",
      "pic": "https://res.cloudinary.com/djtqhafqe/image/upload/v1624908215/taller-desempe%C3%B1o-profesional/idv5uiht99whlhnlxyib.jpg",
      "is_favorite": false,
      "short_info": "asdasd"
    },
    {
      "id": 3,
      "name": "Coricancha",
      "pic": "https://res.cloudinary.com/djtqhafqe/image/upload/v1624908103/taller-desempe%C3%B1o-profesional/pyjoctif663ddfqn8og6.jpg",
      "is_favorite": true,
      "short_info": "asdasd"
    }
  ]
}
    ''');
      ExperienceDetailed experienceDetailed=ExperienceDetailed.fromJson(decodedJson);
      return experienceDetailed;
    }
  }
  Future<List<Department>> getFavoriteExperiencesDepartments()async{
    final url=Uri.parse('https://vguidebe.herokuapp.com/api/favorite_departments/');//TODO: Correct url
        final String userToken=UserPreferences().token;

    print("user token:->>>> "+ userToken);
    if(userToken==''){return Future.error('401');}
    print("user tokasdfasdfaen:->>>> "+ userToken.trim());

    final http.Response resp = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': userToken.trim()
      }
    );

    if(resp.statusCode==200){
      dynamic decodedJson = json.decode(resp.body);

      List<Department> favoriteDepartments=decodedJson.map((item){return Department.fromJson(item);});
      return favoriteDepartments;
    }else{
      //return Future.error('500');

      dynamic decodedJson=json.decode('''
        [
          {
            "id":1,
            "name":"Cuzco",
            "pictures":[
              "https://res.cloudinary.com/djtqhafqe/image/upload/v1624908215/taller-desempe%C3%B1o-profesional/idv5uiht99whlhnlxyib.jpg",
              "https://res.cloudinary.com/djtqhafqe/image/upload/v1624852973/taller-desempe%C3%B1o-profesional/exzxys7naw3ilzrl4rqo.jpg",
              "https://res.cloudinary.com/djtqhafqe/image/upload/v1624908103/taller-desempe%C3%B1o-profesional/pyjoctif663ddfqn8og6.jpg"

            ] 
          },
          {
            "id":2,
            "name":"Lima",
            "pictures":[
              "https://res.cloudinary.com/djtqhafqe/image/upload/v1624848224/taller-desempe%C3%B1o-profesional/fb009tv0lutiw7zivzp3.jpg",
              "https://res.cloudinary.com/djtqhafqe/image/upload/v1624848140/taller-desempe%C3%B1o-profesional/cty7abflxmllr1pqefzf.jpg",
              "https://res.cloudinary.com/djtqhafqe/image/upload/v1624847818/taller-desempe%C3%B1o-profesional/zvh35k5prbjy55p8m3hc.jpg"

            ] 
          }
        ]
      ''');
      List<Department> favoriteDepartments=decodedJson.map((item){return Department.fromJson(item);}).toList().cast<Department>();
      return favoriteDepartments;
    }

  }
}