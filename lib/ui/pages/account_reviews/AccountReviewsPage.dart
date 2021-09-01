import 'package:flutter/material.dart';
import 'package:tour_guide/ui/pages/account_reviews/AccountReviewCard.dart';

class AccountReviewsPage extends StatefulWidget {
  AccountReviewsPage();

  @override
  _AccountReviewsPageState createState() => _AccountReviewsPageState();
}

class _AccountReviewsPageState extends State<AccountReviewsPage> {
  @override
  Widget build(BuildContext context) {
    var _screenHeight = MediaQuery.of(context).size.height - kToolbarHeight;
    var _screenWidth = MediaQuery.of(context).size.width;

    Widget _title = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("EXPERIENCIAS",
              style: TextStyle(
                  fontSize: 17,
                  color: Theme.of(context).textTheme.bodyText2.color,
                  fontWeight: FontWeight.w400)),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.filter_alt,
                color: Theme.of(context).textTheme.bodyText1.color),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        iconTheme:
            IconThemeData(color: Theme.of(context).textTheme.bodyText1.color),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        width: _screenWidth,
        height: _screenHeight,
        color: Theme.of(context).dialogBackgroundColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _title,
              Container(
                height: _screenHeight * 0.8,
                child: ListView.builder(itemBuilder: (ctx, indx) {
                  return AccountReviewCard();
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
