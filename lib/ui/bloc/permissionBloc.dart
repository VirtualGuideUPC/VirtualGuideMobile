import 'package:rxdart/rxdart.dart';
import 'package:tour_guide/data/providers/permissionProvider.dart';

class PermissionBloc{
    PermissionProvider _permissionProvider=PermissionProvider();

    final _locationPermissionController = BehaviorSubject<bool>();
    final _locationServiceController=BehaviorSubject<bool>();

    Stream<bool> get locationPermissionStream    => _locationPermissionController.stream;
    Stream<bool> get locationServiceStream => _locationServiceController.stream;

    Function(bool) get changeLocationPermission    => _locationPermissionController.sink.add;
    Function(bool) get changeServicePermission => _locationServiceController.sink.add;

    bool get locationPermission    => _locationPermissionController.value;
    bool get locationService => _locationServiceController.value;

    Future<bool> requestLocationPermission()async{
      bool locationPermissionGranted= await _permissionProvider.requestLocationPermission();
      bool locationServiceGranted=await _permissionProvider.requestLocationService();
      if(locationPermissionGranted && locationServiceGranted){
        return true;
      }else{
        return false;
      }
    }

    dispose(){
      _locationPermissionController?.close();
      _locationServiceController?.close();
    }
}