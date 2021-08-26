import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tour_guide/data/datasource/userPreferences.dart';
import 'package:tour_guide/data/entities/experienceDetailed.dart';
import 'package:tour_guide/data/entities/review.dart';
import 'package:intl/intl.dart';
import 'package:tour_guide/data/providers/reviewProvider.dart';
import 'package:tour_guide/ui/bloc/placesBloc.dart';
import 'package:tour_guide/ui/bloc/provider.dart';

class ReviewDialog extends StatefulWidget {
  final ExperienceDetailed experience;
  ReviewDialog(this.experience);

  @override
  _ReviewDialog createState() => _ReviewDialog();
}

class _ReviewDialog extends State<ReviewDialog> {
  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  File _pickedImage = File('');

  var pref = UserPreferences();
  CreateReviewDto _toSend = CreateReviewDto(
      comment: "",
      commentRanking: 0,
      date: "",
      ranking: 0,
      touristicPlace: 0,
      user: 0);

  void _saveForm(userId, PlacesBloc placesBloc) {
    final isValid = _formKey.currentState.validate();
    if (isValid) {
      if (_pickedImage.path.isNotEmpty) {
        this._formKey.currentState.save();
        _toSend.user = int.parse(userId);
        _toSend.touristicPlace = widget.experience.id;
        var now = new DateTime.now();
        var formatter = new DateFormat('yyyy-MM-dd');
        String formattedDate = formatter.format(now);
        this._toSend.date = formattedDate;
      }
      placesBloc.postReview(_toSend, _pickedImage).then((value) {
        Navigator.pop(context);
      });
    } else
      return;
  }

  _imgFromCamera() async {
    ImagePicker picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.camera);
    if (img != null) {
      setState(() {
        _pickedImage = File(img.path);
      });
    }
  }

  _imgFromGallery() async {
    ImagePicker picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery);

    if (img != null) {
      setState(() {
        _pickedImage = File(img.path);
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
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    var placesBloc = Provider.placesBlocOf(context);

    return Dialog(
      child: Container(
        width: double.infinity,
        height: 350,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              "Crear reseña",
              style: TextStyle(fontSize: 25),
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.text,
                      onFieldSubmitted: (_) {},
                      onSaved: (value) {
                        _toSend = CreateReviewDto(
                            ranking: _toSend.ranking,
                            comment: value,
                            commentRanking: _toSend.ranking,
                            date: _toSend.date,
                            touristicPlace: _toSend.touristicPlace,
                            user: _toSend.user);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Por favor ingrese su reseña";
                        }
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.reviews),
                        labelText: 'Reseña',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (_) {},
                      onSaved: (value) {
                        _toSend = CreateReviewDto(
                            ranking: int.parse(value),
                            comment: _toSend.comment,
                            commentRanking: int.parse(value),
                            date: _toSend.date,
                            touristicPlace: _toSend.touristicPlace,
                            user: _toSend.user);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Por favor ingrese su puntaje";
                        }
                        if (int.parse(value) > 5) {
                          return "Por favor ingrese un puntaje menor a 6";
                        }
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.star),
                        labelText: 'Puntuacion',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          child: _pickedImage.path.isEmpty
                              ? Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey[800],
                                )
                              : null,
                          radius: 40,
                          backgroundColor: Colors.grey,
                          backgroundImage: _pickedImage.path.isEmpty
                              ? null
                              : FileImage(_pickedImage),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton.icon(
                            onPressed: () {
                              _showPicker(context);
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.deepPurple.shade400,
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)))),
                            icon: Icon(
                              Icons.photo_camera,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Subir imagen",
                              style: TextStyle(color: Colors.white),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          _saveForm(pref.getUserId().toString(), placesBloc);
                        },
                        child: Text("Publicar reseña"))
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
