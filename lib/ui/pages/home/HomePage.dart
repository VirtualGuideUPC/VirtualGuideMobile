import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tour_guide/main.dart';
import 'package:tour_guide/ui/helpers/utils.dart';
import 'package:tour_guide/ui/pages/account/account_information/AccountInformation.dart';
import 'package:tour_guide/ui/pages/account/account_preferences/AccountPreferences.dart';
import 'package:tour_guide/ui/pages/account/account_reviews/AccountReviewsPage.dart';
import 'package:tour_guide/ui/pages/account/account_settings/AcountSettingsPage.dart';
import 'package:tour_guide/ui/pages/chat/ChatPage.dart';
import 'package:tour_guide/ui/pages/experience-detail/ExperienceDetailPage.dart';
import 'package:tour_guide/ui/pages/explore/ExplorePage.dart';
import 'package:tour_guide/ui/pages/favorite_departments/FavoriteDepartmentsPage.dart';
import 'package:tour_guide/ui/pages/favorite_experiences/FavoriteExperiencesPage.dart';
import 'package:tour_guide/ui/pages/login/LoginPage.dart';
import 'package:tour_guide/ui/routes/routes.dart';

class HomePage extends StatefulWidget {
  final String homePageRoute;
  HomePage({@required this.homePageRoute});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with
        AutomaticKeepAliveClientMixin<HomePage>,
        SingleTickerProviderStateMixin {
  StreamController<int> _streamIndexCurrentTab = StreamController<int>();
  TabController tabController;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: TabBar(
            onTap: (index) {
              switch (index) {
                case 0:
                  Utils.homeNavigator.currentState
                      .pushReplacementNamed(routeHomeExplorerPage);
                  break;
                case 1:
                  Utils.homeNavigator.currentState
                      .pushReplacementNamed(routeHomeChatPage);
                  break;
                case 2:
                  Utils.homeNavigator.currentState
                      .pushReplacementNamed(routeHomeAccountPage);
                  break;
              }
              print(index);
              _streamIndexCurrentTab.add(index);
            },
            indicatorColor: Colors.transparent,
            physics: NeverScrollableScrollPhysics(),
            controller: tabController,
            tabs: [
              Tab(
                icon: Icon(
                  Icons.directions_car,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
              Tab(
                  icon: Icon(
                Icons.directions_transit,
                color: Theme.of(context).iconTheme.color,
              )),
              Tab(
                  icon: Icon(
                Icons.directions_bike,
                color: Theme.of(context).iconTheme.color,
              )),
            ],
          ),
          body: SafeArea(
            top: true,
            child: Navigator(
              key: Utils.homeNavigator,
              initialRoute: widget.homePageRoute,
              onGenerateRoute: _onGenerateRoute,
            ),
          )),
    );
  }

  Route _onGenerateRoute(RouteSettings settings) {
    Widget page;
    switch (settings.name) {
      case routeHomeExplorerPage:
        page = ExplorePage();
        break;
      case routeHomeChatPage:
        page = ChatPage();
        break;
      case routeHomeAccountPage:
        page = AccountSettingsPage();
        break;
      case routeHomeAccountPreferencesPage:
        page = AccountPreferencesPage();
        break;

      case routeHomeAccountReviewsPage:
        page = AccountReviewsPage();
        break;
      case routeHomeFavoriteDepartmentsPage:
        page = FavoriteDepartments();
        break;
      case routeHomeFavoriteExperiencesPage:
        page = FavoriteExperiences();
        break;
      case routeHomeExperienceDetailsPage:
        page = ExperienceDetails();
        break;
      default:
        print("NOMBRE SUBRUTA: " + settings.name);
    }

    return MaterialPageRoute<dynamic>(
      builder: (context) {
        return page;
      },
      settings: settings,
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
                  fontSize: 35,
                  color: Colors.white,
                  backgroundColor: Colors.black,
                  fontFamily: "Signatra"),
            ),
          ],
        ),
      ),
    );
  }
}
