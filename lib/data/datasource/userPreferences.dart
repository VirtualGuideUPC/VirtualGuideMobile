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
  
  String getToken(){return _prefs.getString('token')??'';}
  Future<bool> setToken(String token){return _prefs.setString('token', token);}
  Future<bool> removeToken(){return _prefs.remove('token');}

  int getUserId(){return _prefs.getInt('user_id')??-1;}
  Future<bool> setUserId(int userId){return _prefs.setInt('user_id', userId);}
  Future<bool> removeUserId(){return _prefs.remove('user_id');}

}