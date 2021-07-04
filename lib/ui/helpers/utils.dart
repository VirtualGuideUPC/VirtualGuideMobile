import 'package:flutter/material.dart';

class Utils{
  static GlobalKey<NavigatorState> mainNavigator=GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> homeNavigator=GlobalKey<NavigatorState>();

  static ImageProvider getPosterImage(String posterPath){
      if(posterPath!=null && posterPath.contains(RegExp(r'http',caseSensitive: false))){
          return NetworkImage(posterPath);
      }else{
          return AssetImage("assets/img/no-image.jpg");
      }
  }
}