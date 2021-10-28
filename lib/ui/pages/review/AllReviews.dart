import 'package:flutter/material.dart';
import 'package:tour_guide/data/entities/review.dart';
import 'package:tour_guide/ui/pages/experience-detail/LocationAndRatingStars.dart';

class AllReviews extends StatefulWidget {
  AllReviews();

  @override
  _AllReviewsState createState() => _AllReviewsState();
}

class _AllReviewsState extends State<AllReviews> {
  @override
  Widget build(BuildContext context) {
    List<Review> pageArguments = ModalRoute.of(context).settings.arguments;
    var _screenHeight = MediaQuery.of(context).size.height - kToolbarHeight;
    var _screenWidth = MediaQuery.of(context).size.width;

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
                    controller:
                        PageController(initialPage: 0, viewportFraction: 0.95),
                    itemBuilder: (ctx, indx) => imageCard(images[indx]),
                  )
                : Text("")),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: _screenWidth,
        height: _screenHeight,
        padding: EdgeInsets.all(10),
        color: Color.fromRGBO(79, 77, 140, 1),
        child: Column(
          children: [
            Text(
              "Todas las reseñas",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: pageArguments.length,
                  itemBuilder: (ctx, indx) {
                    return Container(
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(color: Colors.white, width: 1))),
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
                              Text(pageArguments[indx].userName,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          LocationAndRatingStars(
                            numberStars: pageArguments[indx].ranking.toInt(),
                            numberComments: 0,
                            withLabel: false,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            pageArguments[indx].date,
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(pageArguments[indx].comment,
                              style: TextStyle(color: Colors.white)),
                          SizedBox(
                            height: 10,
                          ),
                          imageSlider(pageArguments[indx].images, _screenWidth,
                              _screenHeight)
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
