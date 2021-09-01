import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tour_guide/data/entities/experience.dart';
import 'package:tour_guide/ui/bloc/permissionBloc.dart';
import 'package:tour_guide/ui/bloc/provider.dart';
import 'package:tour_guide/ui/bloc/placesBloc.dart';
import 'package:tour_guide/ui/bloc/userBloc.dart';
import 'package:tour_guide/ui/pages/explore/DropDownSheetWidget.dart';
import 'package:tour_guide/ui/pages/explore/ExperiencesCarouselWidget.dart';
import 'package:tour_guide/ui/widgets/MapScreenWidget.dart';
import 'package:tour_guide/ui/widgets/SearchBarWidget.dart';

class ExplorePage extends StatefulWidget {
  //final Stream<int> streamExplorerTabIndex;
  //ExplorePage(/*this.streamExplorerTabIndex*/);
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with AutomaticKeepAliveClientMixin<ExplorePage> {
  String _searchString = '';
  bool _isBottomSheetOpen = false;

  Future<Position> futureUserPosition;
  final Map defaultCameraPosition={'lat':-12.02434966783591,'lng':-77.10855891728943};
  Map<String,double> oldCameraPosition={'lat':null,'lng':null};
  Map<String,double> newCameraPosition={'lat':null,'lng':null};
  List<Marker> mapMarkersList=<Marker>[];

  StreamSubscription subscriptionExperiences;
  @override
  void initState() {
    super.initState();

    futureUserPosition=UserBloc().getCurrentLocation();
    futureUserPosition.catchError((error){
      Future.delayed(Duration.zero, () => _showErrorAlert(error.toString()));
    });

    // widget.streamExplorerTabIndex.listen((number) {
    //   Future.delayed(Duration.zero, () { // Para obtener del context en este metodo
    //     _closeBottomSheet(context);
    //   });
    // });
    Future.delayed(Duration.zero, () {
      final placesBloc = Provider.placesBlocOf(context);
      subscriptionExperiences=placesBloc.experiencesStream.listen((event) {
        if(event!=null){
          if(event.length>0){
            newCameraPosition['lat']=double.parse(event[0].latitude);
            newCameraPosition['lng']=double.parse(event[0].longitude);
          }
          
          mapMarkersList=_createMapMarkersFromExperiences(event);
        }

        setState(() {});
      });
    });

  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(context) {
    super.build(context);
    final userBloc = Provider.userBlocOf(context);
    final placesBloc = Provider.placesBlocOf(context);
    // final permissionBloc = Provider.permissionBlocOf(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: SearchBarWidget(
                key: UniqueKey(),
                onCleanField: () {
                  placesBloc.changeSearchResult([]);
                },
                onchangeValue: (val) {
                  _searchString = val;
                  print(val);
                  placesBloc.getLocations(_searchString);
                },
                onEditingComplete: () {},
              ),
            ),
            Expanded(
              child: Stack(
                fit: StackFit.loose,
                children: [
                  Container(child: _buildMap(userBloc)),
                  _buildSearchResults(placesBloc),
                  _buildCarousel(placesBloc),
                  _buildFooter(placesBloc)
                ],
              ),
            )
          ],
        ));
  }
  Widget _buildCarousel(PlacesBloc placesBloc){
    return StreamBuilder(
      stream: placesBloc.experiencesStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.hasData){
          return Positioned(
            height: 120,
            bottom: 75,
            left:0,
            right:0,
            child: ExperiencesCarousel(experiences: snapshot.data));
        }else{
          return Container();
        }
      },
    );
  }
  Widget _buildFooter(PlacesBloc placesBloc){
    return StreamBuilder<List<Experience>>(
      stream: placesBloc.experiencesStream ,
      builder: (BuildContext context, AsyncSnapshot<List<Experience>> snapshot){
        if(snapshot.hasData){
            final numberExperiences=snapshot.data.length;
            String message="";
            if(numberExperiences==0){
              message="No se encontraron experiencias";
            }else if(numberExperiences==1){
              message=numberExperiences.toString() + " Experiencia encontrada";
            }else{
              message=numberExperiences.toString() + " Experiencias encontradas";
            }


            return  Positioned(
                    height: 60,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: GestureDetector(
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            ),
                            color: Color.fromRGBO(79, 77, 140, 1),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          height: 56.0,
                          child: Stack(children: [
                            Container(
                              width: double.infinity,
                              height: 20,
                              child: Center(
                                child: Container(
                                  width: 100,
                                  height: 3,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                                child: Center(
                              child: Text(
                                message,
                                style: TextStyle(color: Colors.white,fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ))
                          ])),
                      onTap: () {
                        _showBottomSheet(snapshot.data,message,context);
                      },
                    ),
                  );
        }else{
          return Container();
        }
      },
    );
  }


  // Widget _handleMapCreation(PermissionBloc permissionbloc, UserBloc userBloc) {
  //   return FutureBuilder(
  //     future: permissionbloc.requestLocationPermission(),
  //     builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
  //       if (snapshot.hasData) {
  //         return _buildMap(userBloc);
  //       } else {
  //         return Center(child:Text("ESPERANDO PERMISO Y SERVICIO"));
  //       }
  //     },
  //   );dd
  // }

  Widget _buildMap( UserBloc userBloc) {
    if(oldCameraPosition['lat']==null || oldCameraPosition['lng']==null){
        return FutureBuilder(
          future: futureUserPosition,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              oldCameraPosition['lat']=snapshot.data.latitude;
              oldCameraPosition['lng']=snapshot.data.longitude;
              return MapScreen(
                  startLat: oldCameraPosition['lat'],
                  startLng: oldCameraPosition['lng'],
                  endLat:  oldCameraPosition['lat'],
                  endLng:  oldCameraPosition['lng'],
                  markersList: mapMarkersList,
                  );
            } else if(snapshot.hasError) {
              oldCameraPosition['lat']=defaultCameraPosition['lat'];
              oldCameraPosition['lng']=defaultCameraPosition['lng'];
              return MapScreen(
                  startLat: oldCameraPosition['lat'],
                  startLng: oldCameraPosition['lng'],
                  endLat:  oldCameraPosition['lat'],
                  endLng:  oldCameraPosition['lng'],
                  markersList: mapMarkersList
                  );
            }else{
              return Center(
                child: Text("ESPERANDO UBICACION DEL USUARIO"),
              );
            }
          },
        );
    }else{
      if(newCameraPosition['lat']==null || newCameraPosition['lng']==null){
        newCameraPosition['lat']=oldCameraPosition['lat'];
        newCameraPosition['lng']=oldCameraPosition['lng'];
      }
      print(newCameraPosition['lat']);
      print(newCameraPosition['lng']);
      Widget map= MapScreen(
        startLat: oldCameraPosition['lat'],
        startLng: oldCameraPosition['lng'],
        endLat:  newCameraPosition['lat'],
        endLng:  newCameraPosition['lng'],
        markersList: mapMarkersList
      );
      oldCameraPosition['lat']=newCameraPosition['lat'];
      oldCameraPosition['lng']=newCameraPosition['lng'];
      return map;
    }
  }
_showErrorAlert(String message){
                    showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0) ),
                        title: Text('Ocurrio un problema'),
                        content: Column(mainAxisSize: MainAxisSize.min, children:[ Center(child: Text(message))]),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Ok'),
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
}
  Widget _buildSearchResults(PlacesBloc placesBloc) {
    return StreamBuilder(
        stream: placesBloc.searchResultStream,
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData && snapshot.data.length > 0) {
            //filtering places
            final rx=RegExp(r'Peru',caseSensitive:false);
            List<dynamic>places=snapshot.data.where((element){
              if(element['description'].contains(rx)){return true;}
              else{return true;}
            }).toList();

            return Stack(children: [
              Container(color: Color.fromRGBO(255, 255, 255, 0.87)),
              Container(
                child: ListView(
                  children: places
                      .map((result) => ListTile(
                            title: Text(result['description']),
                            onTap: ()  async{
                              final Map locationDetail= await placesBloc.getLocationDetail(result['place_id']);
                              final double lat=locationDetail["result"]["geometry"]["location"]["lat"];
                              final double long=locationDetail["result"]["geometry"]["location"]["lng"];
                              newCameraPosition['lat']=lat;
                              newCameraPosition['lng']=long;
                              placesBloc.getExperiences("1",lat,long);
                              FocusScope.of(context).requestFocus(new FocusNode());
                              placesBloc.changeSearchResult([]);

                            },
                          ))
                      .toList(),
                ),
              )
            ]);
          } else {
            return Container();
          }
        });
  }
  void _showBottomSheet(List<Experience>experiences,String title,BuildContext context) {
    Scaffold.of(context)
        .showBottomSheet((context) {
          _isBottomSheetOpen = true;
          return DropdownSheet(experiences: experiences,title: title,);
        })
        .closed
        .whenComplete(() {
          _isBottomSheetOpen = false;
        });
  }
  void _closeBottomSheet(context) {
    if (_isBottomSheetOpen) {
      Navigator.pop(context);
    }
  }
  @override
  void dispose() {
    super.dispose();
    subscriptionExperiences.cancel();
  }

  
  List<Marker> _createMapMarkersFromExperiences( List<Experience> experiences){
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
}
