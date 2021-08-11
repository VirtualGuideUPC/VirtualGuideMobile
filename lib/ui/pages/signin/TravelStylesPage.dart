import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; /*birth date formal*/
import 'package:tour_guide/data/entities/category.dart';
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

  TextEditingController _inputFieldDateController = new TextEditingController();

  bool flagRequestSubmitted = false;
  bool isMale = false;
  List<Category> userCategories;

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
    bloc.getCategories().then((List<Category> result) {
      userCategories = result;
    }).catchError((error) {
      print(error);
    });
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

  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    final bloc = Provider.loginBlocOf(context);
    bloc.init();

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: BackButton(
            color: Colors.black,
            onPressed: () {
              bloc.dispose();
              Utils.mainNavigator.currentState.pushReplacementNamed(routeLogin);
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
                Divider(color: Colors.white,),
                showCategories(bloc),
               Divider(height: 40, color: Colors.white,),
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
                    Utils.mainNavigator.currentState
                        .pushReplacementNamed(routeFinishRegister);
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

  Widget _buildNameField(SigninBloc bloc) {
    return StreamBuilder(
      stream: bloc.nameStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return AuthTextField(
          label: "Nombre:",
          placeholder: "Steve",
          errorText: snapshot.error,
          onChanged: bloc.changeName,
        );
      },
    );
  }

  Widget _buildLastNameField(SigninBloc bloc) {
    return StreamBuilder(
      stream: bloc.lastNameStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return AuthTextField(
          label: "Apellido:",
          placeholder: "Marvel",
          errorText: snapshot.error,
          onChanged: bloc.changeLastName,
        );
      },
    );
  }

  Widget _buildEmailField(SigninBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return AuthTextField(
          label: "Correo:",
          placeholder: "alguien@gmail.com",
          errorText: snapshot.error,
          onChanged: bloc.changeEmail,
        );
      },
    );
  }

  Widget _buildPasswordField(SigninBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return AuthTextField(
          obscureText: true,
          label: "Contraseña:",
          placeholder: "••••••••••••",
          errorText: snapshot.error,
          onChanged: bloc.changePassword,
        );
      },
    );
  }

  Widget _buildBirthDatePicker(context, SigninBloc bloc) {
    return AuthTextField(
        controller: _inputFieldDateController,
        label: "Fecha de nacimiento",
        placeholder: "Seleccionar",
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _selectDate(context, bloc);
        });
  }

  _selectDate(context, SigninBloc bloc) async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1950),
        lastDate: new DateTime(2025),
        locale: Locale('es', 'ES'));

    if (picked != null) {
      final _fecha = DateFormat('yyyy-MM-dd').format(picked).toString();
      print(_fecha);
      _inputFieldDateController.text = _fecha;
      bloc.changeBirthDate(_fecha);
      setState(() {});
    }
  }

  Widget _buildCountryDropDown(SigninBloc bloc) {
    return StreamBuilder(
      stream: bloc.countryStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '',
              style: TextStyle(
                  fontSize: 18.0, color: Color.fromRGBO(0, 0, 0, 0.6)),
            ),
            SizedBox(height: 5.0),
            DropdownButtonFormField(
              dropdownColor: Theme.of(context).primaryColorLight,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                labelText: "Seleccione un pais",
              ),
              value: snapshot.data,
              items: getOpcionesDropdown(),
              onChanged: (val) {
                bloc.changeCountry(val);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildLanguageDropDown(SigninBloc bloc) {
    return StreamBuilder(
      stream: bloc.nameStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '',
              style: TextStyle(
                  fontSize: 18.0, color: Color.fromRGBO(0, 0, 0, 0.6)),
            ),
            SizedBox(height: 5.0),
            DropdownButtonFormField(
              dropdownColor: Theme.of(context).primaryColorLight,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                labelText: "Seleccione un idioma",
              ),
              value: snapshot.data,
              items: getLanguagesDropdown(),
              onChanged: (val) {
                bloc.changeName(val);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildRequestResultBox(SigninBloc bloc) {
    return StreamBuilder(
      stream: bloc.requestResultStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.redAccent),
                color: Color.fromRGBO(255, 0, 0, 0.2),
                borderRadius: BorderRadius.circular(10.0)),
            child: Text(
              snapshot.data,
              style: TextStyle(color: Colors.redAccent),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildSubmitButton(SigninBloc bloc) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return BigButton(
          label: "Ir al siguiente paso",
          onPressed: snapshot.hasData
              ? () {
                  _signin(bloc, context);
                }
              : null,
        );
      },
    );
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
        .signin(bloc.name, bloc.lastName, bloc.email, bloc.password,
            bloc.birthDate, bloc.country)
        .then((String result) {
      if (alertContext != null) Navigator.of(alertContext).pop();
      Utils.mainNavigator.currentState.pushReplacementNamed(routeLogin);
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
