import 'package:flutter/material.dart';
import 'package:tour_guide/data/datasource/userPreferences.dart';
import 'package:tour_guide/data/entities/experience.dart';
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
      this._formKey.currentState.save();
      _toSend.user = int.parse(userId);
      _toSend.touristicPlace = widget.experience.id;
      var now = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd');
      String formattedDate = formatter.format(now);
      this._toSend.date = formattedDate;
    }
    placesBloc.postReview(_toSend).then((value) {
      Navigator.pop(context);
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
              style: TextStyle(fontSize: 20),
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
