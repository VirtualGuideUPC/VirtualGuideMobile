
import 'package:flutter/material.dart';

import 'HomePage.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> with AutomaticKeepAliveClientMixin<ExplorePage>{


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => throw UnimplementedError();

}

class UserResult extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3),
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Text(
                          "  Hey!  ",
                          style: TextStyle(
                              fontSize:35,
                              color: Colors.white,
                              backgroundColor: Colors.black,
                              fontFamily: "Signatra"
                          ),
                        ),
          ],
        ),
      ),
    );
  }



}