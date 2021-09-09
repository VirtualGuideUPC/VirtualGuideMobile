import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart'; /*birth date formal*/
import 'package:tour_guide/data/entities/user.dart';
import 'package:tour_guide/ui/bloc/provider.dart';
import 'package:tour_guide/ui/bloc/signinBloc.dart';
import 'package:tour_guide/ui/helpers/utils.dart';
import 'package:tour_guide/ui/routes/routes.dart';
import 'package:tour_guide/ui/widgets/AuthTextFieldWidget.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
class PersonalInformationPage extends StatefulWidget {
  @override
  _PersonalInformationPageState createState() =>
      _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  final double minHeight = 700;

  TextEditingController _inputFieldDateController = new TextEditingController();
  TextEditingController _inputFieldNameController = new TextEditingController();
  TextEditingController _inputFieldLastnameController = new TextEditingController();
  TextEditingController _inputFieldEmailController = new TextEditingController();
  User user;
  bool flagRequestSubmitted = false;
  bool isMale = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = ModalRoute.of(context).settings.arguments;
    _inputFieldEmailController.text = user.email;

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
              googleSignIn.signOut();
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
                Text("Actualiza tu información personal",
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.center),
                Divider(
                  height: 20.0,
                  color: Colors.white,
                ),
                CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.grey,
                    backgroundImage: CachedNetworkImageProvider(user.icon)),
                Divider(
                  height: 20.0,
                  color: Colors.white,
                ),
                _buildNameField(bloc),
                Divider(
                  height: 10.0,
                  color: Colors.white,
                ),
                _buildLastNameField(bloc),
                Divider(
                  height: 10.0,
                  color: Colors.white,
                ),
                _buildEmailField(bloc),
                Divider(
                  height: 10.0,
                  color: Colors.white,
                ),
                _buildBirthDatePicker(context, bloc),
                Divider(
                  height: 20.0,
                  color: Colors.white,
                ),
                Row(
                  children: [
                    Flexible(
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: isMale
                                ? MaterialStateProperty.all<Color>(Colors.white)
                                : MaterialStateProperty.all<Color>(
                                    Colors.black),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: BorderSide(color: Colors.grey)))),
                        onPressed: () {
                          setState(() {
                            this.isMale = false;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Mujer",
                              style: TextStyle(
                                  color: isMale ? Colors.black : Colors.white),
                            ),
                            SizedBox(
                              height: 42.0,
                            ),
                          ],
                        ),
                      ),
                      flex: 1,
                    ),
                    VerticalDivider(),
                    Flexible(
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: isMale
                                ? MaterialStateProperty.all<Color>(Colors.black)
                                : MaterialStateProperty.all<Color>(
                                    Colors.white),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: BorderSide(color: Colors.grey)))),
                        onPressed: () {
                          setState(() {
                            this.isMale = true;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Hombre",
                              style: TextStyle(
                                  color: isMale ? Colors.white : Colors.black),
                            ),
                            SizedBox(
                              height: 42.0,
                            ),
                          ],
                        ),
                      ),
                      flex: 1,
                    ),
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: BorderSide(color: Colors.grey)))),
                        onPressed: () {

                          if(_inputFieldNameController.text != "" && _inputFieldLastnameController.text != ""
                              && _inputFieldEmailController.text != "" && _inputFieldDateController.text != ""){
                            user.name = _inputFieldNameController.text;
                            user.lastName = _inputFieldLastnameController.text;
                            user.email = _inputFieldEmailController.text;
                            user.birthday = _inputFieldDateController.text;
                            bloc.dispose();
                            //user.gender
                            Utils.mainNavigator.currentState.pushReplacementNamed(
                                routeCountryInformation,
                                arguments: user);
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Por favor, completar los datos"),
                            ));
                          }

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

  Widget _buildNameField(SigninBloc bloc) {
    return StreamBuilder(
      stream: bloc.nameStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return AuthTextField(
          controller: _inputFieldNameController,
          label: "Nombre:",
          placeholder: "Ingrese su nombre",
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
          controller: _inputFieldLastnameController,
          label: "Apellido:",
          placeholder: "Ingrese su apellido",
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
          controller: _inputFieldEmailController,
          label: "Correo:",
          placeholder: "Ingrese su correo electrónico",
          errorText: snapshot.error,
          onChanged: bloc.changeEmail,
          isEnabled: false,
        );
      },
    );
  }

  Widget _buildBirthDatePicker(context, SigninBloc bloc) {
    return AuthTextField(
        controller: _inputFieldDateController,
        label: "Fecha de nacimiento",
        placeholder: "Seleccionar fecha de nacimiento",
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


}
