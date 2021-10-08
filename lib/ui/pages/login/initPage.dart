import 'package:flutter/material.dart';

class InitPage extends StatelessWidget {
  const InitPage();

  @override
  Widget build(BuildContext context) {
    var _screenHeight = MediaQuery.of(context).size.height;
    var _screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
          height: _screenHeight,
          width: _screenWidth,
          color: Colors.white,
          child: Image(
            fit: BoxFit.cover,
            image: AssetImage('assets/img/init_page.jpeg'),
          )),
    );
  }
}
