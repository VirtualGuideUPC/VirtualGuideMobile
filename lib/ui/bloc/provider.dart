import 'package:flutter/material.dart';
import 'package:tour_guide/ui/bloc/login_bloc.dart';
import 'package:tour_guide/ui/bloc/signin_bloc.dart';

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
 
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc loginBlocOf ( BuildContext context ) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }
  static SigninBloc signinBlocOf ( BuildContext context ) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().signinBloc;
  }

  
}