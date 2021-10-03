import 'package:flutter/material.dart';

class LocationAndRatingStars extends StatelessWidget {
  int numberStars;
  int numberComments = 0;
  bool withLabel = true;
  bool withNumbersOfComments = false;
  LocationAndRatingStars(
      {@required this.numberStars,
      this.numberComments = 0,
      this.withNumbersOfComments = false,
      this.withLabel = true});

  @override
  Widget build(BuildContext context) {
    var paintedStars = List.filled(numberStars, 1);
    var noPaintedStars = List.filled(5 - paintedStars.length, 1);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 10, bottom: 10),
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
          if (withLabel && numberComments > 0 && withNumbersOfComments)
            numberComments > 1
                ? Text(numberComments.toString() + " Opiniones")
                : Text(numberComments.toString() + " Opinión"),
          if (!withLabel && numberComments > 0 && withNumbersOfComments)
            Text(numberComments.toString()),
        ],
      ),
    );
    ;
  }
}
