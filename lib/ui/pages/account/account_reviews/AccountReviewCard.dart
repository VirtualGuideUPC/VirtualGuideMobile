import 'package:flutter/material.dart';
import 'package:tour_guide/data/entities/experienceDetailed.dart';
import 'package:tour_guide/data/entities/review.dart';
import 'package:tour_guide/ui/bloc/placesBloc.dart';

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

  Widget locationAndRating(stars) {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Text(
            "Puntaje",
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
          SizedBox(
            width: 10,
          ),
          for (var item in stars) Icon(Icons.star),
        ],
      ),
    );
  }

  Widget title(date) {
    return Container(
      width: double.infinity,
      child: Text(
        date,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
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

  Widget imageSlider(List<ReviewImage> images) {
    return Container(
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
              ));
  }

  @override
  Widget build(BuildContext context) {
    var stars = new List.filled(widget.review.ranking, 1);

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
              locationAndRating(stars),
              description(),
              title(widget.review.date),
              SizedBox(
                height: 5,
              ),
              imageSlider(widget.review.images)
            ],
          ),
        ),
      ),
    );
  }
}
