import 'package:flutter/material.dart';
import 'package:tour_guide/data/entities/category.dart';
import 'package:tour_guide/data/entities/user.dart';
import 'package:tour_guide/data/providers/userProvider.dart';
import 'package:tour_guide/ui/bloc/provider.dart';
import 'package:tour_guide/ui/helpers/utils.dart';
import 'package:tour_guide/ui/routes/routes.dart';

class TravelStylesPage extends StatefulWidget {
  @override
  _TravelStylesPageState createState() => _TravelStylesPageState();
}

class _TravelStylesPageState extends State<TravelStylesPage> {

  List<GridTile> gridTilesList = [];
  bool flagRequestSubmitted = false;
  List<Category> userCategories;
  User user;
  Future<List<Category>> futureCategories;
  List<int> selectedCategoriesIds;
  List<Category> selectedCategories = [];

  @override
  void initState() {
    super.initState();
    futureCategories = UserProvider().getCategories();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = ModalRoute.of(context).settings.arguments;
  }

  Widget getImageWidget(Category category) {
    return GestureDetector(
      onTap: () => {
        if (!category.isSelected) {
          selectedCategories.add(category)
        },
        setState(() {
          category.isSelected = !category.isSelected;
        })
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
            category.isSelected
                ? Positioned(
                    top: 0,
                    right: 0,
                    bottom: 0,
                    left: 0,
                    //give the values according to your requirement
                    child: Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 50,
                    )
                    //IconButton(icon: Icon(Icons.delete_forever, color: Colors.redAccent,), onPressed: () {  },),
                    )
                : Text(""),
            Positioned(
                bottom: 10,
                left: 10,
                child: textWithStroke(text: category.name, fontSize: 12)
                ),
          ],
        ),
      ),
    );
  }

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
                fontFamily: fontFamily, fontSize: fontSize, color: textColor)),
      ],
    );
  }

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
      crossAxisSpacing: 10,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: gridTilesList,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.signinBlocOf(context);
    bloc.init();

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: BackButton(
            color: Colors.black,
            onPressed: () {
              bloc.dispose();
              Utils.mainNavigator.currentState.pushReplacementNamed(routeTravelType);
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Stack(children: <Widget>[
          Column(
            children: [
              Text( "Escoge tus estilos",
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center),
              Divider(
                color: Colors.white,
              ),
              _buildContent(context),
              Divider(
                color: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10, left: 10, bottom: 20),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(color: Colors.grey)))),
                  onPressed: () {
                    bloc.dispose();
                    selectedCategoriesIds = selectedCategories.map((e) => e.id).toList();
                    user.categories = selectedCategoriesIds;
                    Utils.mainNavigator.currentState.pushReplacementNamed(routeTravelSubcategories, arguments: user);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Siguiente",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 52.0,
                      ),
                    ],
                  ),
                ),
              )
              // showCategories(userCategories)
            ],
          ),
        ])));
  }

  Widget _buildContent(BuildContext context) {
    return FutureBuilder(
      future: futureCategories,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: showCategories(snapshot.data),
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
          return Container();
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

}
