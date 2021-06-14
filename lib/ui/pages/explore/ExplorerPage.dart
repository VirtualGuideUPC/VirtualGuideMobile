import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tour_guide/ui/pages/explore/ChatbotPage.dart';
import 'package:tour_guide/ui/pages/explore/HomePage.dart';
import 'package:tour_guide/ui/pages/explore/UserSettingsPage.dart';


class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> with AutomaticKeepAliveClientMixin<ExplorePage>, SingleTickerProviderStateMixin{
  StreamController<int> _streamIndexCurrentTab= StreamController<int>();
  TabController tabController;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() { 
    tabController =
        TabController(length: 3, vsync: this, initialIndex: 0);
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
            resizeToAvoidBottomInset:false,
      appBar: TabBar(
        onTap: (index){
          _streamIndexCurrentTab.add(index);

        },
        indicatorColor: Colors.transparent,
        physics: NeverScrollableScrollPhysics(),
        controller:tabController,
        tabs: [
          Tab(icon: Icon(Icons.directions_car,color: Theme.of(context).iconTheme.color,),),
          Tab(icon: Icon(Icons.directions_transit,color: Theme.of(context).iconTheme.color,)),
          Tab(icon: Icon(Icons.directions_bike,color: Theme.of(context).iconTheme.color,)),
        ],
        
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
            controller: tabController,
            children: [
              HomePage(_streamIndexCurrentTab.stream),
              ChatbotPage(),
              UserSettingsPage(),
            ],
          ),
    );
  }

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