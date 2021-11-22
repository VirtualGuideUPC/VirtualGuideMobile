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
import 'package:tour_guide/ui/bloc/reviewsBloc.dart';
import 'package:tour_guide/ui/helpers/utils.dart';
import 'package:tour_guide/ui/pages/experience-detail/ExperienceDetailPage.dart';
import 'package:tour_guide/ui/pages/experience-detail/LocationAndRatingStars.dart';

class AddReview extends StatefulWidget {
  @override
  _AddReview createState() => _AddReview();
}

class _AddReview extends State<AddReview> {
  ReviewsBloc bloc = ReviewsBloc();
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

  void _saveForm(userId, PlacesBloc placesBloc, id) {
    final isValid = _formKey.currentState.validate();
    setState(() {
      isLoading = true;
    });

    if (isValid) {
      this._formKey.currentState.save();
      _toSend.user = int.parse(userId);
      _toSend.touristicPlace = id;
      _toSend.ranking = bloc.stars;
      var now = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd');
      String formattedDate = formatter.format(now);
      this._toSend.date = formattedDate;

      placesBloc.postReview(_toSend, pickedImages).then((value) {
        Utils.homeNavigator.currentState.pop();
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
  void initState() {
    super.initState();
    // bloc.changerating(1);
  }

  @override
  Widget build(BuildContext context) {
    var placesBloc = Provider.placesBlocOf(context);

    var _screenHeight = MediaQuery.of(context).size.height - kToolbarHeight;
    var _screenWidth = MediaQuery.of(context).size.width;

    ExperienceDetailed pageArguments =
        ModalRoute.of(context).settings.arguments as ExperienceDetailed;

    Widget _loader = Container(
        child: Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
    ));

    Widget images = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Comparte algunas fotos de tu visita',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (var i = 0; i < pickedImages.length; i++)
                Stack(
                  overflow: Overflow.visible,
                  children: [
                    Container(
                        margin: EdgeInsets.all(5),
                        width: _screenWidth * 0.20,
                        height: 80,
                        child: Image(
                          fit: BoxFit.cover,
                          image: FileImage(pickedImages[i]),
                        )),
                    Positioned(
                      top: -20,
                      right: -20,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            pickedImages.removeAt(i);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromRadius(5),
                          shape: CircleBorder(),
                          primary: Colors.white,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              if (pickedImages.length < 3)
                ElevatedButton(
                  onPressed: () async {
                    if (await Permission.mediaLibrary.request().isGranted) {
                      _uploadImage();
                    } else {
                      return;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      shape: new RoundedRectangleBorder(
                          side: BorderSide(width: 2, color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(25)))),
                  child: Icon(
                    Icons.photo_camera,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        )
      ],
    );
    Widget title = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Reseña",
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Flexible(
              flex: 2,
              child: Container(
                height: 100,
                child: Image.network(
                  pageArguments.pictures[0],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pageArguments.name,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    Text("Barranco, Lima",
                        style: TextStyle(color: Colors.white))
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
    return StreamBuilder(
        stream: bloc.reviewStarsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //print(snapshot.data);
            return Scaffold(
              extendBodyBehindAppBar: false,
              appBar: AppBar(
                backgroundColor: Color.fromRGBO(79, 77, 140, 1),
                elevation: 0,
              ),
              body: Container(
                color: Color.fromRGBO(79, 77, 140, 1),
                width: double.infinity,
                height: _screenHeight,
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      title,
                      Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text('¿Cómo calificarías tu experiencia?',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              LocationAndRatingStars(
                                  clickeable: true,
                                  starsize: 40,
                                  bs: bloc.reviewStars,
                                  numberStars: snapshot.data),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Escribe tu reseña del lugar',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                onFieldSubmitted: (_) {},
                                maxLines: null,
                                style: TextStyle(color: Colors.white),
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
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 1),
                                  ),
                                  hintText: "Es un gran...",
                                  labelStyle: TextStyle(color: Colors.white),
                                  hintStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              images
                            ],
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: isLoading
                                ? _loader
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.transparent,
                                        shape: new RoundedRectangleBorder(
                                            side: BorderSide(
                                                width: 2, color: Colors.white),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25)))),
                                    onPressed: () {
                                      _saveForm(pref.getUserId().toString(),
                                          placesBloc, pageArguments.id);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      child: Text(
                                        "Enviar",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    )),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Text("data");
          }
        });
  }
}
