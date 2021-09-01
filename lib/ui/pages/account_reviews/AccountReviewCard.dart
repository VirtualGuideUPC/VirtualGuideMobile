import 'package:flutter/material.dart';

class AccountReviewCard extends StatefulWidget {
  AccountReviewCard();

  @override
  _AccountReviewCardState createState() => _AccountReviewCardState();
}

class _AccountReviewCardState extends State<AccountReviewCard> {
  var list = new List(5);

  Widget imageCard() {
    return Container(
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          color: Colors.green, borderRadius: BorderRadius.circular(10)),
      width: double.infinity,
      height: 150,
    );
  }

  Widget locationAndRating() {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Text(
            "Ciudad, País",
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
          SizedBox(
            width: 10,
          ),
          for (var item in list) Icon(Icons.star),
        ],
      ),
    );
  }

  Widget title() {
    return Container(
      width: double.infinity,
      child: Text(
        "Nombre del lugar",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 17),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget description() {
    return Container(
      width: double.infinity,
      child: Text(
        "Descripción",
        textAlign: TextAlign.start,
        style: TextStyle(color: Colors.black, fontSize: 15),
      ),
    );
  }

  Widget imageSlider() {
    return Container(
        width: double.infinity,
        height: 150,
        child: PageView.builder(
          controller: PageController(initialPage: 0, viewportFraction: 0.95),
          itemBuilder: (ctx, indx) => imageCard(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(width: 1),
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            title(),
            locationAndRating(),
            description(),
            SizedBox(
              height: 5,
            ),
            imageSlider()
          ],
        ),
      ),
    );
  }
}
