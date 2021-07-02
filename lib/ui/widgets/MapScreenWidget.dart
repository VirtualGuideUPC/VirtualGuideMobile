import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tour_guide/data/entities/experience.dart';
import 'package:tour_guide/ui/bloc/placesBloc.dart';
import 'package:tour_guide/ui/bloc/provider.dart';
import 'package:tour_guide/ui/bloc/userBloc.dart';


class MapScreen extends StatelessWidget {
  final double lat;
  final double long;
  final Completer<GoogleMapController> _mapController=Completer();
  MapScreen({this.lat,this.long});
  @override
  Widget build(BuildContext context) {
    PlacesBloc placesBloc=Provider.placesBlocOf(context);
    return StreamBuilder<List<Experience>>(
      stream: placesBloc.experiencesStream,
      builder: (context,AsyncSnapshot snapshot) {
        List<Marker> markers=[];
        if(snapshot.hasData && snapshot.data.length>0){
          markers=createMarkersFromExperiences(snapshot.data);
          double lat=double.parse(snapshot.data[0].latitude);
          double lng=double.parse(snapshot.data[0].longitude);
          _goToPlace(lat,lng);
        }
        return Stack(
          children: [

            GoogleMap(
              markers: Set<Marker>.of(markers),
              myLocationButtonEnabled:true,
              zoomControlsEnabled:false,
              initialCameraPosition:CameraPosition(target: LatLng(lat,long),zoom: 11.5),
              onMapCreated:(GoogleMapController controller){
                _mapController.complete(controller);
              },
            ),

            // Positioned(
            //   top:10,
            //   right:10,
            //   child: 
            //   GestureDetector(
            //     onTap: (){
            //       _alertMyLocationResult(context,userBloc);
            //     },
            //     child: CircleAvatar(
                  
            //       backgroundColor: Colors.red,
            //       child: Icon(Icons.my_location),),
            //   )),
          ],
        );
      }
    );
  }
  // _alertMyLocationResult(BuildContext context, UserBloc userBloc{
  //   return FutureBuilder(
  //     future: userBloc.getCurrentLocation(),
  //     builder: (BuildContext context, AsyncSnapshot snapshot) {
  //       if(snapshot.hasData){
          
  //       }
  //     },
  //   );
  // }
//   _showErrorAlert(BuildContext context, String message){
//                     showDialog(
//                     context: context,
//                     barrierDismissible: true,
//                     builder: (context) {
//                       return AlertDialog(
//                         backgroundColor: Colors.white,
//                         shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0) ),
//                         title: Text('Ocurrio un problema'),
//                         content: Column(mainAxisSize: MainAxisSize.min, children:[ Center(child: Text(message))]),
//                         actions: <Widget>[
//                           TextButton(
//                             child: Text('Ok'),
//                             onPressed: (){
//                               Navigator.of(context).pop();
//                             },
//                           ),
//                         ],
//                       );
//                     });
// }
  List<Marker> createMarkersFromExperiences( List<Experience> experiences){
    return experiences.map((experience){
      return Marker(
        markerId: MarkerId(experience.name),
        draggable: false,
        visible: true,
        infoWindow: InfoWindow(
            title: experience.name, snippet: experience.shortInfo),
        position: LatLng(double.parse(experience.latitude),
            double.parse(experience.longitude))
      );
    }).toList();
  }
  Future<void> _goToPlace(double latitude, double longitude)async{
    final GoogleMapController controller=await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target:LatLng(latitude,longitude),
          zoom:14
        )
      )
    );
  }
}