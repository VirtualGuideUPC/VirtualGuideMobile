import 'package:flutter/material.dart';
import 'package:tour_guide/data/entities/user.dart';

class AccountInformationPage extends StatefulWidget {
  AccountInformationPage();

  @override
  _AccountInformationPageState createState() => _AccountInformationPageState();
}

class _AccountInformationPageState extends State<AccountInformationPage> {
  final _userFormKey = GlobalKey<FormState>();
  final _aboutMeFormKey = GlobalKey<FormState>();

  bool isEditable = false;
  @override
  Widget build(BuildContext context) {
    var _screenHeight = MediaQuery.of(context).size.height - kToolbarHeight;
    var _screenWidth = MediaQuery.of(context).size.width;

    final args = ModalRoute.of(context).settings.arguments as User;

    Widget _title = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("DETALLES DEL USUARIO",
              style: TextStyle(
                  fontSize: 17,
                  color: Theme.of(context).textTheme.bodyText2.color,
                  fontWeight: FontWeight.w400)),
          if (!isEditable)
            IconButton(
              onPressed: () {
                setState(() {
                  this.isEditable = true;
                });
              },
              icon: Icon(Icons.edit,
                  color: Theme.of(context).textTheme.bodyText1.color),
            ),
          if (isEditable)
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.done,
                      color: Theme.of(context).textTheme.bodyText1.color),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      this.isEditable = false;
                    });
                  },
                  icon: Icon(Icons.close, color: Colors.red),
                )
              ],
            )
        ],
      ),
    );
    Widget _subtitle(String text) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text,
                style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).textTheme.bodyText2.color,
                    fontWeight: FontWeight.w400)),
          ],
        ),
      );
    }

    Widget _userForm = Form(
        key: _userFormKey,
        child: Column(
          children: [
            TextFormField(
              style:
                  TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
              readOnly: !isEditable,
              textInputAction: TextInputAction.next,
              onSaved: (value) {},
              initialValue: args.email,
              validator: (value) {
                if (value.isEmpty) {
                  return "Por favor ingrese su correo electrónico";
                }
              },
              decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  labelStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1.color)),
            ),
            SizedBox(
              height: 25,
            )
          ],
        ));

    Widget _aboutMeForm = Form(
        key: _aboutMeFormKey,
        child: Column(
          children: [
            TextFormField(
              style:
                  TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
              readOnly: !isEditable,
              textInputAction: TextInputAction.next,
              onSaved: (value) {},
              initialValue: args.name,
              validator: (value) {
                if (value.isEmpty) {
                  return "Por favor ingrese su nombre";
                }
              },
              decoration: InputDecoration(
                  labelText: 'Nombre',
                  labelStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1.color)),
            ),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              style:
                  TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
              readOnly: !isEditable,
              textInputAction: TextInputAction.next,
              onSaved: (value) {},
              initialValue: args.lastName,
              validator: (value) {
                if (value.isEmpty) {
                  return "Por favor ingrese su apellido";
                }
              },
              decoration: InputDecoration(
                  labelText: 'Apellido',
                  labelStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1.color)),
            ),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              style:
                  TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
              readOnly: !isEditable,
              textInputAction: TextInputAction.next,
              onSaved: (value) {},
              initialValue: args.birthday,
              validator: (value) {
                if (value.isEmpty) {
                  return "Por favor ingrese su fecha de nacimiento";
                }
              },
              decoration: InputDecoration(
                  labelText: 'Fecha de nacimiento',
                  labelStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1.color)),
            ),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              style:
                  TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
              readOnly: !isEditable,
              textInputAction: TextInputAction.next,
              onSaved: (value) {},
              initialValue: args.countryId.toString(),
              validator: (value) {
                if (value.isEmpty) {
                  return "Por favor ingrese su país";
                }
              },
              decoration: InputDecoration(
                  labelText: 'País',
                  labelStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1.color)),
            ),
            SizedBox(
              height: 5,
            )
          ],
        ));

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        iconTheme:
            IconThemeData(color: Theme.of(context).textTheme.bodyText1.color),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        width: _screenWidth,
        height: _screenHeight,
        color: Theme.of(context).dialogBackgroundColor,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _title,
              _userForm,
              _subtitle("ACERCA DE MI"),
              _aboutMeForm
            ],
          ),
        ),
      ),
    );
  }
}
