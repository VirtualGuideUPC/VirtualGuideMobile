import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; /*birth date formal*/
import 'package:tour_guide/data/entities/category.dart';
import 'package:tour_guide/data/entities/user.dart';
import 'package:tour_guide/ui/bloc/provider.dart';
import 'package:tour_guide/ui/bloc/signinBloc.dart';
import 'package:tour_guide/ui/helpers/utils.dart';
import 'package:tour_guide/ui/routes/routes.dart';
import 'package:tour_guide/ui/widgets/AuthTextFieldWidget.dart';
import 'package:tour_guide/ui/widgets/BigButtonWidget.dart';

class TravelStylesPage extends StatefulWidget {
  @override
  _TravelStylesPageState createState() => _TravelStylesPageState();
}

class _TravelStylesPageState extends State<TravelStylesPage> {
  final double minHeight = 700;

  final List<String> _countries = [
    'Perú',
    'Chile',
    'Brazil',
    'México',
    'Argentina',
    'Bolivia',
    'Colombia',
    'USA',
    'Francia',
    'Portugal',
    'China',
    'Corea'
  ];

  final List<String> _languages = [
    'Español',
    'Inglés',
    'Francés',
    'Portugues',
    'Chino',
    'Coreano'
  ];
  List<GridTile> gridTilesList = [];

  TextEditingController _inputFieldDateController = new TextEditingController();

  bool flagRequestSubmitted = false;
  bool isMale = false;
  List<Category> userCategories;
  User user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = ModalRoute.of(context).settings.arguments;
  }

  Widget getImageWidget(Category category) {
    return GestureDetector(
      onTap: () => {
        setState(() {
          category.isSelected = true;
        })
      },
      child: Container(
        decoration: new BoxDecoration(color: Colors.white),
        width: double.infinity,
        height: 275,
        child: Stack(
          children: <Widget>[
            Image.network(
              category.icon,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ),
            category.isSelected
                ? Positioned(
                    top: 0,
                    right: 0,
                    bottom: 0,
                    left: 0,
                    //give the values according to your requirement
                    child: Icon(
                      Icons.favorite,
                      color: Colors.black,
                      size: 35,
                    )
                    //IconButton(icon: Icon(Icons.delete_forever, color: Colors.redAccent,), onPressed: () {  },),
                    )
                : Text(""),
            Positioned(
                bottom: 15,
                left: 15,
                //give the values according to your requirement
                child: textWithStroke(text: category.name, fontSize: 20)
                //IconButton(icon: Icon(Icons.delete_forever, color: Colors.redAccent,), onPressed: () {  },),
                ),
          ],
        ),
      ),
    );
  }

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
                fontFamily: fontFamily, fontSize: fontSize, color: textColor)),
      ],
    );
  }

  showCategories(bloc) {


    bloc.getCategories().then((List<Category> result)  {
      userCategories = result;
      List<GridTile> gridTilesList = [];
      userCategories.forEach((style) {
        gridTilesList.add(GridTile(
          child: style.isSelected
              ? ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      Colors.deepPurpleAccent.withOpacity(0.4),
                      BlendMode.srcOver),
                  child: getImageWidget(style))
              : getImageWidget(style),
        ));
      });
      return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: gridTilesList,
      );
    }).catchError((error) {
      print(error);
      return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: gridTilesList,
      );
    });
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: gridTilesList,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.signinBlocOf(context);
    bloc.init();

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: BackButton(
            color: Colors.black,
            onPressed: () {
              bloc.dispose();
              //_signin(bloc, context);
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Stack(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              children: [
                Text(
                  "Escoge tus estilos",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                Divider(
                  color: Colors.white,
                ),
                //showCategories(bloc),
                Divider(
                  height: 40,
                  color: Colors.white,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(color: Colors.grey)))),
                  onPressed: () {
                    bloc.dispose();
                    _signin(bloc, context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Siguiente",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 52.0,
                      ),
                    ],
                  ),
                )
                // showCategories(userCategories)
              ],
            ),
          ),
          /*Container(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            height: _screenSize.height - 100 < minHeight
                ? minHeight
                : _screenSize.height - 100,
            child: Column(
              children: [
                getImageWidget("http://hayo.co/wp-content/uploads/2018/08/lonely-planet-622111-unsplash.jpg", "Viaje personal"),
                getImageWidget("https://www.arscurrendi.com/wp-content/uploads/2018/07/backlit-clouds-dusk-853168.jpg", "Viaje con amigos"),
                getImageWidget("https://www.arscurrendi.com/wp-content/uploads/2018/07/backlit-clouds-dusk-853168.jpg", "Viaje con amigos"),
                getImageWidget("https://www.arscurrendi.com/wp-content/uploads/2018/07/backlit-clouds-dusk-853168.jpg", "Viaje con amigos"),
                getImageWidget("https://www.arscurrendi.com/wp-content/uploads/2018/07/backlit-clouds-dusk-853168.jpg", "Viaje con amigos")
                /*_buildNameField(bloc),
                SizedBox(height: 10.0),
                _buildLastNameField(bloc),
                SizedBox(height: 10.0),
                _buildEmailField(bloc),
                SizedBox(height: 10.0),
                _buildPasswordField(bloc),
                SizedBox(height: 10.0),
                _buildBirthDatePicker(context, bloc),
                SizedBox(height: 10.0),
                _buildCountryDropDown(bloc),
                SizedBox(height: 10.0),
                _buildRequestResultBox(bloc),
                Expanded(child: SizedBox()),
                _buildSubmitButton(bloc),
                SizedBox(height: 10.0),
                GestureDetector(
                  child: Text("Inicia sesión aqui",
                      style: TextStyle(fontSize: 15.0)),
                  onTap: () {
                    bloc.dispose();
                    Utils.mainNavigator.currentState
                        .pushReplacementNamed(routeLogin);
                  },
                ),
                SizedBox(height: 10.0),*/
              ],
            ),
          )*/
        ])));
  }

  _signin(SigninBloc bloc, BuildContext context) {
    if (flagRequestSubmitted) {
      return;
    }
    BuildContext alertContext;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          alertContext = context;
          return AlertDialog(
              backgroundColor: Colors.white,
              content: Center(
                child: CircularProgressIndicator(),
              ));
        });

    bloc
        .signin(user.name, user.lastName, user.email, "123456",
            user.birthday,"1")
        .then((String result) {
      if (alertContext != null) Navigator.of(alertContext).pop();
      Utils.mainNavigator.currentState.pushReplacementNamed(routeFinishRegister);
    }).catchError((error) {
      if (alertContext != null) Navigator.of(alertContext).pop();
      bloc.changeRequestResult(error.toString());
      flagRequestSubmitted = false;
    });

    flagRequestSubmitted = true;
  }

  List<DropdownMenuItem<String>> getOpcionesDropdown() {
    List<DropdownMenuItem<String>> lista = [];
    for (int i = 0; i < _countries.length; i++) {
      lista.add(DropdownMenuItem(
        child: Text(_countries[i]),
        value: (i + 1).toString(),
      ));
    }
    return lista;
  }

  List<DropdownMenuItem<String>> getLanguagesDropdown() {
    List<DropdownMenuItem<String>> list = [];
    for (int i = 0; i < _languages.length; i++) {
      list.add(DropdownMenuItem(
        child: Text(_languages[i]),
        value: (i + 1).toString(),
      ));
    }
    return list;
  }
}
