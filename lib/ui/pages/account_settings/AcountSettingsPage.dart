import 'package:flutter/material.dart';
import 'package:tour_guide/data/datasource/userPreferences.dart';
import 'package:tour_guide/main.dart';
import 'package:tour_guide/ui/helpers/utils.dart';
import 'package:tour_guide/ui/routes/routes.dart';

class AccountSettingsPage extends StatefulWidget {
  AccountSettingsPage({Key key}) : super(key: key);

  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final _screenSize=MediaQuery.of(context).size;
    return Scaffold(
      body:Container(
        width: double.infinity,
        color: Colors.white,
        child:Column(
          children: [
            ElevatedButton(
              child: Text("Lugares Favoritos"),
              onPressed: (){Utils.homeNavigator.currentState.pushNamed(routeHomeFavoriteDepartmentsPage);},),
            ElevatedButton(
              child: Text("LOGOUT"),
              onPressed: (){
                final futures=<Future>[];

                final _prefs=UserPreferences();
                futures.add(_prefs.removeToken());
                futures.add(_prefs.removeUserId());

                Future.wait(futures).then((value){
                  Utils.mainNavigator.currentState.pushReplacementNamed(routeLogin);
                });
              },),
          ],
        )
      ),
    );
  }
}