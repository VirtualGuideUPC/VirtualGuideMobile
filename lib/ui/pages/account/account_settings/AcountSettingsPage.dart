import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_guide/data/entities/user.dart';
import 'package:tour_guide/data/providers/userProvider.dart';
import 'package:tour_guide/ui/helpers/themeNotifier.dart';
import 'package:tour_guide/ui/bloc/userBloc.dart';
import 'package:tour_guide/ui/helpers/utils.dart';
import 'package:tour_guide/ui/pages/account/account_information/AccountInformation.dart';
import 'package:tour_guide/ui/routes/routes.dart';

class AccountSettingsPage extends StatefulWidget {
  AccountSettingsPage({Key key}) : super(key: key);

  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  var userBloc = UserBloc();

  @override
  void initState() {
    userBloc.getUserProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    final _screenHeight = _screenSize.height - kToolbarHeight;

    var themeProvider = Provider.of<ThemeNotifier>(context);

    Widget _avatar(User profile) {
      return Container(
        width: _screenSize.width,
        height: _screenHeight * 0.15,
        padding: EdgeInsets.only(top: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage:
                  NetworkImage(profile.icon != null ? profile.icon : ""),
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: Text(
                "Hola ${profile.name}!",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyText1.color),
              ),
            )
          ],
        ),
      );
    }

    Widget _title(String title) {
      return Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Text(
            title,
            style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).textTheme.bodyText2.color,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 15,
          )
        ],
      );
    }

    Widget _section(String title, Function onPressed) {
      return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Expanded(
          child: Material(
            shape: Border(bottom: BorderSide(width: 2, color: Colors.grey)),
            child: TextButton(
              style: TextButton.styleFrom(
                  primary: Theme.of(context).textTheme.bodyText1.color),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                ),
              ),
              onPressed: onPressed,
            ),
          ),
        ),
      ]);
    }

    Widget _logOutButton = Align(
      alignment: Alignment.bottomCenter,
      child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(primary: Colors.red),
          onPressed: () {
            UserProvider().logOut();
          },
          icon: Icon(
            Icons.logout,
            color: Colors.white,
          ),
          label: Text(
            "Cerrar Sesión",
            style: TextStyle(color: Colors.white),
          )),
    );

    Widget _loader = Container(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.white,
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ));

    Widget _switcher(String title) {
      return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Expanded(
          child: Material(
            shape: Border(bottom: BorderSide(width: 2, color: Colors.grey)),
            child: TextButton(
              style: TextButton.styleFrom(
                  primary: Theme.of(context).textTheme.bodyText1.color),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                    ),
                    Switch(
                        activeColor: Colors.teal,
                        value: themeProvider.getThemeMode(),
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              themeProvider.setDarkMode();
                            } else {
                              themeProvider.setLightMode();
                            }
                          });
                        })
                  ],
                ),
              ),
              onPressed: () {
                setState(() {
                  if (themeProvider.getThemeMode() == true) {
                    themeProvider.setLightMode();
                  } else {
                    themeProvider.setDarkMode();
                  }
                });
              },
            ),
          ),
        ),
      ]);
    }

    return Scaffold(
      body: StreamBuilder(
        stream: userBloc.userProfileStream,
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            var userProfile = snapshot.data as User;
            return Container(
                width: _screenSize.width,
                height: _screenHeight,
                color: Theme.of(context).dialogBackgroundColor,
                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                child: Stack(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _avatar(userProfile),
                      _title("CONFIGURACIÓN DE LA CUENTA"),
                      _section("Información personal", () {
                        Utils.homeNavigator.currentState
                            .push(MaterialPageRoute(builder: (builder) {
                          return AccountInformationPage(userProfile);
                        }));
                      }),
                      _section("Mis preferencias", () {
                        Utils.homeNavigator.currentState.pushNamed(
                          routeHomeAccountPreferencesPage,
                        );
                      }),
                      _switcher("Modo oscuro"),
                      _section("Mis lugares favoritos", () {
                        Utils.homeNavigator.currentState
                            .pushNamed(routeHomeFavoriteDepartmentsPage);
                      }),
                      _section("Recopilación de experiencias", () {
                        Utils.homeNavigator.currentState.pushNamed(
                          routeHomeAccountReviewsPage,
                        );
                      }),
                    ],
                  ),
                  _logOutButton
                ]));
          } else {
            return _loader;
          }
        },
      ),
    );
  }
}
