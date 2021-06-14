import 'package:flutter/material.dart';
import 'package:tour_guide/data/providers/userProvider.dart';
import 'package:tour_guide/ui/bloc/provider.dart';
import 'package:tour_guide/ui/bloc/signin_bloc.dart';
import 'package:tour_guide/ui/widgets/AuthTextFieldWidget.dart';
import 'package:tour_guide/ui/widgets/BigButtonWidget.dart';

class SigninPage extends StatefulWidget {
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final userProvider=UserProvider();

  final double minHeight=700;

  final List<String> _countries=['Perú'];

  bool flagRequestSubmitted=false;

  @override
  Widget build(BuildContext context) {
    final _screenSize=MediaQuery.of(context).size;
    final bloc=Provider.signinBlocOf(context);
    bloc.init();
return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
                      SafeArea(child: Container(height: 10.0,)),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        height: _screenSize.height-100<minHeight?minHeight:_screenSize.height-100,
                        child: Column(
                          children: [
                            Text("Registrate", style: Theme.of(context).textTheme.headline3),
                            _buildNameField(bloc),
                            SizedBox(height: 10.0),
                            _buildLastNameField(bloc),
                            SizedBox(height: 10.0),
                            _buildEmailField(bloc),
                            SizedBox(height: 10.0),
                            _buildPasswordField(bloc),
                            SizedBox(height: 10.0),
                            _buildBirthDatePicker(bloc),
                            SizedBox(height: 10.0),
                            _buildCountryDropDown(bloc),
                            SizedBox(height: 10.0),
                            _buildRequestResultBox(bloc),
                            Expanded(child: SizedBox()),
                            _buildSubmitButton(bloc),
                            SizedBox(height: 10.0),
                            GestureDetector(child: Text("Inicia sesión aqui",style:TextStyle(fontSize: 15.0)),onTap: (){
                              bloc.dispose();
                              Navigator.pushReplacementNamed(context, "login");},),
                            SizedBox(height: 10.0),
                          ],
                        ),
                      )
    ])));
  }

  Widget _buildNameField(SigninBloc bloc){
    return StreamBuilder(
      stream: bloc.nameStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return AuthTextField(
          label: "Nombre:",
          placeholder: "Steve",
          errorText: snapshot.error,
          onChanged:bloc.changeName,
          );
      },
    );
  }

  Widget _buildLastNameField(SigninBloc bloc){
    return StreamBuilder(
      stream: bloc.lastNameStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return AuthTextField(
          label: "Apellido:",
          placeholder: "Marvel",
          errorText: snapshot.error,
          onChanged:bloc.changeLastName,
          );
      },
    );
  }

  Widget _buildEmailField(SigninBloc bloc){
    return StreamBuilder(
      stream: bloc.emailStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return AuthTextField(
          label: "Correo:",
          placeholder: "alguien@gmail.com",
          errorText: snapshot.error,
          onChanged:bloc.changeEmail,
          );
      },
    );
  }

  Widget _buildPasswordField(SigninBloc bloc){
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return AuthTextField(
          label: "Contraseña:",
          placeholder: "ooooooo",
          errorText: snapshot.error,
          onChanged:bloc.changePassword,
          );
      },
    );
  }

  Widget _buildBirthDatePicker(SigninBloc bloc){
        return StreamBuilder(
      stream: bloc.birthDateStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return AuthTextField(
          label: "Fecha de nacimiento:",
          placeholder: "20/20/2020",
          errorText: snapshot.error,
          onChanged:bloc.changeBirthDate,
          );
      },
    );
  }

  Widget _buildCountryDropDown(SigninBloc bloc){
    return StreamBuilder(
      stream: bloc.countryStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
          return  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text('País',style: TextStyle(fontSize: 18.0, color: Color.fromRGBO(0, 0, 0, 0.6)),),
                    SizedBox(height: 5.0),
                    DropdownButtonFormField(
                          decoration:  InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 10.0,horizontal:10.0),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                            labelText: "Seleccione un pais",
                          ),
                          value:snapshot.data,
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

   Widget _buildRequestResultBox(SigninBloc bloc){
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

  Widget _buildSubmitButton(SigninBloc bloc){
    return StreamBuilder(
      stream: bloc.formValidStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return BigButton(
          label: "Ir al siguiente paso",
          onPressed: snapshot.hasData?(){_signin(bloc,context);}:null,
          );
      },
    );
  }

  _signin(SigninBloc bloc, BuildContext context){
    if(flagRequestSubmitted){return;}
    BuildContext alertContext;
    showDialog(context: context, builder: (context){
      alertContext=context;
      return AlertDialog(backgroundColor: Colors.white,content:Center(child: CircularProgressIndicator(),));
    });

    userProvider.signinUser(bloc.name,bloc.lastName,bloc.email, bloc.password,bloc.birthDate,bloc.country).then((Map result){
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

  List<DropdownMenuItem<String>> getOpcionesDropdown() {

    List<DropdownMenuItem<String>> lista =[];
    for(int i=0;i<_countries.length;i++){
      lista.add( DropdownMenuItem(
        child: Text(_countries[i]),
        value: i.toString(),
      ));
    }
    return lista;
  }
}