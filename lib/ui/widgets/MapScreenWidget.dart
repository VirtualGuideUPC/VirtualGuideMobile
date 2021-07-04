import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tour_guide/data/entities/experience.dart';

class MapScreen extends StatefulWidget {
  final double startLat;
  final double startLng;
  final double endLat;
  final double endLng;
  final List<Marker> markersList;

  MapScreen({this.startLat,this.startLng,this.endLat,this.endLng,this.markersList});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _mapController=Completer();

  @override
  Widget build(BuildContext context) {
    print(widget.endLng.toString() + "   :::   " + widget.endLng.toString());
    _goToPlace(widget.endLat,widget.endLng);
    return Stack(
      children: [
        GoogleMap(
          markers: Set<Marker>.of(widget.markersList),
          myLocationButtonEnabled:true,
          zoomControlsEnabled:false,
          initialCameraPosition:CameraPosition(target: LatLng(widget.startLat,widget.startLng),zoom: 11.5),
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