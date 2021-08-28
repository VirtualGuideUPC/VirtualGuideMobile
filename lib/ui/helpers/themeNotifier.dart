import 'package:flutter/material.dart';
import 'package:tour_guide/ui/helpers/storeManager.dart';

class ThemeNotifier with ChangeNotifier {
  final darkTheme = ThemeData(
      scaffoldBackgroundColor: Color.fromRGBO(143, 142, 192, 1),
      dialogBackgroundColor: Color.fromRGBO(46, 65, 89, 1),
      primaryColor: Color.fromRGBO(143, 142, 192, 1),
      primarySwatch: Colors.grey,
      iconTheme: IconThemeData(color: Color.fromRGBO(0, 0, 0, 0.6)),
      cardColor: Colors.white70,
      textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.white),
          bodyText2: TextStyle(color: Color.fromRGBO(142, 152, 165, 1))),
      accentColor: Colors.white,
      canvasColor: Colors.transparent,
      buttonColor: Color.fromRGBO(143, 142, 192, 1));

  final lightTheme = ThemeData(
      scaffoldBackgroundColor: Color.fromRGBO(143, 142, 192, 1),
      dialogBackgroundColor: Colors.white,
      primaryColor: Color.fromRGBO(143, 142, 192, 1),
      primarySwatch: Colors.grey,
      iconTheme: IconThemeData(color: Color.fromRGBO(0, 0, 0, 0.6)),
      cardColor: Colors.white70,
      textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.black),
          bodyText2: TextStyle(color: Colors.grey.shade700)),
      accentColor: Colors.white,
      canvasColor: Colors.transparent,
      buttonColor: Color.fromRGBO(143, 142, 192, 1));

  ThemeData _themeData;
  ThemeData getTheme() => _themeData;

  bool _themeMode;
  bool getThemeMode() => _themeMode;

  ThemeNotifier() {
    StorageManager.readData('themeMode').then((value) {
      print('value read from storage: ' + value.toString());
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        _themeData = lightTheme;
        _themeMode = false;
      } else {
        print('setting dark theme');
        _themeData = darkTheme;
        _themeMode = true;
      }
      notifyListeners();
    });
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    _themeMode = true;
    StorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    _themeMode = false;
    StorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }
}
