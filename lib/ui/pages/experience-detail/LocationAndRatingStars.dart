import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:tour_guide/ui/bloc/reviewsBloc.dart';

class LocationAndRatingStars extends StatefulWidget {
  int numberStars;
  int numberComments = 0;
  bool withLabel = true;
  bool withNumbersOfComments = false;
  bool clickeable = false;
  BehaviorSubject<int> bs = null;
  double starsize = 25;
  Color primaryColor = Colors.white;
  LocationAndRatingStars(
      {@required this.numberStars,
      this.numberComments = 0,
      this.withNumbersOfComments = false,
      this.starsize = 25,
      this.bs = null,
      this.primaryColor = Colors.white,
      this.clickeable = false,
      this.withLabel = true});

  @override
  _LocationAndRatingStarsState createState() => _LocationAndRatingStarsState();
}

class _LocationAndRatingStarsState extends State<LocationAndRatingStars> {
  IconData icon = Icons.star;

  ReviewsBloc bloc = ReviewsBloc();

  changeStars(List starList, numberOfStars) {
    for (var j = 0; j < numberOfStars; j++) {
      starList[j] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var paintedStars = List.filled(widget.numberStars, 1);
    var noPaintedStars = List.filled(5 - paintedStars.length, 1);

    return widget.clickeable
        ? StreamBuilder(
            stream: widget.bs.stream,
            builder: (ctx, snapshot) {
              if (snapshot.hasData) {
                var starsList = List.filled(5, false);
                changeStars(starsList, snapshot.data);
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    children: [
                      for (var i = 0; i < starsList.length; i++)
                        GestureDetector(
                          onTap: () {
                            widget.bs.add(i + 1);
                          },
                          child: Icon(
                            icon,
                            color: starsList[i]
                                ? widget.primaryColor
                                : widget.primaryColor.withOpacity(0.4),
                            size: widget.starsize,
                          ),
                        ),
                      SizedBox(
                        width: 10,
                      ),
                      if (widget.withLabel &&
                          widget.numberComments > 0 &&
                          widget.withNumbersOfComments)
                        widget.numberComments > 1
                            ? Text(
                                widget.numberComments.toString() + " Opiniones")
                            : Text(
                                widget.numberComments.toString() + " Opinión"),
                      if (!widget.withLabel &&
                          widget.numberComments > 0 &&
                          widget.withNumbersOfComments)
                        Text(widget.numberComments.toString()),
                    ],
                  ),
                );
              } else {
                return Text("");
              }
            })
        : Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              children: [
                for (var paintedStar in paintedStars)
                  Icon(
                    icon,
                    color: widget.primaryColor,
                    size: widget.starsize,
                  ),
                for (var i = 0; i < noPaintedStars.length; i++)
                  Icon(
                    icon,
                    color: widget.primaryColor.withOpacity(0.4),
                    size: widget.starsize,
                  ),
                SizedBox(
                  width: 10,
                ),
                if (widget.withLabel &&
                    widget.numberComments > 0 &&
                    widget.withNumbersOfComments)
                  widget.numberComments > 1
                      ? Text(widget.numberComments.toString() + " Opiniones")
                      : Text(widget.numberComments.toString() + " Opinión"),
                if (!widget.withLabel &&
                    widget.numberComments > 0 &&
                    widget.withNumbersOfComments)
                  Text(widget.numberComments.toString()),
              ],
            ),
          );
  }
}
