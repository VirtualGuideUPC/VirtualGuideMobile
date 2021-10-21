import 'package:flutter/material.dart';
import 'package:tour_guide/data/entities/review.dart';
import 'package:tour_guide/ui/bloc/placesBloc.dart';
import 'package:tour_guide/ui/pages/experience-detail/LocationAndRatingStars.dart';

class AccountReviewCard extends StatefulWidget {
  final Review review;
  AccountReviewCard(this.review);

  @override
  _AccountReviewCardState createState() => _AccountReviewCardState();
}

class _AccountReviewCardState extends State<AccountReviewCard> {
  PlacesBloc placesBloc = PlacesBloc();

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

  Widget title(date) {
    return Container(
      width: double.infinity,
      child: Text(
        date,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget description() {
    return Container(
      width: double.infinity,
      child: Text(
        widget.review.comment,
        textAlign: TextAlign.start,
        style: TextStyle(color: Colors.black, fontSize: 15),
      ),
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
          height: 150,
          child: images.length > 0
              ? PageView.builder(
                  itemCount: images.length,
                  controller:
                      PageController(initialPage: 0, viewportFraction: 0.95),
                  itemBuilder: (ctx, indx) => imageCard(images[indx]),
                )
              : Center(
                  child: Text(
                    "No hay imagenes en esta reseña",
                    style: TextStyle(color: Colors.black),
                  ),
                )),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _screenHeight = MediaQuery.of(context).size.height - kToolbarHeight;
    var _screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(width: 1),
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              title(widget.review.touristicPlaceName),
              description(),
              LocationAndRatingStars(
                  primaryColor: Colors.black,
                  numberStars: widget.review.ranking.toInt()),
              SizedBox(
                height: 5,
              ),
              imageSlider(widget.review.images, _screenWidth, _screenHeight)
            ],
          ),
        ),
      ),
    );
  }
}
