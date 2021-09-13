import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:tour_guide/data/entities/category.dart';
import 'package:tour_guide/data/entities/preferences.dart';
import 'package:tour_guide/data/entities/subcategory.dart';
import 'package:tour_guide/data/entities/typePlace.dart';
import 'package:tour_guide/data/entities/user.dart';
import 'package:tour_guide/ui/bloc/preferencesBloc.dart';
import 'package:tour_guide/ui/pages/account/account_preferences/AccountPreferencesCard.dart';

class AccountPreferencesPage extends StatefulWidget {
  AccountPreferencesPage();

  @override
  _AccountPreferencesPageState createState() => _AccountPreferencesPageState();
}

class _AccountPreferencesPageState extends State<AccountPreferencesPage> {
  PreferencesBloc preferencesBloc = PreferencesBloc();
  List<GridTile> gridTilesList = [];
  bool flagRequestSubmitted = false;
  List<Category> userCategories;
  User user;
  Future<List<Category>> futureCategories;
  List<int> selectedCategoriesIds;
  List<Category> selectedCategories = [];

  @override
  void initState() {
    preferencesBloc.getPreferencesData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _screenHeight = MediaQuery.of(context).size.height - kToolbarHeight;
    var _screenWidth = MediaQuery.of(context).size.width;

    Widget _loader = Container(
        color: Theme.of(context).dialogBackgroundColor,
        child: Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.white,
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ));

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

//Category
    Widget getImageWidget(Category category) {
      return GestureDetector(
        onTap: () => {
          /* if (!category.isSelected) {selectedCategories.add(category)},
          setState(() {
            category.isSelected = !category.isSelected;
          })*/
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
                        color: Colors.black,
                        size: 35,
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
        crossAxisCount: 1,
        childAspectRatio: 1,
        mainAxisSpacing: 10,
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        crossAxisSpacing: 10,
        shrinkWrap: true,
        children: gridTilesList,
      );
    }

    Widget _categories(List<Category> categories) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        height: _screenHeight * 0.33,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("ESTILO",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 17,
                        color: Theme.of(context).textTheme.bodyText2.color,
                        fontWeight: FontWeight.w600)),
                Text(
                  "Editar Estilos",
                  style: TextStyle(color: Colors.red),
                )
                //TODO Editar estilos
              ],
            ),
            SizedBox(
              height: 5,
            ),
            categories.length > 0
                ? Expanded(
                    child: showCategories(categories),
                  )
                : Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.report,
                          color: Theme.of(context).textTheme.bodyText1.color,
                        ),
                        Text("No ha agregado ningún estilo")
                      ],
                    ),
                  )
          ],
        ),
      );
    }

//SubCategories
    _showSubcategoriesTags(List<Subcategory> subcategories) {
      subcategories = subcategories.where((i) => !i.isSelected).toList();
      return Tags(
        alignment: WrapAlignment.start,
        itemCount: subcategories.length,
        itemBuilder: (int index) {
          final subcategory = subcategories[index];
          return ItemTags(
            index: index,
            // required
            title: subcategory.name,
            active: true,
            combine: ItemTagsCombine.withTextBefore,
            icon: ItemTagsIcon(
              icon: Icons.add,
            ),
            activeColor: Colors.black,
            color: Colors.white,
          );
        },
      );
    }

    Widget _subcategories(List<Subcategory> subcategories) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        height: _screenHeight * 0.15,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("INTERESES",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 17,
                        color: Theme.of(context).textTheme.bodyText2.color,
                        fontWeight: FontWeight.w600)),
                Text(
                  "Editar Intereses",
                  style: TextStyle(color: Colors.red),
                )
                //TODO Editar estilos
              ],
            ),
            SizedBox(
              height: 5,
            ),
            subcategories.length > 0
                ? Container(
                    child: _showSubcategoriesTags(subcategories),
                  )
                : Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.report,
                            color: Theme.of(context).textTheme.bodyText1.color),
                        Text("No ha agregado ningún interes")
                      ],
                    ),
                  )
          ],
        ),
      );
    }

//TypePlaces
    Widget getImageWidgetForTypePlace(url, name, id) {
      return GestureDetector(
        onTap: () => {},
        child: Container(
          margin: EdgeInsets.all(2),
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          width: double.infinity,
          height: 275,
          child: Stack(
            children: <Widget>[
              Image.network(
                url,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
              ),
              /*style.isSelected ? Positioned(
                top: 0, right: 0, bottom: 0, left: 0, //give the values according to your requirement
                child: Icon(Icons.favorite, color: Colors.white, size: 35,)
              //IconButton(icon: Icon(Icons.delete_forever, color: Colors.redAccent,), onPressed: () {  },),
            ) : Text(""),*/
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
              Positioned(
                  bottom: 15,
                  left: 15,
                  //give the values according to your requirement
                  child: textWithStroke(text: name, fontSize: 24)
                  //IconButton(icon: Icon(Icons.delete_forever, color: Colors.redAccent,), onPressed: () {  },),
                  ),
            ],
          ),
        ),
      );
    }

    List<Widget> _buildPicsTypePlaces(
        BuildContext context, List<TypePlace> typePlaces) {
      return typePlaces.map((item) {
        return getImageWidgetForTypePlace(item.icon, item.name, item.id);
      }).toList();
    }

    Widget _typeplaces(List<TypePlace> typeplaces) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        height: _screenHeight * 0.38,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("MODO DE VIAJE",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 17,
                        color: Theme.of(context).textTheme.bodyText2.color,
                        fontWeight: FontWeight.w600)),
                Text(
                  "Editar Modo",
                  style: TextStyle(color: Colors.red),
                )
                //TODO Editar estilos
              ],
            ),
            SizedBox(
              height: 5,
            ),
            typeplaces.length > 0
                ? Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: _buildPicsTypePlaces(context, typeplaces),
                    ),
                  )
                : Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.report,
                            color: Theme.of(context).textTheme.bodyText1.color),
                        Text("No ha agregado ningún modo de viaje")
                      ],
                    ),
                  )
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("PREFERENCIAS",
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText1.color)),
        elevation: 0,
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        iconTheme:
            IconThemeData(color: Theme.of(context).textTheme.bodyText1.color),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Container(
          color: Theme.of(context).dialogBackgroundColor,
          child: StreamBuilder(
            stream: preferencesBloc.preferencesStream,
            builder: (ctx, snapshot) {
              var preferences = snapshot.data as Preferences;
              if (snapshot.hasData) {
                return Column(
                  children: [
                    _categories(preferences.categories),
                    _subcategories(preferences.subcategories),
                    _typeplaces(preferences.typeplaces)
                  ],
                );
              } else {
                return Container(
                  width: _screenWidth,
                  height: _screenHeight,
                  child: _loader,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
