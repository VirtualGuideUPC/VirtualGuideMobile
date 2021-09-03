import 'package:flutter/material.dart';
import 'package:tour_guide/data/entities/preferences.dart';
import 'package:tour_guide/ui/bloc/preferencesBloc.dart';
import 'package:tour_guide/ui/pages/account/account_preferences/AccountPreferencesCard.dart';

class AccountPreferencesPage extends StatefulWidget {
  AccountPreferencesPage();

  @override
  _AccountPreferencesPageState createState() => _AccountPreferencesPageState();
}

class _AccountPreferencesPageState extends State<AccountPreferencesPage> {
  PreferencesBloc preferencesBloc = PreferencesBloc();

  @override
  void initState() {
    preferencesBloc.getPreferencesData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _screenHeight = MediaQuery.of(context).size.height - kToolbarHeight;
    var _screenWidth = MediaQuery.of(context).size.width;

    Widget _loader = Container(
        color: Theme.of(context).dialogBackgroundColor,
        child: Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.white,
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ));

    Widget _categories(List<Category> categories) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        height: _screenHeight * 0.3,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text("CATEGORIAS",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 17,
                          color: Theme.of(context).textTheme.bodyText2.color,
                          fontWeight: FontWeight.w400)),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: PageView.builder(
                  physics: BouncingScrollPhysics(),
                  controller:
                      PageController(initialPage: 0, viewportFraction: 0.95),
                  itemCount: categories.length,
                  itemBuilder: (ctx, indx) {
                    return AccountPreferencesCard(
                      name: categories[indx].name,
                      icon: categories[indx].icon,
                    );
                  }),
            )
          ],
        ),
      );
    }

    Widget _typeplaces(List<TypePlaces> typeplaces) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        height: _screenHeight * 0.3,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text("TIPOS DE LUGARES",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 17,
                          color: Theme.of(context).textTheme.bodyText2.color,
                          fontWeight: FontWeight.w400)),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: PageView.builder(
                  controller:
                      PageController(initialPage: 0, viewportFraction: 0.95),
                  itemCount: typeplaces.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (ctx, indx) {
                    return AccountPreferencesCard(
                      name: typeplaces[indx].name,
                      icon: typeplaces[indx].icon,
                    );
                  }),
            )
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("PREFERENCIAS",
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText1.color)),
        elevation: 0,
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        iconTheme:
            IconThemeData(color: Theme.of(context).textTheme.bodyText1.color),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: _screenWidth,
          height: _screenHeight,
          color: Theme.of(context).dialogBackgroundColor,
          child: StreamBuilder(
            stream: preferencesBloc.preferencesStream,
            builder: (ctx, snapshot) {
              var preferences = snapshot.data as Preferences;
              if (snapshot.hasData) {
                return Column(
                  children: [
                    _categories(preferences.categories),
                    _typeplaces(preferences.typeplaces),
                  ],
                );
              } else {
                return Container(
                  width: _screenWidth,
                  height: _screenHeight,
                  child: _loader,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
