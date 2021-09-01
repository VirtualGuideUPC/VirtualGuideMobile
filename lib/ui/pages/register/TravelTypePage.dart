import 'package:flutter/material.dart';
import 'package:tour_guide/data/entities/typePlace.dart';
import 'package:tour_guide/data/entities/user.dart';
import 'package:tour_guide/data/providers/userProvider.dart';
import 'package:tour_guide/ui/bloc/provider.dart';
import 'package:tour_guide/ui/helpers/utils.dart';
import 'package:tour_guide/ui/routes/routes.dart';

class TravelTypePage extends StatefulWidget {
  @override
  _TravelTypePageState createState() => _TravelTypePageState();
}

class _TravelTypePageState extends State<TravelTypePage> {

  User user;
  Future<List<TypePlace>> futureTypePlaces;
  List<TypePlace> selectedTypeplaces = [];
  List<int> selectedTypeplacesIds = [];


  @override
  void initState() {
    super.initState();
    futureTypePlaces = UserProvider().getAllTypePlaces();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = ModalRoute
        .of(context)
        .settings
        .arguments;
  }

  Widget getImageWidget(url, name, id) {
    return GestureDetector(
      onTap: () =>
      {
        selectedTypeplacesIds.add(id),
        user.typePlaces = selectedTypeplacesIds,
        Utils.mainNavigator.currentState.pushReplacementNamed(
            routeTravelStyles, arguments: user)
      },
      child: Container(
        decoration: new BoxDecoration(color: Colors.white),
        width: double.infinity,
        height: 275,
        child: Stack(
          children: <Widget>[
            Image.network(url, fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,),
            /*style.isSelected ? Positioned(
                top: 0, right: 0, bottom: 0, left: 0, //give the values according to your requirement
                child: Icon(Icons.favorite, color: Colors.white, size: 35,)
              //IconButton(icon: Icon(Icons.delete_forever, color: Colors.redAccent,), onPressed: () {  },),
            ) : Text(""),*/
            Positioned(
                bottom: 15,
                left: 15,
                //give the values according to your requirement
                child: textWithStroke(text: name, fontSize: 24)
              //IconButton(icon: Icon(Icons.delete_forever, color: Colors.redAccent,), onPressed: () {  },),
            ),
          ],
        ),
      ),
    );
  }

  Widget textWithStroke({String text,
    String fontFamily,
    double fontSize: 12,
    double strokeWidth: 1,
    Color textColor: Colors.white,
    Color strokeColor: Colors.black}) {
    return Stack(
      children: <Widget>[
        Text(
          text,
          overflow: TextOverflow.fade,
          maxLines: 1,
          softWrap: false,
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
            overflow: TextOverflow.fade,
            maxLines: 1,
            softWrap: false,
            style: TextStyle(
                fontFamily: fontFamily, fontSize: fontSize, color: textColor)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.loginBlocOf(context);
    bloc.init();
    return Scaffold(
        backgroundColor: Colors.white,
        body: _buildContent(context)
    );
  }

  Widget _buildContent(BuildContext context) {
    return FutureBuilder(
      future: futureTypePlaces,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Container(
            color: Colors.white,
            child: ListView(
                children: _buildPics(context, snapshot.data)
            ),
          );
        } else if (snapshot.hasError) {
          if (snapshot.error == '401') {
            //TODO: handle session expired
            Future.delayed(
                Duration.zero, () => Utils.homeNavigator.currentState.pop());
          } else {
            Future.delayed(
                Duration.zero, () => Utils.homeNavigator.currentState.pop());
          }
          return Container();
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  List<Widget> _buildPics(BuildContext context, List<TypePlace> typePlaces) {
    return typePlaces.map((item) {
      return getImageWidget(item.icon, item.name, item.id);
    }).toList();
  }

}
