import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tour_guide/data/entities/experience.dart';
import 'package:tour_guide/data/entities/experienceDetailed.dart';
import 'package:tour_guide/data/entities/review.dart';
import 'package:tour_guide/data/providers/experienceProvider.dart';
import 'package:tour_guide/ui/bloc/experienceDetailBloc.dart';
import 'package:tour_guide/ui/bloc/provider.dart';
import 'package:tour_guide/ui/helpers/notificationUtil.dart';
import 'package:tour_guide/ui/helpers/utils.dart';
import 'package:tour_guide/ui/pages/experience-detail/LocationAndRatingStars.dart';
import 'package:tour_guide/ui/pages/review/CreateReview.dart';
import 'package:tour_guide/ui/routes/routes.dart';
import 'package:tour_guide/ui/widgets/FlipCardWidget.dart';

class NewExperienceDetailPage extends StatefulWidget {
  NewExperienceDetailPage();

  @override
  _NewExperienceDetailPageState createState() =>
      _NewExperienceDetailPageState();
}

class _NewExperienceDetailPageState extends State<NewExperienceDetailPage> {
  final bloc = ExperienceDetailBloc();
  Future<ExperienceDetailed> futureExperienceDetail;
  var _scrollController = new ScrollController();
  int counter = 0;
  void initState() {
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  _onVerticalGesture(DragUpdateDetails details) {
    if (details.primaryDelta < 0) {
      bloc.changeToDetails();
    } else if (details.primaryDelta > 2) {
      bloc.changeToNormal();
    }
  }

  double _getTopForSlider(ExperienceDetailState state, Size size) {
    if (state == ExperienceDetailState.normal) {
      return 0;
    } else {
      return -(size.height - kToolbarHeight) * 0.55 + 100;
    }
  }

  double _getTopForDetails(ExperienceDetailState state, Size size) {
    if (state == ExperienceDetailState.normal) {
      return (size.height - kToolbarHeight) * 0.8 - 200;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    var _screenHeight = MediaQuery.of(context).size.height - kToolbarHeight;
    var _screenWidth = MediaQuery.of(context).size.width;
    final Experience experience = ModalRoute.of(context)
        .settings
        .arguments; // error when trying to retrieve the argument passed to this widget from the initState method, thats why it is being done in this weird method
    futureExperienceDetail =
        ExperienceProvider().getExperienceDetail(experience.id.toString());

    Widget _buildCarousel(
        BuildContext context, ExperienceDetailed experienceDetails) {
      return Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.only(bottom: 10),
          child: experienceDetails.pictures.length > 0
              ? Carousel(
                  images: experienceDetails.pictures
                      .map((item) => NetworkImage(item))
                      .toList())
              : Image(image: AssetImage("assets/img/no-image.jpg")));
    }

    Widget _buildDetails(BuildContext context,
        ExperienceDetailed experienceDetails, controller) {
      var stars = new List.filled(experienceDetails.avgRanking.toInt(), 1);

      Widget locationAndRating(List paintedStars) {
        var noPaintedStars = List.filled(5 - paintedStars.length, 1);

        return Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 10),
          child: Row(
            children: [
              for (var paintedStar in paintedStars)
                Icon(
                  Icons.circle,
                  color: Colors.white,
                ),
              for (var noPaintedStar in noPaintedStars)
                Icon(Icons.circle, color: Colors.white.withOpacity(0.4)),
              SizedBox(
                width: 10,
              ),
              experienceDetails.numberComments > 1
                  ? Text(experienceDetails.numberComments.toString() +
                      " Opiniones")
                  : Text(
                      experienceDetails.numberComments.toString() + " Opinión"),
            ],
          ),
        );
      }

      Widget smallInfo = Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 3,
                  child: Text(
                    experienceDetails.name,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: IconButton(
                      onPressed: () {
                        if (!experienceDetails.isFavourite) {
                          ExperienceProvider().postAddFavoriteExperience(
                              experience.id.toString());
                          experience.isFavorite = true;
                          NotificationUtil().showSnackbar(
                              context,
                              "Se ha agregado a favoritos correctamente",
                              "success",
                              null);
                        } else {
                          ExperienceProvider().deleteFavoriteExperience(
                              experience.id.toString());
                          experience.isFavorite = false;
                          NotificationUtil().showSnackbar(
                              context,
                              "Se ha eliminado de favoritos correctamente",
                              "warning",
                              null);
                        }
                        setState(() {});
                      },
                      icon: experienceDetails.isFavourite
                          ? Icon(Icons.favorite, color: Colors.white)
                          : Icon(Icons.favorite_border)),
                )
              ],
            ),
            if (experienceDetails.avgRanking > 0)
              LocationAndRatingStars(
                numberStars: experienceDetails.avgRanking.toInt(),
                withLabel: true,
                withNumbersOfComments: true,
                numberComments: experienceDetails.numberComments,
              ),
            SizedBox(
              height: 10,
            ),
            Text("Barranco, Lima", style: TextStyle(color: Colors.white)),
            SizedBox(
              height: 10,
            ),
            Text(
              "Abierto Ahora",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(
              height: 5,
            ),
            Text(experienceDetails.scheaduleInfo,
                style: TextStyle(color: Colors.white)),
          ],
        ),
      );
      Widget _section(String title, Function body) {
        return Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text(
                    title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  )
                ]),
                SizedBox(
                  height: 5,
                ),
                body()
              ],
            ));
      }

      final about = _section("Acerca de", () {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(experienceDetails.longInfo,
                textAlign: TextAlign.justify,
                style: TextStyle(color: Colors.white)),
            SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                Utils.homeNavigator.currentState.pushNamed(
                    routeHomeExperienceDetailsMoreInfoPage,
                    arguments: experienceDetails);
              },
              child: Text(
                "Mostrar Más",
                style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                ),
              ),
            )
          ],
        );
      });
      final location = _section("La zona", () {
        final double lat = double.parse(experienceDetails.latitude);
        final double lng = double.parse(experienceDetails.longitude);
        return Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Dirección",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(
                height: 5,
              ),
              Text("Av. Pedro de Osma 409, Barranco",
                  style: TextStyle(color: Colors.white)),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: GoogleMap(
                    markers: Set<Marker>.of([
                      Marker(
                          markerId: MarkerId('1'),
                          draggable: false,
                          visible: true,
                          position: LatLng(lat, lng))
                    ]),
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: false,
                    initialCameraPosition:
                        CameraPosition(target: LatLng(lat, lng), zoom: 11.5),
                  ),
                ),
              )
            ],
          ),
        );
      });

      Widget imageCard(ReviewImage image) {
        return Container(
          margin: EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage(image.url)),
            borderRadius: BorderRadius.circular(10),
          ),
          width: double.infinity,
          height: 150,
        );
      }

      Widget imageSlider(List<ReviewImage> images, deviceWidth, deviceHeight) {
        return GestureDetector(
          onTap: () {
            if (images.length > 0) {
              showDialog(
                  context: context,
                  builder: (ctx) {
                    return Dialog(
                      insetPadding: EdgeInsets.all(0),
                      backgroundColor: Colors.transparent,
                      child: Container(
                        width: deviceWidth,
                        height: deviceHeight * 0.5,
                        child: PageView.builder(
                            physics: BouncingScrollPhysics(),
                            controller: PageController(viewportFraction: 0.95),
                            itemCount: images.length,
                            itemBuilder: (ctx, indx) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(images[indx].url))),
                              );
                            }),
                      ),
                    );
                  });
            }
          },
          child: Container(
              width: double.infinity,
              height: images.length > 0 ? 120 : 0,
              child: images.length > 0
                  ? PageView.builder(
                      itemCount: images.length,
                      controller: PageController(
                          initialPage: 0, viewportFraction: 0.95),
                      itemBuilder: (ctx, indx) => imageCard(images[indx]),
                    )
                  : Text("")),
        );
      }

      Widget _slider(int itemCount, double viewportFraction, double height,
          Function itemBuilder) {
        final _pageController = new PageController(
            initialPage: 1, viewportFraction: viewportFraction);
        return Container(
          width: double.infinity,
          height: height,
          child: PageView.builder(
            controller: _pageController,
            pageSnapping: false,
            itemCount: itemCount,
            itemBuilder: (context, i) {
              return Container(
                  margin: EdgeInsets.only(right: 8),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Container(
                          color: Colors.white,
                          child: itemBuilder(context, i))));
            },
          ),
        );
      }

      Widget similarExperiences;
      if (experienceDetails.similarExperience != null) {
        similarExperiences = _section("Experiencias similares", () {
          return _slider(experienceDetails.similarExperience.length, 0.45, 250,
              (context, i) {
            final Experience experience = Experience(
                id: experienceDetails.similarExperience[i].id,
                name: experienceDetails.similarExperience[i].name,
                shortInfo: experienceDetails.similarExperience[i].shortInfo,
                picture: experienceDetails.similarExperience[i].pic,
                avgRanking: experienceDetails.similarExperience[i].avgRanking,
                nComments:
                    experienceDetails.similarExperience[i].numberComments,
                province: experienceDetails.similarExperience[i].province,
                isFavorite: false);
            return FlipCard(
              favoriteAvalible: false,
              experience: experience,
              onTap: () {},
            );
          });
        });
      } else {
        similarExperiences = _section("Experiencias similaress", () {
          return _slider(2, 0.45, 250, (context, i) {
            final Experience experience = Experience(
                id: 1,
                name: "Machupicchu",
                shortInfo:
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took ",
                picture:
                    "https://res.cloudinary.com/djtqhafqe/image/upload/v1624908103/taller-desempe%C3%B1o-profesional/pyjoctif663ddfqn8og6.jpg",
                isFavorite: false);
            return FlipCard(
              experience: experience,
              onTap: () {},
            );
          });
        });
      }

      Widget singleReview(Review review) {
        var paintedStars =
            new List.filled(experienceDetails.avgRanking.toInt(), 1);

        return Container(
          decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.white, width: 1))),
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(child: Icon(Icons.account_box)),
                  SizedBox(
                    width: 10,
                  ),
                  Text(review.userName,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              LocationAndRatingStars(
                numberStars: review.ranking.toInt(),
                numberComments: 0,
                withLabel: false,
              ),
              SizedBox(
                height: 10,
              ),
              Text(review.date, style: TextStyle(color: Colors.white)),
              SizedBox(
                height: 10,
              ),
              Text(review.comment, style: TextStyle(color: Colors.white)),
              SizedBox(
                height: 10,
              ),
              imageSlider(review.images, _screenWidth, _screenHeight)
            ],
          ),
        );
      }

      Widget reviewsList() {
        if (experienceDetails.reviews.length == 1 ||
            experienceDetails.reviews.length == 2) {
          return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: experienceDetails.reviews.length,
              itemBuilder: (ctx, indx) {
                return singleReview(experienceDetails.reviews[indx]);
              });
        } else {
          return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 2,
              itemBuilder: (ctx, indx) {
                return singleReview(experienceDetails.reviews[indx]);
              });
        }
      }

      final reviews = _section("Reseñas", () {
        return Container(
          width: double.infinity,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  onPrimary: Colors.white,
                  elevation: 0,
                  primary: Color.fromRGBO(79, 77, 140, 1),
                  padding: EdgeInsets.all(15),
                ),
                onPressed: () {
                  Utils.homeNavigator.currentState
                      .pushNamed(routeHomeExperienceDetailsCreateReviewsPage,
                          arguments: experienceDetails)
                      .then((_) => setState(() {
                            Utils.homeNavigator.currentState
                                .pushReplacementNamed(
                                    routeHomeExperienceDetailsPage,
                                    arguments: ModalRoute.of(context)
                                        .settings
                                        .arguments);
                          }));
                },
                child: Text("Escribir una reseña")),
            Divider(),
            experienceDetails.reviews.length > 0
                ? reviewsList()
                : Column(
                    children: [
                      Text(
                        "Aun no hay reseñas creadas",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
            if (experienceDetails.reviews.length > 2)
              Container(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      onPrimary: Colors.white,
                      elevation: 0,
                      primary: Color.fromRGBO(79, 77, 140, 1),
                      padding: EdgeInsets.all(15),
                    ),
                    onPressed: () {
                      Utils.homeNavigator.currentState.pushNamed(
                          routeHomeExperienceDetailsReviewsPage,
                          arguments: experienceDetails.reviews);
                    },
                    child: Text(
                        'Ver ${experienceDetails.reviews.length} reseñas')),
              )
          ]),
        );
      });

      Widget singleClosestPlace() {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          width: _screenWidth * 0.8,
          height: 150,
          child: Row(
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  child: Image.network(
                      "https://upload.wikimedia.org/wikipedia/commons/a/a4/Pucallpa_Plaza_San_Mart%C3%ADn_Fountain_by_Night.jpg"),
                  color: Colors.blue,
                ),
              ),
              Flexible(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Puente de los Suspiros",
                          style: TextStyle(color: Colors.white)),
                      LocationAndRatingStars(
                          numberStars: 4,
                          numberComments: 40,
                          withNumbersOfComments: true,
                          withLabel: false),
                      Text("Barranco, Lima",
                          style: TextStyle(color: Colors.white))
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }

      final closestPlaces = _section("Lugares Turísticos Cercanos", () {
        return Container(
          width: double.infinity,
          height: 150,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              itemBuilder: (ctx, indx) {
                return singleClosestPlace();
              }),
        );
      });

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 40,
              child: Center(
                child: Container(
                  width: 100,
                  height: 3,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: controller,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    smallInfo,
                    about,
                    location,
                    closestPlaces,
                    reviews,
                    if (experienceDetails.similarExperience.length > 0)
                      similarExperiences,
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    final placesBloc = Provider.placesBlocOf(context);
    var size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: bloc,
      builder: (context, _) {
        return Scaffold(
          extendBodyBehindAppBar: false,
          body: Container(
            width: double.infinity,
            height: size.height - kToolbarHeight,
            child: FutureBuilder(
              future: futureExperienceDetail,
              builder: (ctx, snapshot) {
                if (snapshot.hasData) {
                  return Stack(
                    children: [
                      Positioned(
                        top: _getTopForSlider(bloc.detailedState, size),
                        right: 0,
                        left: 0,
                        child: Container(
                          width: double.infinity,
                          height: (size.height - kToolbarHeight) * 0.55,
                          child: _buildCarousel(context, snapshot.data),
                        ),
                      ),
                      Positioned.fill(
                        bottom: 0,
                        right: 0,
                        child: DraggableScrollableSheet(
                          maxChildSize: 1,
                          minChildSize: 0.5,
                          builder: (ctx, controller) {
                            return Container(
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(79, 77, 140, 1),
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10))),
                                child: _buildDetails(
                                    context, snapshot.data, controller));
                          },
                        ),
                      )
                    ],
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
