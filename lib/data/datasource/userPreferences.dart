import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences{
  //Singleton pattern
  static final UserPreferences _instancia = new UserPreferences._internal();
  factory UserPreferences() {
    return _instancia;
  }
  UserPreferences._internal();


  SharedPreferences _prefs;
  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }
  
  get token {
    return _prefs.getString('token') ?? '';
  }
  set token(String token){
    _prefs.setString('token', token);
  }
}