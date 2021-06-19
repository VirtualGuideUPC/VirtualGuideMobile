import 'package:permission_handler/permission_handler.dart';
class PermissionProvider{
  Future<bool> requestLocationPermission()async {
    var status=await Permission.location.status;
    if(!status.isDenied){
       return true;       
    }else{
      if (await Permission.location.request().isGranted) {
        return true;
      }
    }
    return false;
  }
  requestLocationService() async{
    if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {

    }else{

    }
  }
}