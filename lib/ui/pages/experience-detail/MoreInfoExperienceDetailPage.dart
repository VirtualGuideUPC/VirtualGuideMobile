import 'package:flutter/material.dart';
import 'package:tour_guide/data/entities/experienceDetailed.dart';

class MoreInfoExperienceDetailedPage extends StatefulWidget {
  MoreInfoExperienceDetailedPage();

  @override
  _MoreInfoExperienceDetailedPageState createState() =>
      _MoreInfoExperienceDetailedPageState();
}

class _MoreInfoExperienceDetailedPageState
    extends State<MoreInfoExperienceDetailedPage> {
  @override
  Widget build(BuildContext context) {
    var _screenHeight = MediaQuery.of(context).size.height - kToolbarHeight;
    var _screenWidth = MediaQuery.of(context).size.width;
    ExperienceDetailed pageArguments =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(79, 77, 140, 1),
        elevation: 0,
      ),
      body: Container(
        width: _screenWidth,
        height: _screenHeight,
        padding: EdgeInsets.all(10),
        color: Color.fromRGBO(79, 77, 140, 1),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pageArguments.name,
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                pageArguments.longInfo,
                textAlign: TextAlign.justify,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Datos curiosos",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(
                height: 15,
              ),
              for (var funfact in pageArguments.funFacts)
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(funfact),
                )
            ],
          ),
        ),
      ),
    );
  }
}
