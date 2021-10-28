import 'dart:io';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/streams.dart';
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
  UserUpdateDto _NoupdateDto = UserUpdateDto();

  UserProfileBloc userProfileBloc = UserProfileBloc();

  bool isLoading = false;
  bool isEditable = false;
  String _countrySelected;

  File _image = File('');

  _imgFromCamera() async {
    ImagePicker picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.camera);
    if (img != null) {
      setState(() {
        _image = File(img.path);
      });
    }
  }

  _imgFromGallery() async {
    ImagePicker picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() {
        _image = File(img.path);
      });
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              color: Colors.white,
              height: 120,
              child: Column(
                children: [
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Galería'),
                      onTap: () async {
                        if (await Permission.mediaLibrary.request().isGranted) {
                          _imgFromGallery();
                          Navigator.of(context).pop();
                        } else {
                          Navigator.of(context).pop();
                        }
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Cámara'),
                    onTap: () async {
                      if (await Permission.camera.request().isGranted) {
                        _imgFromCamera();
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ));
        });
  }

  final List<String> _countries = [
    'Perú',
    'Chile',
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
  @override
  void initState() {
    //print(widget.user);

    _NoupdateDto.birthday = widget.user.birthday;
    _NoupdateDto.country = widget.user.countryId;
    _NoupdateDto.name = widget.user.name;
    _NoupdateDto.lastName = widget.user.lastName;

    userProfileBloc.changeBirthday(widget.user.birthday);
    BackButtonInterceptor.add(myInterceptor);

    super.initState();
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    Utils.homeNavigator.currentState.pop();
    return true;
  }

  void _saveForm() async {
    if (this._aboutMeFormKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      this._aboutMeFormKey.currentState.save();
      var a = 0;
      userProvider
          .updateUserProfile(_updateDto, _image)
          .asStream()
          .listen((event) {
        a += 1;
        print(a);
      }).onDone(() {
        setState(() {
          this.isEditable = false;
          Utils.homeNavigator.currentState.pushReplacementNamed(
            routeHomeAccountPage,
          );
        });
      });
    }
  }

  void resetForm() {
    _aboutMeFormKey.currentState.reset();

    userProfileBloc.changeBirthday(_NoupdateDto.birthday);
    userProfileBloc.sinkLastname.add(_NoupdateDto.lastName);
    userProfileBloc.sinkName.add(_NoupdateDto.name);
  }

  @override
  Widget build(BuildContext context) {
    var _screenHeight = MediaQuery.of(context).size.height - kToolbarHeight;
    var _screenWidth = MediaQuery.of(context).size.width;

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
                      resetForm();
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
    Widget _loader = Material(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      elevation: 10,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Theme.of(context).dialogBackgroundColor,
          ),
          child: Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          )),
    );

    Widget _avatar = Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Stack(
          children: [
            CircleAvatar(
              backgroundImage: _image.path.isNotEmpty
                  ? FileImage(_image)
                  : NetworkImage(widget.user.icon),
              radius: 65,
            ),
            if (isEditable)
              Positioned(
                bottom: -6,
                right: 0,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      onPrimary: Colors.white,
                      primary: Colors.purple.shade800,
                      padding: EdgeInsets.all(1),
                    ),
                    onPressed: () {
                      _showPicker(context);
                    },
                    child: Icon(Icons.photo)),
              )
          ],
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
                        StreamBuilder(
                            stream: userProfileBloc.name,
                            builder: (context, snapshot) {
                              return TextFormField(
                                //   key: Key(widget.user.name),
                                onChanged: (val) =>
                                    userProfileBloc.sinkName.add(val),
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color),
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
                                    errorText: snapshot.hasError
                                        ? snapshot.error.toString()
                                        : null,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: isEditable
                                              ? Colors.blue
                                              : Colors.grey),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: isEditable
                                              ? Colors.blue
                                              : Colors.grey),
                                    ),
                                    labelText: 'Nombre',
                                    labelStyle: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .color)),
                              );
                            }),
                        SizedBox(
                          height: 5,
                        ),
                        StreamBuilder(
                            stream: userProfileBloc.lastname,
                            builder: (context, snapshot) {
                              return TextFormField(
                                //     key: Key(widget.user.lastName),
                                onChanged: (val) =>
                                    userProfileBloc.sinkLastname.add(val),
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color),
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
                                    errorText: snapshot.hasError
                                        ? snapshot.error.toString()
                                        : null,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: isEditable
                                              ? Colors.blue
                                              : Colors.grey),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: isEditable
                                              ? Colors.blue
                                              : Colors.grey),
                                    ),
                                    labelText: 'Apellido',
                                    labelStyle: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .color)),
                              );
                            }),
                      ],
                    ),
                  ),
                  Flexible(flex: 1, child: _avatar)
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
                    //key: Key(widget.user.birthday),
                    controller: _dateController,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color),
                    readOnly: !isEditable,
                    textInputAction: TextInputAction.next,
                    onSaved: (value) {
                      _updateDto.birthday = value;
                    },
                    onChanged: (value) {
                      userProfileBloc.sinkBirthday.add(value);
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
                        errorText: snapshot.hasError
                            ? snapshot.error.toString()
                            : null,
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
            isEditable
                ? DropdownButtonFormField<String>(
                    onChanged: (e) {
                      setState(() {
                        _countrySelected = e as String;
                      });
                    },
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              color: isEditable ? Colors.blue : Colors.grey),
                        ),
                        labelText: "País",
                        labelStyle: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyText1.color)),
                    value: _countries[widget.user.countryId - 1],
                    onSaved: (value) {
                      var index = _countries.indexOf(value);
                      _updateDto.country = index + 1;
                    },
                    iconEnabledColor:
                        Theme.of(context).textTheme.bodyText1.color,
                    validator: (value) =>
                        value == null ? 'Por favor escoja un país' : null,
                    items: _countries
                        .map((e) => DropdownMenuItem<String>(
                            value: e,
                            child: new Text(
                              e,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .color),
                            )))
                        .toList(),
                  )
                : TextFormField(
                    //  key: Key(widget.user.countryId.toString()),
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color),
                    readOnly: !isEditable,
                    textInputAction: TextInputAction.next,
                    onSaved: (value) {
                      _updateDto.country = int.parse(value);
                    },
                    initialValue: _countries[widget.user.countryId - 1],
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
                            color:
                                Theme.of(context).textTheme.bodyText1.color)),
                  ),
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
                Positioned(
                  bottom: _screenHeight * 0.1,
                  left: (_screenWidth * 0.4) / 2,
                  child: Container(
                    width: _screenWidth * 0.5,
                    height: _screenHeight * 0.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Theme.of(context).dialogBackgroundColor,
                    ),
                    child: _loader,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
