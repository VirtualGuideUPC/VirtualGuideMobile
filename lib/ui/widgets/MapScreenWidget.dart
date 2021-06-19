import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tour_guide/data/entities/experience.dart';
import 'package:tour_guide/data/providers/experienceProvider.dart';
import 'package:tour_guide/ui/bloc/placesBloc.dart';
import 'package:tour_guide/ui/bloc/provider.dart';


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
          _goToPlace(snapshot.data[0]);
        }
        return GoogleMap(
          markers: Set<Marker>.of(markers),
          myLocationButtonEnabled:true,
          zoomControlsEnabled:false,
          initialCameraPosition:CameraPosition(target: LatLng(lat,long),zoom: 11.5),
          onMapCreated:(GoogleMapController controller){
            _mapController.complete(controller);
          }
        );
      }
    );
  }
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
  Future<void> _goToPlace(Experience experience)async{
    final GoogleMapController controller=await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target:LatLng(double.parse(experience.latitude),double.parse(experience.longitude)),
          zoom:14
        )
      )
    );
  }
}