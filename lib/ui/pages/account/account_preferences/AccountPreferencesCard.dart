import 'package:flutter/material.dart';

class AccountPreferencesCard extends StatefulWidget {
  final int id;
  final String name;
  final String icon;
  final bool status;
  AccountPreferencesCard({this.id, this.name, this.icon, this.status});

  @override
  _AccountPreferencesCardState createState() => _AccountPreferencesCardState();
}

class _AccountPreferencesCardState extends State<AccountPreferencesCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 10,
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: NetworkImage(widget.icon), fit: BoxFit.cover)),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black.withOpacity(0.5)),
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Tap for more info",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
