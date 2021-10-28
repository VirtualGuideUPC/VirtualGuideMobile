import 'package:flutter/material.dart';
import 'dart:math';

import 'package:tour_guide/data/entities/experience.dart';
import 'package:tour_guide/data/providers/experienceProvider.dart';
import 'package:tour_guide/ui/bloc/placesBloc.dart';
import 'package:tour_guide/ui/bloc/provider.dart';
import 'package:tour_guide/ui/helpers/utils.dart';

class FlipCard extends StatefulWidget {
  final Function onTap;
  final Function onLongPress;
  final Experience experience;
  final double horizontalPadding;
  FlipCard(
      {@required this.experience,
      this.horizontalPadding = 0,
      this.onTap,
      this.onLongPress,
      Key key})
      : super(key: key);

  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> {
  bool isBack = true;
  double angle = 0;

  final ExperienceProvider experienceProvider = ExperienceProvider();
  void _flip() {
    setState(() {
      angle = (angle + pi) % (2 * pi);
    });
  }

  @override
  Widget build(BuildContext context) {
    final placesBloc = Provider.placesBlocOf(context);
    return GestureDetector(
      onTap: () {
        print("TAP ON THE MAIN DETECTOR");
        if (widget.onTap != null) {
          widget.onTap();
        }
      },
      onLongPress: () {
        if (widget.onLongPress != null) {
          widget.onLongPress();
        }
        _flip();
      },
      child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: angle),
          duration: Duration(milliseconds: 300),
          builder: (BuildContext context, double val, __) {
            //here we will change the isBack val so we can change the content of the card
            if (val >= (pi / 2)) {
              isBack = false;
            } else {
              isBack = true;
            }
            return (Transform(
              //let's make the card flip by it's center
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(val),
              child: Container(
                  child: isBack
                      ? _buildFrontFace(placesBloc)
                      : Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..rotateY(
                                pi), // it will flip horizontally the container
                          child:
                              _buildBackFace()) //else we will display it here,
                  ),
            ));
          }),
    );
  }

  Widget _buildFrontFace(PlacesBloc placesBloc) {
    final experience = widget.experience;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          child: Stack(
            children: [
              Positioned.fill(
                child: FadeInImage(
                    placeholder: AssetImage("assets/img/loading.gif"),
                    image:
                        Utils.getPosterImage(widget.experience.getPosterPath()),
                    fit: BoxFit.fitHeight),
              ),
              Positioned.fill(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(0.55),
                ),
              ),
              Positioned.fill(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  height: double.infinity,
                  child: Text(experience.name,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: GestureDetector(
                    onTap: () {
                      //TODO: send request to set this experience as favorite
                      if (!experience.isFavorite) {
                        placesBloc.postAddFavoriteExperience(
                            experience.id.toString());
                        experience.isFavorite = true;
                        setState(() {});
                      }
                    },
                    child: experience.isFavorite
                        ? Icon(
                            Icons.favorite,
                            color: Colors.deepOrange.shade900,
                          )
                        : Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                          )),
              ),
            ],
          ),
        ));
  }

  Widget _buildBackFace() {
    final TextStyle cardTitleStyle = TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15);
    final TextStyle cardDescriptionStyle =
        TextStyle(color: Colors.white, fontWeight: FontWeight.normal);

    final Experience experience = widget.experience;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          child: Stack(
            children: [
              Positioned.fill(
                child: FadeInImage(
                    placeholder: AssetImage("assets/img/loading.gif"),
                    image: Utils.getPosterImage(experience.getPosterPath()),
                    fit: BoxFit.fitHeight),
              ),
              Positioned.fill(
                child: Container(
                  color: Color.fromRGBO(79, 77, 140, 0.5),
                  padding: EdgeInsets.only(top: 4, left: 8, right: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 20,
                          ),
                          Flexible(
                              fit: FlexFit.loose,
                              child: Text(
                                "${experience.avgRanking}(${experience.nComments}) ${experience.province}",
                                overflow: TextOverflow.ellipsis,
                              ))
                        ],
                      )),
                      Expanded(child: SizedBox()),
                      Flexible(
                          child: Text(
                        experience.name,
                        style: cardTitleStyle,
                        overflow: TextOverflow.ellipsis,
                      )),
                      Expanded(child: SizedBox()),
                      Flexible(
                          flex: 4,
                          fit: FlexFit.tight,
                          child: SingleChildScrollView(
                              child: Text(
                            experience.shortInfo,
                            style: cardDescriptionStyle,
                            textAlign: TextAlign.center,
                          ))),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Icon(Icons.arrow_circle_down_rounded,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
