import 'package:flutter/material.dart';
import 'package:tour_guide/ui/bloc/loginBloc.dart';
import 'package:tour_guide/ui/bloc/permissionBloc.dart';
import 'package:tour_guide/ui/bloc/placesBloc.dart';
import 'package:tour_guide/ui/bloc/signinBloc.dart';
import 'package:tour_guide/ui/bloc/userBloc.dart';

class Provider extends InheritedWidget {

  //singleton pattern
  static Provider _instancia;
  factory Provider({ Key key, Widget child }) {
    if ( _instancia == null ) {
      _instancia = new Provider._internal(key: key, child: child );
    }
    return _instancia;
  }
  Provider._internal({ Key key, Widget child })
    : super(key: key, child: child );


  //blocs
  final loginBloc = LoginBloc();
  final signinBloc=SigninBloc();
  final placesBloc=PlacesBloc();
  final userBloc=UserBloc();
  final permissionBloc=PermissionBloc();
 
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc loginBlocOf ( BuildContext context ) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }
  static SigninBloc signinBlocOf ( BuildContext context ) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().signinBloc;
  }
  static PlacesBloc placesBlocOf(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>().placesBloc;
  }
  static UserBloc userBlocOf(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>().userBloc;
  }
    static PermissionBloc permissionBlocOf(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>().permissionBloc;
  }
}