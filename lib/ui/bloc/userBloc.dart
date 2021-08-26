import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tour_guide/data/datasource/userPreferences.dart';
import 'package:tour_guide/data/entities/user.dart';
import 'package:tour_guide/data/providers/geolocationProvider.dart';
import 'package:tour_guide/data/providers/userProvider.dart';
import 'package:tour_guide/ui/helpers/utils.dart';
import 'package:tour_guide/ui/routes/routes.dart';

class UserBloc {
  final GeolocationProvider geolocationProvider = GeolocationProvider();

  PublishSubject<User> _userProfileController = PublishSubject<User>();
  Stream<User> get userProfileStream => _userProfileController.stream;
  Function get changeUserProfile => _userProfileController.sink.add;

  //variables
  User user = User();
  Position currentLocation;

  Future<Position> getCurrentLocation() async {
    if (currentLocation == null) {
      try {
        currentLocation = await geolocationProvider.getCurrentLocation();
      } catch (e) {
        return Future.error(e);
      }
    }
    return currentLocation;
  }

  Future<User> getUserProfile() async {
    var user = await UserProvider().getUserProfile();

    changeUserProfile(user != null ? user : new User());
  }
}
