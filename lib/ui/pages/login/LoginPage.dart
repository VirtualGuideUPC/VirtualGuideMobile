import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tour_guide/data/datasource/userPreferences.dart';
import 'package:tour_guide/data/entities/user.dart';
import 'package:tour_guide/ui/bloc/loginBloc.dart';
import 'package:tour_guide/ui/bloc/provider.dart';
import 'package:tour_guide/ui/helpers/utils.dart';
import 'package:tour_guide/ui/routes/routes.dart';
import 'package:tour_guide/ui/widgets/CustomElevatedButton.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool flagWaitingIfLoggedUser = true;
  bool isSignedIn = false;
  LoginBloc bloc;
  User user;
  String email = "";
  String name = "";
  String picture = "";

  controlSignIn(GoogleSignInAccount signInAccount) async {
    if (signInAccount != null) {
      setState(() {
        isSignedIn = true;
        user = User();
        user.email = signInAccount.email;
        user.name = signInAccount.displayName;
        user.icon = signInAccount.photoUrl;
        _login(bloc, context, signInAccount.email);
      });
    } else {
      setState(() {
        isSignedIn = false;
      });
    }
  }

  loginWithGoogle() {
    googleSignIn.signIn();
  }

  logoutWithGoogle() {
    googleSignIn.signOut();
  }

  loginWithFb() {
    FacebookAuth.instance
        .login(permissions: ["public_profile", "email"]).then((value) {
      FacebookAuth.instance.getUserData().then((value) {
        setState(() {
          isSignedIn = true;
          user = User();
          user.email = value["email"];
          user.name = value["name"];
          user.icon = value["picture"]["data"]["url"];
          _login(bloc, context, value["email"]);
        });
      });
    });
  }

  testLogin() {
    user = User();
    user.email = "linotest@test.com";
    user.name = "test123";
    user.icon =
        "https://res.cloudinary.com/dyifsbjuf/image/upload/v1630902125/z8grwvbljnfylp2hin8l.jpg";
    _login(bloc, context, user.email);
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

    googleSignIn.signInSilently(suppressErrors: false).then((gSignInAccount) {
      controlSignIn(gSignInAccount);
    }).catchError((gError) {
      print("Error message " + gError);
    });
  }

  @override
  Widget build(context) {
    bloc = Provider.loginBlocOf(context);
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
              customElevatedButton("Continuar con Google",
                  'assets/img/ic_google.png', loginWithGoogle),
              Divider(
                color: Colors.white,
              ),
              customElevatedButton(
                  "Continuar con Facebook", 'assets/img/ic_fb.png', loginWithFb),
              Divider(
                height: 22,
                color: Colors.white,
              ),
              Text(
                "Al continuar aceptas los Términos de servicios y la Política de privacidad de datos",
                textAlign: TextAlign.center,
              ),
              Divider(
                color: Colors.white,
                height: 40.0,
              ),
            ],
          ),
        )
      ])),
    );
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
      Utils.mainNavigator.currentState
          .pushReplacementNamed(routePersonalInformation, arguments: user);
    });
  }
}
