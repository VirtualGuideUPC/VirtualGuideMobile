import 'package:flutter/material.dart';
import 'package:tour_guide/data/entities/category.dart';
import 'package:tour_guide/data/providers/userProvider.dart';
import 'package:tour_guide/ui/bloc/preferencesBloc.dart';

class TravelStyleDialog extends StatefulWidget {
  TravelStyleDialog();

  @override
  _TravelStyleDialogState createState() => _TravelStyleDialogState();
}

class _TravelStyleDialogState extends State<TravelStyleDialog> {
  var preferencesBloc = PreferencesBloc();
  var validating = true;

  @override
  void initState() {
    super.initState();
  }

  validateCategories(
      List<Category> allCategories, List<Category> userCategories) {
    allCategories.forEach((cat) {
      userCategories.forEach((userCat) {
        if (cat.id == userCat.id) {
          cat.isSelected = true;
        }
      });
    });
  }

  updateLoader() {
    validating = false;
  }

  @override
  Widget build(BuildContext context) {
    var _deviceWidth = MediaQuery.of(context).size.width;
    var _deviceHeight = MediaQuery.of(context).size.height - kToolbarHeight;
    Widget textWithStroke(
        {String text,
        String fontFamily,
        double fontSize: 12,
        double strokeWidth: 1,
        Color textColor: Colors.white,
        Color strokeColor: Colors.black}) {
      return Stack(
        children: <Widget>[
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: fontFamily,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = strokeWidth
                ..color = strokeColor,
            ),
          ),
          Text(text,
              style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: fontSize,
                  color: textColor)),
        ],
      );
    }

    Widget getImageWidget(Category category) {
      return GestureDetector(
        onTap: () {
          List<Category> test = [];
          preferencesBloc.changeCategories(test);
          category.isSelected = !category.isSelected;

          preferencesBloc.updateCategory(category);
        },
        child: Container(
          decoration: new BoxDecoration(color: Colors.white),
          width: double.infinity,
          height: 275,
          child: Stack(
            children: <Widget>[
              Image.network(
                category.icon,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
              ),
              Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
              ),
              category.isSelected
                  ? Positioned(
                      top: 0,
                      right: 0,
                      bottom: 0,
                      left: 0,
                      child: Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 50,
                      ))
                  : Text(""),
              Positioned(
                  bottom: 10,
                  left: 10,
                  child: textWithStroke(text: category.name, fontSize: 12)),
            ],
          ),
        ),
      );
    }

    Widget _loader = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ),
    );

    showCategories(List<Category> categories) {
      List<GridTile> gridTilesList = [];
      categories.forEach((style) {
        gridTilesList.add(GridTile(
          child: style.isSelected
              ? ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      Colors.deepPurpleAccent.withOpacity(0.4),
                      BlendMode.srcOver),
                  child: getImageWidget(style))
              : getImageWidget(style),
        ));
      });
      return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1,
        mainAxisSpacing: 10,
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        crossAxisSpacing: 10,
        shrinkWrap: true,
        children: gridTilesList,
      );
    }

    return Dialog(
        insetPadding: EdgeInsets.all(10),
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        child: Container(
          width: _deviceWidth,
          height: _deviceHeight * 0.9,
          child: FutureBuilder(
            future: UserProvider().getCategories(),
            builder: (ctx, snapshot) {
              if (snapshot.hasData) {
                var allcategories = snapshot.data;
                preferencesBloc.getCategoriesData();
                return StreamBuilder(
                    stream: preferencesBloc.categoriesStream,
                    builder: (ctx, snapshot2) {
                      if (snapshot2.hasData) {
                        var userCategories = snapshot2.data as List;
                        validateCategories(allcategories, userCategories);
                        return Container(
                          padding: EdgeInsets.all(10),
                          child: userCategories.length > 0
                              ? showCategories(snapshot.data)
                              : Center(
                                  child: CircularProgressIndicator(
                                  color: Colors.blue,
                                )),
                        );
                      } else {
                        return _loader;
                      }
                    });
              } else {
                return Center(
                    child: CircularProgressIndicator(
                  color: Colors.blue,
                ));
              }
            },
          ),
        ));
  }
}
