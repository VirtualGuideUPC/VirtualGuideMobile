import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tour_guide/ui/bloc/loginBloc.dart';
import 'package:tour_guide/ui/bloc/provider.dart';
import 'package:tour_guide/ui/widgets/AuthTextFieldWidget.dart';
import 'package:tour_guide/ui/widgets/BigButtonWidget.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool flagRequestSubmitted=false;
  @override
  Widget build(context) {
    final bloc = Provider.loginBlocOf(context);
    bloc.init();
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
      SafeArea(
          child: Container(
        height: 30.0,
      )),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Text("Inicia ssdsdión", style: Theme.of(context).textTheme.headline3),
            SizedBox(height: 20.0),
            _buildEmailField(bloc),
            SizedBox(height: 20.0),
            _buildPasswordField(bloc),
            SizedBox(height: 20.0),
            _buildRequestResultBox(bloc),
            SizedBox(height: 25.0),
            _buildSubmitButton(bloc),
            SizedBox(height: 10.0),
            GestureDetector(child: Text("Registrate aqui",style:TextStyle(fontSize: 15.0)),onTap: (){
              bloc.dispose();
              Navigator.pushReplacementNamed(context, "signin");
              },),
            SizedBox(height: 10.0),
          ],
        ),
      )
    ])));
  }

  _buildEmailField(LoginBloc bloc){
    return StreamBuilder(
      stream: bloc.emailStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return AuthTextField(
          label: "Correo:",
          placeholder: "ejemplo@gmail.com",
          errorText: snapshot.error,
          onChanged:bloc.changeEmail,
          );
      },
    );

  }

  _buildPasswordField(LoginBloc bloc){
    return StreamBuilder(
      stream: bloc.passwordStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
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
  _buildRequestResultBox(LoginBloc bloc){
    return StreamBuilder(
      stream: bloc.requestResultStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(width: 1,color:Colors.redAccent),
                color: Color.fromRGBO(255, 0, 0, 0.2),
                borderRadius: BorderRadius.circular(10.0)
                ),
              child: Text(snapshot.data,style: TextStyle(color: Colors.redAccent),),
            );
          }else{
            return Container();
          }
      },
    );
  }
  _buildSubmitButton(LoginBloc bloc){
    return StreamBuilder(
      stream: bloc.formValidStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return BigButton(
          label: "Ingresar",
          onPressed: snapshot.hasData?(){return _login(bloc,context);}:null,
          );
      },
    );
  }

  _login(LoginBloc bloc, BuildContext context){
    if(flagRequestSubmitted){return;}
    BuildContext alertContext;
    showDialog(context: context, builder: (context){
      alertContext=context;
      return AlertDialog(backgroundColor: Colors.white,content:Center(child: CircularProgressIndicator(),));
    });

    bloc.login(bloc.email, bloc.password).then((Map result){
      if(alertContext!=null)Navigator.of(alertContext).pop();
      if(!result['ok']){
        bloc.changeRequestResult(result["message"]);
        flagRequestSubmitted=false;
      }else{
        Navigator.pushReplacementNamed(context, "explorer");
      }
    });
    flagRequestSubmitted=true; 
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
