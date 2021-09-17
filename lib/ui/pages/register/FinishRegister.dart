import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; /*birth date formal*/
import 'package:tour_guide/data/entities/user.dart';
import 'package:tour_guide/ui/bloc/loginBloc.dart';
import 'package:tour_guide/ui/bloc/provider.dart';
import 'package:tour_guide/ui/bloc/signinBloc.dart';
import 'package:tour_guide/ui/helpers/utils.dart';
import 'package:tour_guide/ui/routes/routes.dart';
import 'package:tour_guide/ui/widgets/AuthTextFieldWidget.dart';
import 'package:tour_guide/ui/widgets/BigButtonWidget.dart';

class FinishRegisterPage extends StatefulWidget {
  @override
  _FinishRegisterPageState createState() => _FinishRegisterPageState();
}

class _FinishRegisterPageState extends State<FinishRegisterPage> {

  final double minHeight = 700;
  bool flagRequestSubmitted = false;
  bool isMale = false;
  User user;
  LoginBloc bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = ModalRoute.of(context).settings.arguments;
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.loginBlocOf(context);
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
                Divider(
                  color: Colors.white,
                  height: 80,
                ),
                Text(
                  "Gracias por registrarte!",
                  style: TextStyle(color: Colors.black, fontSize: 30),
                  textAlign: TextAlign.center,
                ),
                Divider(
                  color: Colors.white,
                ),
                Image.asset('assets/img/img_finish.png'),
                Divider(
                  height: 26,
                  color: Colors.white,
                ),
                Text(
                  "Te deseamos lo mejor en tu viaje! Nuetra razón de existir es poder ayudarte a tener la mejor experiencia posible :)",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                Divider(
                  color: Colors.white,
                  height: 80,
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
                    //Utils.mainNavigator.currentState
                     //   .pushReplacementNamed(routeHomeStart);
                    _login(bloc, context, user.email);
                    bloc.dispose();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Finalizar",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 52.0,
                      ),
                    ],
                  ),
                ),
                // showCategories(userCategories)
              ],
            ),
          ),
        ])));
  }

  _login(LoginBloc bloc, BuildContext context, String email) {
    BuildContext alertContext;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          alertContext = context;
          return AlertDialog(
              backgroundColor: Colors.white,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              ));
        });

    bloc.login(email).then((String result) {
      if (alertContext != null) Navigator.of(alertContext).pop();
      Utils.mainNavigator.currentState.pushReplacementNamed(routeHomeStart);
    }).catchError((error) {
      Navigator.of(alertContext).pop();
    });
  }
}
