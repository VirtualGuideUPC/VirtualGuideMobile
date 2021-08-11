import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tour_guide/data/datasource/userPreferences.dart';
import 'package:tour_guide/main.dart';
import 'package:tour_guide/ui/bloc/loginBloc.dart';
import 'package:tour_guide/ui/bloc/provider.dart';
import 'package:tour_guide/ui/helpers/utils.dart';
import 'package:tour_guide/ui/routes/routes.dart';
import 'package:tour_guide/ui/widgets/AuthTextFieldWidget.dart';
import 'package:tour_guide/ui/widgets/BigButtonWidget.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool flagRequestSubmitted = false;

  bool flagWaitingIfLoggedUser = true;

  bool isSignedIn = false;

  /*void initState(){
    super.initState();


  }*/

  controlSignIn(GoogleSignInAccount signInAccount) async {
    if(signInAccount != null){
      setState(() {
        isSignedIn = true;
        Utils.mainNavigator.currentState.pushReplacementNamed(routePersonalInformation, arguments: signInAccount);
      });
    }else{
      setState(() {
        isSignedIn = false;
      });
    }
  }

  loginUser(){
    googleSignIn.signIn();
  }

  logoutUser(){
    googleSignIn.signOut();
  }

  @override
  void initState() {
    super.initState();
    final _prefs = UserPreferences();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_prefs.getToken() != '') {
        Utils.mainNavigator.currentState.pushReplacementNamed(routeHomeStart);
      }
      flagWaitingIfLoggedUser = false;
      setState(() {});
    });

    googleSignIn.onCurrentUserChanged.listen((gSigninAccount) {
      controlSignIn(gSigninAccount);
    }, onError: (gError) {
      print("Error message " + gError);
    });

    googleSignIn.signInSilently(suppressErrors: false).then((gSignInAccount){
      controlSignIn(gSignInAccount);
    }).catchError((gError){
      print("Error message " + gError);
    });
  }

  @override
  Widget build(context) {
    final bloc = Provider.loginBlocOf(context);
    bloc.init();
    return Scaffold(
        backgroundColor: Colors.white,
        body: !flagWaitingIfLoggedUser
            ? _buildContent(bloc)
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  Widget _buildContent(LoginBloc bloc) {
    return Center(
      child: SingleChildScrollView(
          child: Column(children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Text("Te damos la bienvenida",
                  style: Theme.of(context).textTheme.headline5),
              Image.asset('assets/img/img_home.png'),
              //todo::create widget
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: BorderSide(color: Colors.grey)))),
                onPressed: () {
                  //bloc.dispose();
                  //Utils.mainNavigator.currentState
                  //    .pushReplacementNamed(routePersonalInformation);
                  loginUser();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/img/ic_google.png'),
                    SizedBox(
                      width: 10.0,
                      height: 52.0,
                    ),
                    Text('Continuar con Google'),
                  ],
                ),
              ),
              Divider(
                color: Colors.white,
              ),
              Row(
                children: [
                  Flexible(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      side: BorderSide(color: Colors.grey)))),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/img/ic_apple.png'),
                          SizedBox(
                            height: 52.0,
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
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      side: BorderSide(color: Colors.grey)))),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/img/ic_fb.png'),
                          SizedBox(
                            height: 52.0,
                          ),
                        ],
                      ),
                    ),
                    flex: 1,
                  )
                ],
              ),
              Divider(color: Colors.white),
              Text(
                "Al continuar aceptas los Términos de servicios y la Política de privacidad de datos",
                textAlign: TextAlign.center,
              ),
              Divider(
                color: Colors.white,
                height: 40.0,
              ),
              /* Text("Inicia sesión uwu",
                  style: Theme.of(context).textTheme.headline3),
              SizedBox(height: 20.0),
              _buildEmailField(bloc),
              SizedBox(height: 20.0),
              _buildPasswordField(bloc),
              SizedBox(height: 20.0),
              _buildRequestResultBox(bloc),
              SizedBox(height: 25.0),
              _buildSubmitButton(bloc),
              SizedBox(height: 10.0),
              GestureDetector(
                child: Text("Registrate aqui", style: TextStyle(fontSize: 15.0)),
                onTap: () {
                  bloc.dispose();
                  Utils.mainNavigator.currentState
                      .pushReplacementNamed(routeSignin);
                },
              ),
              SizedBox(height: 10.0),*/
            ],
          ),
        )
      ])),
    );
  }

  _buildEmailField(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return AuthTextField(
          label: "Correo:",
          placeholder: "ejemplo@gmail.com",
          errorText: snapshot.error,
          onChanged: bloc.changeEmail,
        );
      },
    );
  }

  _buildPasswordField(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return AuthTextField(
          label: "Contraseña:",
          placeholder: "••••••••••••",
          obscureText: true,
          errorText: snapshot.error,
          onChanged: bloc.changePassword,
        );
      },
    );
  }

  _buildRequestResultBox(LoginBloc bloc) {
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

  _buildSubmitButton(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return BigButton(
          label: "Ingresar",
          onPressed: snapshot.hasData
              ? () {
                  return _login(bloc, context);
                }
              : null,
        );
      },
    );
  }

  _login(LoginBloc bloc, BuildContext context) {
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
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              ));
        });

    bloc.login(bloc.email, bloc.password).then((String result) {
      if (alertContext != null) Navigator.of(alertContext).pop();
      Utils.mainNavigator.currentState.pushReplacementNamed(routeHomeStart);
    }).catchError((error) {
      if (alertContext != null) Navigator.of(alertContext).pop();
      bloc.changeRequestResult(error.toString());
      flagRequestSubmitted = false;
    });

    flagRequestSubmitted = true;
  }

// void _showAlert(BuildContext context,String title, String message) {
//   showDialog(
//     context: context,
//     builder: ( context ) {
//       return AlertDialog(
//         title: Text('$title'),
//         content: Text(message),
//         actions: <Widget>[
//           TextButton(
//             child: Text('Ok'),
//             onPressed: ()=> Navigator.of(context).pop(),
//           )
//         ],
//       );
//     }
//   );
// }
}
