import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _initialCameraPosition=CameraPosition(
    target:LatLng(37,-122),
    zoom:11.5
  );
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      myLocationButtonEnabled:false,
      zoomControlsEnabled:false,
      initialCameraPosition:_initialCameraPosition,
    );
  }
}