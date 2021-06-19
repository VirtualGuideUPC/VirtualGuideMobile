import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class PlacesProvider{
  String _apiKey='AIzaSyDtAr_TPakwmocvoOp-poGun0sII4a7o-0';


  Future<List<dynamic>> getLocations(String searchTerm) async{
    final url=Uri.parse('https://maps.googleapis.com/maps/api/place/autocomplete/json?key=$_apiKey&input=$searchTerm');
    try {
      final requestStartMoment=DateTime.now();

      final resp=await http.get(url);
      final decodedJson=json.decode(resp.body);
      
      final requestEndMoment=DateTime.now();

      if(requestEndMoment.difference(requestStartMoment).inSeconds>1){
        return [];
      }else{
        //print(decodedJson);
        return decodedJson['predictions'];
      }

    } catch (e) {
      print(e);
      return [];
    }

  }
  Future<Map> getLocationDetail(String placeId) async{
    final url=Uri.parse('https://maps.googleapis.com/maps/api/place/details/json?key=$_apiKey&place_id=$placeId');

    final resp=await http.get(url);
    final decodedJson=json.decode(resp.body);

    return decodedJson;
  }
}