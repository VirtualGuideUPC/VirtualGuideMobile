import 'dart:math';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tour_guide/data/entities/experience.dart';
import 'package:tour_guide/data/entities/experienceDetailed.dart';
import 'package:tour_guide/data/providers/experienceProvider.dart';
import 'package:tour_guide/ui/bloc/placesBloc.dart';
import 'package:tour_guide/ui/bloc/provider.dart';
import 'package:tour_guide/ui/helpers/notificationUtil.dart';
import 'package:tour_guide/ui/helpers/utils.dart';
import 'package:tour_guide/ui/pages/review/review_dialog.dart';
import 'package:tour_guide/ui/routes/routes.dart';
import 'package:tour_guide/ui/widgets/FlipCardWidget.dart';

class ExperienceDetails extends StatefulWidget {
  const ExperienceDetails({Key key}) : super(key: key);

  @override
  _ExperienceDetailState createState() => _ExperienceDetailState();
}

class _ExperienceDetailState extends State<ExperienceDetails> {
  Future<ExperienceDetailed> futureExperienceDetail;
  @override
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

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    final Experience experience = ModalRoute.of(context)
        .settings
        .arguments; // error when trying to retrieve the argument passed to this widget from the initState method, thats why it is being done in this weird method
    futureExperienceDetail =
        ExperienceProvider().getExperienceDetail(experience.id.toString());

    final placesBloc = Provider.placesBlocOf(context);
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(top: statusBarHeight),
              child: Column(
                children: [
                  _buildContent(context, placesBloc, futureExperienceDetail),
                ],
              )),
        )
        // body: FutureBuilder(
        //   future: Future,
        //   builder: (BuildContext context, AsyncSnapshot snapshot) {
        //     if(snapshot.hasData){
        //       Container(padding:EdgeInsets.only(top:statusBarHeight) ,
        //         child:Column(
        //           children: [
        //             _buildCarousel()
        //           ],
        //         )
        //       );
        //     }else{
        //       return Container(
        //         child:Center(child: CircularProgressIndicator(),),
        //       );
        //     }
        //   },
        // ),
        );
  }

  Widget _buildContent(BuildContext context, PlacesBloc placesBloc,
      Future<ExperienceDetailed> experienceDetail) {
    return FutureBuilder(
      future: futureExperienceDetail,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Stack(children: [
            Column(mainAxisSize: MainAxisSize.min, children: [
              _buildCarousel(context, snapshot.data),
              _buildDetails(context, snapshot.data)
            ]),
            Positioned(
                right: 5,
                bottom: 10,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      onPrimary: Colors.white,
                      primary: Color.fromRGBO(106, 194, 194, 1),
                      padding: EdgeInsets.all(15),
                    ),
                    onPressed: () {
                      Utils.homeNavigator.currentState.pushReplacementNamed(
                          routeHomeExperienceDetailsPage,
                          arguments: ModalRoute.of(context).settings.arguments);
                    },
                    child: Icon(Icons.add)))
          ]);
        } else if (snapshot.hasError) {
          if (snapshot.error == '401') {
            Future.delayed(
                Duration.zero, () => Utils.homeNavigator.currentState.pop());
          } else {
            Future.delayed(
                Duration.zero, () => Utils.homeNavigator.currentState.pop());
          }
          return Container();
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildCarousel(
      BuildContext context, ExperienceDetailed experienceDetails) {
    return SizedBox(
        width: double.infinity,
        height: 400,
        child: experienceDetails.pictures.length > 0
            ? Carousel(
                images: experienceDetails.pictures
                    .map((item) => NetworkImage(item))
                    .toList())
            : Image(image: AssetImage("assets/img/no-image.jpg")));
  }

  Widget _buildDetails(
      BuildContext context, ExperienceDetailed experienceDetails) {
    final info = _sectionWithIcon(experienceDetails.name, () {
      return Container(
          child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Text(
          experienceDetails.longInfo,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ));
    }, () {
      return experienceDetails.isFavourite
          ? GestureDetector(
              onTap: () {
                ExperienceProvider()
                    .postAddFavoriteExperience(experienceDetails.id.toString());
              },
              child: Icon(
                Icons.favorite,
                color: Theme.of(context).textTheme.bodyText1.color,
              ))
          : IconButton(
              onPressed: () {
                ExperienceProvider()
                    .postAddFavoriteExperience(experienceDetails.id.toString())
                    .then((value) {
                  if (value) {
                    NotificationUtil().showSnackbar(
                        context,
                        "Se ha agregado a favoritos correctamente",
                        "success",
                        null);
                  }
                });
              },
              icon: Icon(Icons.favorite_border,
                  color: Theme.of(context).textTheme.bodyText1.color));
    });

    final more = _section("Descubre más de ...", () {
      return _slider(experienceDetails.categories.length, 0.6, 110,
          (context, i) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                  fit: FlexFit.tight,
                  child: Text(experienceDetails.categories[i].name,
                      style: TextStyle(fontSize: 24))),
              //Flexible(fit: FlexFit.tight, child: SizedBox()),
              //Flexible(fit: FlexFit.tight, child: Text(experienceDetails.categories[i].nExperiences.toString() + " experiencias",style:TextStyle(fontSize:17,color:Colors.black87)))
            ],
          ),
        );
      });
    });
    final location = _section("Donde estarás", () {
      final double lat = double.parse(experienceDetails.latitude);
      final double lng = double.parse(experienceDetails.longitude);
      return Container(
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
      );
    });

    Widget imagesFromReviews(review, deviceHeight, deviceWidth) {
      return review.images.length == 0
          ? Text("")
          : ElevatedButton(
              onPressed: () {
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
                              controller:
                                  PageController(viewportFraction: 0.95),
                              itemCount: review.images.length,
                              itemBuilder: (ctx, indx) {
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              review.images[indx].url))),
                                );
                              }),
                        ),
                      );
                    });
              },
              child: Container(
                padding: EdgeInsets.all(15),
                child: Icon(Icons.photo),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).buttonColor,
                  shape: CircleBorder()),
            );
    }

    final reviews = _section(
        "${experienceDetails.avgRanking} (${experienceDetails.numberComments} comentarios)",
        () {
      return _slider(experienceDetails.reviews.length, 0.7, 250, (context, i) {
        var review = experienceDetails.reviews[i];
        var deviceHeight = MediaQuery.of(context).size.height - kToolbarHeight;
        var deviceWidth = MediaQuery.of(context).size.width;

        return Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    child: Icon(Icons.account_box),
                    radius: 28,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                      height: 56,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            review.userName,
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 5),
                          Text(review.date,
                              style: TextStyle(
                                  fontSize: 17, color: Colors.black54)),
                        ],
                      ))
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Flexible(fit: FlexFit.loose, child: Text(review.comment)),
              Expanded(child: SizedBox()),
              imagesFromReviews(review, deviceHeight, deviceWidth)
            ],
          ),
        );
      });
    });

    Widget similarExperiences;
    if (experienceDetails.similarExperience != null) {
      similarExperiences = _section("Experiencias similaress", () {
        return _slider(experienceDetails.similarExperience.length, 0.45, 250,
            (context, i) {
          final Experience experience = Experience(
              id: experienceDetails.similarExperience[i].id,
              name: experienceDetails.similarExperience[i].name,
              shortInfo: experienceDetails.similarExperience[i].shortInfo,
              picture: experienceDetails.similarExperience[i].pic,
              avgRanking: experienceDetails.similarExperience[i].avgRanking,
              nComments: experienceDetails.similarExperience[i].numberComments,
              province: experienceDetails.similarExperience[i].province,
              isFavorite: false);
          return FlipCard(
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

    return Container(
      color: Color.fromRGBO(79, 77, 140, 1),
      child: Column(children: [
        info,
        more,
        location,
        reviews,
        similarExperiences,
      ]),
    );
  }

  Widget _section(String title, Function body) {
    return Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 25),
                textAlign: TextAlign.start,
              )
            ]),
            SizedBox(
              height: 15,
            ),
            body()
          ],
        ));
  }

  Widget _sectionWithIcon(String title, Function body, Function icon) {
    return Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Flexible(
                flex: 4,
                child: Text(
                  title,
                  style: TextStyle(color: Colors.white, fontSize: 25),
                  textAlign: TextAlign.start,
                ),
              ),
              Flexible(flex: 1, child: icon())
            ]),
            SizedBox(
              height: 15,
            ),
            body()
          ],
        ));
  }

  Widget _slider(int itemCount, double viewportFraction, double height,
      Function itemBuilder) {
    final _pageController =
        new PageController(initialPage: 1, viewportFraction: viewportFraction);
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
                      color: Colors.white, child: itemBuilder(context, i))));
        },
      ),
    );
  }
}
