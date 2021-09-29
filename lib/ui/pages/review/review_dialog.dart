import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
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
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  List<File> pickedImages = [];

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
    setState(() {
      isLoading = true;
    });

    if (isValid) {
      this._formKey.currentState.save();
      _toSend.user = int.parse(userId);
      _toSend.touristicPlace = widget.experience.id;
      var now = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd');
      String formattedDate = formatter.format(now);
      this._toSend.date = formattedDate;

      placesBloc.postReview(_toSend, pickedImages).then((value) {
        Navigator.pop(context);
        setState(() {
          isLoading = false;
        });
      });
    } else {
      setState(() {
        isLoading = false;
      });
      return;
    }
  }

  _uploadImage() async {
    ImagePicker picker = ImagePicker();
    final imgs = await picker.pickMultiImage();
    if (imgs != null) {
      if (imgs.length < 4 && imgs.length > 0) {
        setState(() {
          for (var img in imgs) {
            pickedImages.add(File(img.path));
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var placesBloc = Provider.placesBlocOf(context);

    var _screenHeight = MediaQuery.of(context).size.height - kToolbarHeight;
    var _screenWidth = MediaQuery.of(context).size.width;

    Widget _loader = Container(
        child: Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
    ));

    return Dialog(
      child: Container(
        width: double.infinity,
        height: _screenHeight * 0.54,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              "Crear reseña",
              style: TextStyle(
                  fontSize: 25,
                  color: Theme.of(context).textTheme.bodyText1.color),
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
                          prefixIcon: Icon(Icons.reviews,
                              color:
                                  Theme.of(context).textTheme.bodyText1.color),
                          labelText: 'Reseña',
                          labelStyle: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1.color)),
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
                          prefixIcon: Icon(Icons.star,
                              color:
                                  Theme.of(context).textTheme.bodyText1.color),
                          labelText: 'Puntuacion',
                          labelStyle: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1.color)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 10,
                ),
                ElevatedButton.icon(
                    onPressed: () async {
                      if (await Permission.mediaLibrary.request().isGranted) {
                        _uploadImage();
                      } else {
                        return;
                      }
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
                      "Subir imágenes",
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            pickedImages.length > 0
                ? Expanded(
                    child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (final entry in pickedImages)
                          Container(
                            padding: EdgeInsets.only(right: 10),
                            child: CircleAvatar(
                              radius: _screenHeight * 0.03,
                              backgroundImage: FileImage(entry),
                            ),
                          )
                      ],
                    ),
                  ))
                : Container(),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Expanded(
                      child: isLoading
                          ? _loader
                          : ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.indigo.shade900),
                              onPressed: () {
                                _saveForm(
                                    pref.getUserId().toString(), placesBloc);
                              },
                              icon: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              label: Text(
                                "Publicar reseña",
                                style: TextStyle(color: Colors.white),
                              )),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
