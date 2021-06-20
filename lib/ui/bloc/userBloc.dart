import 'package:geolocator/geolocator.dart';
import 'package:tour_guide/data/entities/user.dart';
import 'package:tour_guide/data/providers/geolocationProvider.dart';

class UserBloc{
  final GeolocationProvider geolocationProvider=GeolocationProvider();
  

  //variables
  User user=User();
  Position currentLocation;

  Future<Position>getCurrentLocation() async{
    if(currentLocation==null){
      try {
          currentLocation=await geolocationProvider.getCurrentLocation();
      } catch (e) {
        return Future.error(e);
      }

    }
    return currentLocation;
  }
}