import 'package:flutter/material.dart';
import 'package:tour_guide/data/entities/user.dart';
import 'package:tour_guide/data/providers/userProvider.dart';
import 'package:tour_guide/ui/bloc/userProfileBloc.dart';
import 'package:tour_guide/ui/helpers/utils.dart';
import 'package:tour_guide/ui/routes/routes.dart';

// ignore: must_be_immutable
class AccountInformationPage extends StatefulWidget {
  User user;
  AccountInformationPage(this.user);

  @override
  _AccountInformationPageState createState() => _AccountInformationPageState();
}

class _AccountInformationPageState extends State<AccountInformationPage> {
  final _userFormKey = GlobalKey<FormState>();
  final _aboutMeFormKey = GlobalKey<FormState>();
  TextEditingController _dateController = TextEditingController();

  UserProvider userProvider = UserProvider();
  UserUpdateDto _updateDto = UserUpdateDto();

  UserProfileBloc userProfileBloc = UserProfileBloc();

  bool isLoading = false;
  bool isEditable = false;

  @override
  void initState() {
    userProfileBloc.changeBirthday(widget.user.birthday);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _screenHeight = MediaQuery.of(context).size.height - kToolbarHeight;
    var _screenWidth = MediaQuery.of(context).size.width;

    void _saveForm() async {
      if (this._aboutMeFormKey.currentState.validate()) {
        isLoading = true;
        this._aboutMeFormKey.currentState.save();
        userProvider.updateUserProfile(_updateDto).then((value) {
          setState(() {
            this.isEditable = false;
            Utils.homeNavigator.currentState.pushReplacementNamed(
              routeHomeAccountPage,
            );
          });
        });
      }
    }

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
                  onPressed: () {
                    _saveForm();
                  },
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
              readOnly: true,
              textInputAction: TextInputAction.next,
              onSaved: (value) {},
              initialValue: widget.user.email,
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
    Widget _loader = Container(
        color: Theme.of(context).dialogBackgroundColor,
        child: Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.white,
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ));
    Widget _aboutMeForm = Form(
        key: _aboutMeFormKey,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Column(
                      children: [
                        TextFormField(
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1.color),
                          readOnly: !isEditable,
                          textInputAction: TextInputAction.next,
                          onSaved: (value) {
                            _updateDto.name = value;
                          },
                          initialValue: widget.user.name,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Por favor ingrese su nombre";
                            }
                          },
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color:
                                        isEditable ? Colors.blue : Colors.grey),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color:
                                        isEditable ? Colors.blue : Colors.grey),
                              ),
                              labelText: 'Nombre',
                              labelStyle: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .color)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1.color),
                          readOnly: !isEditable,
                          textInputAction: TextInputAction.next,
                          onSaved: (value) {
                            _updateDto.lastName = value;
                          },
                          initialValue: widget.user.lastName,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Por favor ingrese su apellido";
                            }
                          },
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color:
                                        isEditable ? Colors.blue : Colors.grey),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color:
                                        isEditable ? Colors.blue : Colors.grey),
                              ),
                              labelText: 'Apellido',
                              labelStyle: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .color)),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(widget
                                .user.icon.isNotEmpty
                            ? "https://media.discordapp.net/attachments/876920062169202798/883583758316486716/unknown.png?width=985&height=676"
                            : ""),
                        radius: 65,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            StreamBuilder(
                stream: userProfileBloc.birthdayStream,
                builder: (ctx, snapshot) {
                  _dateController.text = userProfileBloc.getBirthday;
                  return TextFormField(
                    controller: _dateController,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color),
                    readOnly: !isEditable,
                    textInputAction: TextInputAction.next,
                    onSaved: (value) {
                      _updateDto.birthday = value;
                    },
                    onChanged: (value) {
                      userProfileBloc.changeBirthday(value);
                    },
                    onTap: () {
                      if (isEditable) {
                        showDatePicker(
                                context: context,
                                initialDate:
                                    DateTime.parse(userProfileBloc.getBirthday),
                                firstDate: DateTime(1950),
                                lastDate: DateTime(2100))
                            .then((date) {
                          String dateFormat =
                              "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                          userProfileBloc.changeBirthday(dateFormat);
                        });
                      }
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Por favor ingrese su fecha de nacimiento";
                      }
                    },
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              color: isEditable ? Colors.blue : Colors.grey),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              color: isEditable ? Colors.blue : Colors.grey),
                        ),
                        labelText: 'Fecha de nacimiento',
                        labelStyle: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyText1.color)),
                  );
                }),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              style:
                  TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
              readOnly: !isEditable,
              textInputAction: TextInputAction.next,
              onSaved: (value) {
                _updateDto.country = int.parse(value);
              },
              initialValue: widget.user.countryId.toString(),
              validator: (value) {
                if (value.isEmpty) {
                  return "Por favor ingrese su país";
                }
              },
              decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        width: 1,
                        color: isEditable ? Colors.blue : Colors.grey),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        width: 1,
                        color: isEditable ? Colors.blue : Colors.grey),
                  ),
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
        title: Text("INFORMACIÓN PERSONAL",
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText1.color)),
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
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _title,
                  _userForm,
                  _subtitle("ACERCA DE MI"),
                  _aboutMeForm
                ],
              ),
              if (isLoading)
                Container(
                  width: _screenWidth,
                  height: _screenHeight - kToolbarHeight,
                  color: Theme.of(context).dialogBackgroundColor,
                  child: _loader,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
