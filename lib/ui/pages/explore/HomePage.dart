import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tour_guide/data/entities/experience.dart';
import 'package:tour_guide/ui/bloc/permissionBloc.dart';
import 'package:tour_guide/ui/bloc/provider.dart';
import 'package:tour_guide/ui/bloc/placesBloc.dart';
import 'package:tour_guide/ui/bloc/userBloc.dart';
import 'package:tour_guide/ui/widgets/ExperiencesCarouselWidget.dart';
import 'package:tour_guide/ui/widgets/MapScreenWidget.dart';
import 'package:tour_guide/ui/widgets/SearchBarWidget.dart';

class HomePage extends StatefulWidget {
  Stream<int> streamExplorerTabIndex;
  HomePage(this.streamExplorerTabIndex);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  String _searchString = '';
  bool _isBottomSheetOpen = false;

  @override
  void initState() {
    super.initState();
    widget.streamExplorerTabIndex.listen((number) {
      Future.delayed(Duration.zero, () {
        _closeBottomSheet(context);
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
    final permissionBloc = Provider.permissionBlocOf(context);
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
                  Container(child: _handleMapCreation(permissionBloc, userBloc)),
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
    return StreamBuilder(
      stream: placesBloc.experiencesStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
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
                                style: TextStyle(color: Colors.white),
                              ),
                            ))
                          ])),
                      onTap: () {
                        _showBottomSheet(context);
                      },
                    ),
                  );
        }else{
          return Container();
        }
      },
    );
  }


  Widget _handleMapCreation(PermissionBloc permissionbloc, UserBloc userBloc) {
    return FutureBuilder(
      future: permissionbloc.requestLocationPermission(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data) {
            return _buildMap(userBloc);
          } else {
            return Center(child: Text("not available"));
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildMap(UserBloc userBloc) {
    return FutureBuilder(
      future: userBloc.getCurrentLocation(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return MapScreen(
              lat: snapshot.data.latitude,
              long: snapshot.data.longitude,
              );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildSearchResults(PlacesBloc placesBloc) {
    return StreamBuilder(
        stream: placesBloc.searchResultStream,
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData && snapshot.data.length > 0) {
            return Stack(children: [
              Container(color: Color.fromRGBO(255, 255, 255, 0.87)),
              Container(
                child: ListView(
                  children: snapshot.data
                      .map((result) => ListTile(
                            title: Text(result['description']),
                            onTap: () {
                              placesBloc.getExperiences(
                                  result["place_id"], "1");
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
  void _showBottomSheet(context) {
    Scaffold.of(context)
        .showBottomSheet((context) {
          _isBottomSheetOpen = true;
          return Container(
              //  decoration: BoxDecoration(
              //   borderRadius: BorderRadius.only(
              //     topLeft: Radius.circular(16.0),
              //     topRight: Radius.circular(16.0),
              //   ),
              color: Color.fromRGBO(79, 77, 140, 1),
              height: MediaQuery.of(context).size.height - 100.0,
              child: Stack(
                children: [
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
                ],
              ));
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
  }
}
