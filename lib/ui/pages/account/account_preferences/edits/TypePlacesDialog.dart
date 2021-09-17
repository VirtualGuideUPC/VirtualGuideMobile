import 'package:flutter/material.dart';
import 'package:tour_guide/data/entities/typePlace.dart';
import 'package:tour_guide/data/providers/userProvider.dart';
import 'package:tour_guide/ui/bloc/preferencesBloc.dart';

class TypePlacesDialog extends StatefulWidget {
  TypePlacesDialog();

  @override
  _TypePlacesDialogState createState() => _TypePlacesDialogState();
}

class _TypePlacesDialogState extends State<TypePlacesDialog> {
  var preferencesBloc = PreferencesBloc();

  validateTypePlaces(
      List<TypePlace> allTypePlaces, List<TypePlace> userTypePlaces) {
    allTypePlaces.forEach((cat) {
      userTypePlaces.forEach((userCat) {
        if (cat.id == userCat.id) {
          cat.isSelected = true;
        }
      });
    });
  }

  chooseTypePlace(List<TypePlace> typeplaces, TypePlace typeplace) {
    if (typeplace.isSelected == false) {
      typeplaces.forEach((element) {
        if (element.isSelected) {
          element.isSelected = false;
          preferencesBloc.updateTypePlace(element);
        }
      });

      typeplace.isSelected = !typeplace.isSelected;

      preferencesBloc.updateTypePlace(typeplace);
    }
    if (typeplace.isSelected == true) {
      preferencesBloc.updateTypePlace(typeplace);
    }
  }

  @override
  Widget build(BuildContext context) {
    var _deviceWidth = MediaQuery.of(context).size.width;
    var _deviceHeight = MediaQuery.of(context).size.height - kToolbarHeight;

    Widget _loader = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ),
    );

    Widget textWithStroke(
        {String text,
        String fontFamily,
        double fontSize: 12,
        double strokeWidth: 1,
        Color textColor: Colors.white,
        Color strokeColor: Colors.black}) {
      return Stack(
        children: <Widget>[
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: fontFamily,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = strokeWidth
                ..color = strokeColor,
            ),
          ),
          Text(text,
              style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: fontSize,
                  color: textColor)),
        ],
      );
    }

    Widget getImageWidgetForTypePlace(
        TypePlace typeplace, List<TypePlace> typelaces) {
      return GestureDetector(
        onTap: () {
          List<TypePlace> test = [];
          preferencesBloc.changeTypeplaces(test);
          chooseTypePlace(typelaces, typeplace);
        },
        child: Container(
          margin: EdgeInsets.all(2),
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          width: double.infinity,
          height: 275,
          child: Stack(
            children: <Widget>[
              Image.network(
                typeplace.icon,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
              ),
              typeplace.isSelected
                  ? Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 50,
                      ),
                      //IconButton(icon: Icon(Icons.delete_forever, color: Colors.redAccent,), onPressed: () {  },),

                      decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent.withOpacity(0.4)),
                    )
                  : Text(""),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
              Positioned(
                  bottom: 15,
                  left: 15,
                  //give the values according to your requirement
                  child: textWithStroke(text: typeplace.name, fontSize: 24)
                  //IconButton(icon: Icon(Icons.delete_forever, color: Colors.redAccent,), onPressed: () {  },),
                  ),
            ],
          ),
        ),
      );
    }

    List<Widget> _buildPicsTypePlaces(
        BuildContext context, List<TypePlace> typePlaces) {
      return typePlaces.map((item) {
        return getImageWidgetForTypePlace(item, typePlaces);
      }).toList();
    }

    return Dialog(
      insetPadding: EdgeInsets.all(10),
      child: Container(
        height: _deviceHeight * 0.9,
        width: _deviceWidth,
        child: FutureBuilder(
          future: UserProvider().getAllTypePlaces(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              var allTypePlace = snapshot.data;
              preferencesBloc.getTypeplacesData();
              return StreamBuilder(
                  stream: preferencesBloc.typeplacesControllerStream,
                  builder: (ctx, snapshot2) {
                    if (snapshot2.hasData) {
                      var userTypeplaces = snapshot2.data as List;
                      validateTypePlaces(allTypePlace, userTypeplaces);
                      return Container(
                        padding: EdgeInsets.all(10),
                        child: userTypeplaces.length > 0
                            ? ListView(
                                children: _buildPicsTypePlaces(
                                    context, snapshot.data),
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                color: Colors.blue,
                              )),
                      );
                    } else {
                      return _loader;
                    }
                  });
            } else {
              return Center(
                  child: CircularProgressIndicator(
                color: Colors.blue,
              ));
            }
          },
        ),
      ),
    );
  }
}
