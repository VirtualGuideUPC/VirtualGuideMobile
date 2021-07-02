import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tour_guide/ui/pages/chat/ChatPage.dart';
import 'package:tour_guide/ui/pages/explore/ExplorePage.dart';
import 'package:tour_guide/ui/pages/account_settings/UserSettingsPage.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin<HomePage>, SingleTickerProviderStateMixin{
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
              ExplorePage(_streamIndexCurrentTab.stream),
              ChatPage(),
              AccountSettingsPage(),
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