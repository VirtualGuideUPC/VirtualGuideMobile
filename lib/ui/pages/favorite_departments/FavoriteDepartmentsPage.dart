import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:tour_guide/data/entities/department.dart';
import 'package:tour_guide/data/providers/experienceProvider.dart';
import 'package:tour_guide/main.dart';
import 'package:tour_guide/ui/helpers/utils.dart';
import 'package:tour_guide/ui/routes/routes.dart';

class FavoriteDepartments extends StatefulWidget {
  const FavoriteDepartments({Key key}) : super(key: key);

  @override
  _FavoritePlacesState createState() => _FavoritePlacesState();
}

class _FavoritePlacesState extends State<FavoriteDepartments> {
  Future<List<Department>> futureDepartments;
  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);

    futureDepartments =
        ExperienceProvider().getFavoriteExperiencesDepartments();
  }

  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    Utils.homeNavigator.currentState.pop();
    return true;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            iconTheme: IconThemeData(
                color: Theme.of(context).textTheme.bodyText1.color),
            backgroundColor: Theme.of(context).dialogBackgroundColor,
            elevation: 0,
            title: Text("FAVORITOS",
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1.color))),
        body: _buildContent(context));
  }

  Widget _buildContent(BuildContext context) {
    return FutureBuilder(
      future: futureDepartments,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data as List;
          return data.length > 0
              ? Container(
                  height: double.infinity,
                  color: Theme.of(context).dialogBackgroundColor,
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child:
                      ListView(children: _buildCards(context, snapshot.data)),
                )
              : Container(
                  height: double.infinity,
                  color: Theme.of(context).dialogBackgroundColor,
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error,
                        color: Theme.of(context).textTheme.bodyText1.color,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("No tiene favoritos agregados")
                    ],
                  ),
                );
        } else if (snapshot.hasError) {
          if (snapshot.error == '401') {
            //TODO: handle session expired
            Future.delayed(
                Duration.zero, () => Utils.homeNavigator.currentState.pop());
          } else {
            Future.delayed(
                Duration.zero, () => Utils.homeNavigator.currentState.pop());
          }
          return Container(
            color: Theme.of(context).dialogBackgroundColor,
          );
        } else {
          return Container(
            color: Theme.of(context).dialogBackgroundColor,
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  List<Widget> _buildCards(BuildContext context, List<Department> departments) {
    final _screenSize = MediaQuery.of(context).size;
    final _imageGridWidth = _screenSize.width - 50;
    final _imageGridHeight = _screenSize.width * 0.4;

    return departments.map((item) {
      return GestureDetector(
        onTap: () {
          Utils.homeNavigator.currentState
              .pushNamed(routeHomeFavoriteExperiencesPage, arguments: item);
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: Colors.black45),
              color: Colors.white),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: _imageGridWidth,
                  height: _imageGridHeight,
                  child: Stack(
                    children: [
                      Positioned(
                        width: _imageGridWidth * 0.6,
                        height: _imageGridHeight,
                        child: Container(
                          padding: EdgeInsets.only(right: 4),
                          child: FadeInImage(
                              placeholder: AssetImage('assets/img/loading.gif'),
                              image: Utils.getPosterImage(
                                  _getImgUrlFormDepartment(item.pictures, 0)),
                              fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        width: _imageGridWidth * 0.4,
                        height: _imageGridHeight * 0.5,
                        top: 0,
                        right: 0,
                        child: FadeInImage(
                            placeholder: AssetImage('assets/img/loading.gif'),
                            image: Utils.getPosterImage(
                                _getImgUrlFormDepartment(item.pictures, 1)),
                            fit: BoxFit.cover),
                      ),
                      Positioned(
                        width: _imageGridWidth * 0.4,
                        height: _imageGridHeight * 0.5,
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.only(top: 4),
                          child: FadeInImage(
                              placeholder: AssetImage('assets/img/loading.gif'),
                              image: Utils.getPosterImage(
                                  _getImgUrlFormDepartment(item.pictures, 2)),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(20),
                    child: Text(item.name,
                        style: TextStyle(fontSize: 20, color: Colors.black)))
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  String _getImgUrlFormDepartment(List<String> urls, int index) {
    if (index < urls.length) {
      return urls[index];
    } else {
      return '';
    }
  }
}
