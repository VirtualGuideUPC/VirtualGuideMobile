import 'package:flutter/material.dart';

class AccountPreferencesPage extends StatefulWidget {
  AccountPreferencesPage();

  @override
  _AccountPreferencesPageState createState() => _AccountPreferencesPageState();
}

class _AccountPreferencesPageState extends State<AccountPreferencesPage> {
  @override
  Widget build(BuildContext context) {
    var _screenHeight = MediaQuery.of(context).size.height - kToolbarHeight;
    var _screenWidth = MediaQuery.of(context).size.width;
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
      body: Container(
        width: _screenWidth,
        height: _screenHeight - kToolbarHeight,
        color: Theme.of(context).dialogBackgroundColor,
        child: SingleChildScrollView(
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
