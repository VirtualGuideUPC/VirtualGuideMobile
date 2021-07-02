import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:tour_guide/data/entities/experience.dart';
import 'package:tour_guide/data/entities/experienceDetailed.dart';
import 'package:tour_guide/data/providers/experienceProvider.dart';
import 'package:tour_guide/data/providers/placesProvider.dart';

class PlacesBloc{
  PlacesProvider placesProvider=PlacesProvider();
  ExperienceProvider experienceProvider=ExperienceProvider();
  
  BehaviorSubject<List<dynamic>> _searchResultsController = BehaviorSubject<List<dynamic>>();
  Stream<List<dynamic>> get searchResultStream => _searchResultsController.stream;
  Function get changeSearchResult=>_searchResultsController.sink.add;
  List<dynamic> get searchResult => _searchResultsController.value;

  BehaviorSubject<List<Experience>> _experiencesController = BehaviorSubject<List<Experience>>();
  Stream<List<Experience>> get experiencesStream =>_experiencesController.stream;
  Function get changeExperiences=>_experiencesController.sink.add;
  List<Experience> get experiences => _experiencesController.value;


  void getLocations(String term)async{
      final results=await placesProvider.getLocations(term);
      changeSearchResult(results);
  }


  void getExperiences(String placeId, String userId) async{
    final Map locationDetail = await _getLocationDetail(placeId);
    final double lat=locationDetail["result"]["geometry"]["location"]["lat"];
    final double long=locationDetail["result"]["geometry"]["location"]["lng"];
    final List<Experience> experiences = await _getExperiences(userId,lat,long);
    changeExperiences(experiences);
    print("Experiencas encontradas -> " + experiences.length.toString());
  }
  Future<Map> _getLocationDetail(String placeId) async{
    final Map locationDetail=await placesProvider.getLocationDetail(placeId);
    return locationDetail;
  }
  Future<List<Experience>> _getExperiences(String userId, double lat, double lng)async{
    final List<Experience> experiences=await experienceProvider.getExperiences(userId, lat, lng);
    return experiences;
  }


  Future<ExperienceDetailed> getExperienceDetail(String experienceId) async{
    try {
      return await experienceProvider.getExperienceDetail(experienceId);
    } catch (e) {
      return Future.error(e);
    }
  }



  void dispose(){
    _searchResultsController?.close();
    _experiencesController?.close();
  }
}