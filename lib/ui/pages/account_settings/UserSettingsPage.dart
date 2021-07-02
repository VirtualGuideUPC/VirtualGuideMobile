import 'package:flutter/material.dart';

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
              onPressed: (){Navigator.pushNamed(context, 'favorite-departments');},)
          ],
        )
      ),
    );
  }
}