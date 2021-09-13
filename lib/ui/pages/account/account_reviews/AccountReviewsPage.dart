import 'package:flutter/material.dart';
import 'package:tour_guide/data/entities/review.dart';
import 'package:tour_guide/ui/bloc/reviewsBloc.dart';
import 'package:tour_guide/ui/pages/account/account_reviews/AccountReviewCard.dart';

class AccountReviewsPage extends StatefulWidget {
  AccountReviewsPage();

  @override
  _AccountReviewsPageState createState() => _AccountReviewsPageState();
}

class _AccountReviewsPageState extends State<AccountReviewsPage> {
  var reviewBloc = ReviewsBloc();

  @override
  void initState() {
    super.initState();
    reviewBloc.getReviewsByUserId();
  }

  @override
  Widget build(BuildContext context) {
    var _screenHeight = MediaQuery.of(context).size.height - kToolbarHeight;
    var _screenWidth = MediaQuery.of(context).size.width;

    Widget _title = Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("RECOPILACIÓN DE TUS EXPERIENCIAS",
              style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyText2.color,
                  fontWeight: FontWeight.w400)),
          /* IconButton(
            onPressed: () {},
            icon: Icon(Icons.filter_alt,
                color: Theme.of(context).textTheme.bodyText1.color),
          ),*/
        ],
      ),
    );

    Widget _loader = Container(
        color: Theme.of(context).dialogBackgroundColor,
        child: Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.white,
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ));

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("EXPERIENCIAS",
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText1.color)),
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        iconTheme:
            IconThemeData(color: Theme.of(context).textTheme.bodyText1.color),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 0),
        width: _screenWidth,
        height: _screenHeight - kToolbarHeight,
        color: Theme.of(context).dialogBackgroundColor,
        child: Column(
          children: [
            _title,
            Expanded(
              child: StreamBuilder(
                  stream: reviewBloc.reviewsStream,
                  builder: (ctx, snapshot) {
                    if (snapshot.hasData) {
                      var reviews = snapshot.data as List<Review>;
                      return Container(
                        child: ListView.builder(
                          itemBuilder: (ctx, indx) {
                            return AccountReviewCard(reviews[indx]);
                          },
                          itemCount: reviews.length,
                        ),
                      );
                    } else {
                      return _loader;
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}