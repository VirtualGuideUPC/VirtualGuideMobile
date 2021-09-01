import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; /*birth date formal*/
import 'package:tour_guide/data/entities/user.dart';
import 'package:tour_guide/ui/bloc/provider.dart';
import 'package:tour_guide/ui/bloc/signinBloc.dart';
import 'package:tour_guide/ui/helpers/utils.dart';
import 'package:tour_guide/ui/routes/routes.dart';
import 'package:tour_guide/ui/widgets/AuthTextFieldWidget.dart';
import 'package:tour_guide/ui/widgets/BigButtonWidget.dart';

class CountryInformationPage extends StatefulWidget {
  @override
  _CountryInformationPageState createState() => _CountryInformationPageState();
}

class _CountryInformationPageState extends State<CountryInformationPage> {
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

  User user;
  bool flagRequestSubmitted = false;
  bool isMale = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = ModalRoute.of(context).settings.arguments;
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
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
              Utils.mainNavigator.currentState.pushReplacementNamed(routeLogin);
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Column(children: [
          SafeArea(
              child: Container(
            height: 10.0,
          )),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            height: _screenSize.height - 100 < minHeight
                ? minHeight
                : _screenSize.height - 100,
            child: Column(
              children: [
                Text("Yo soy de",
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.center),
                _buildCountryDropDown(bloc),
                Divider(height: 50.0,),
                Text("Idioma nativo",
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.center),
                _buildLanguageDropDown(bloc),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: ElevatedButton(
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
                              .pushReplacementNamed(routeTravelType, arguments: user);
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
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ])));
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
