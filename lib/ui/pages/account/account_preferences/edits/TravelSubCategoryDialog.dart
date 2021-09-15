import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:tour_guide/data/entities/subcategory.dart';
import 'package:tour_guide/data/providers/userProvider.dart';
import 'package:tour_guide/ui/bloc/preferencesBloc.dart';

class TravelSubCategoryDialog extends StatefulWidget {
  TravelSubCategoryDialog();

  @override
  _TravelSubCategoryDialogState createState() =>
      _TravelSubCategoryDialogState();
}

class _TravelSubCategoryDialogState extends State<TravelSubCategoryDialog> {
  var preferencesBloc = PreferencesBloc();

  validateSubCategories(
      List<Subcategory> userSubCategories, List<Subcategory> allSubCategories) {
    allSubCategories.forEach((subcat) {
      userSubCategories.forEach((usersubCat) {
        if (subcat.id == usersubCat.id || subcat.name == usersubCat.name) {
          subcat.isSelected = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var _deviceWidth = MediaQuery.of(context).size.width;
    var _deviceHeight = MediaQuery.of(context).size.height - kToolbarHeight;

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

    _showUserSubcategoriesTags(List<Subcategory> subcategories) {
      subcategories = subcategories.where((i) => !i.isSelected).toList();
      return Tags(
        verticalDirection: VerticalDirection.up,
        alignment: WrapAlignment.start,
        itemCount: subcategories.length,
        itemBuilder: (int index) {
          final subcategory = subcategories[index];
          return ItemTags(
            onPressed: (item) {
              List<Subcategory> test = [];
              preferencesBloc.changeSubCategory(test);
              subcategory.isSelected = false;
              preferencesBloc.updateSubCategory(subcategory);
            },
            index: index,
            // required
            icon: ItemTagsIcon(
              icon: Icons.close,
            ),
            pressEnabled: true,
            title: subcategory.name,
            active: true,
            combine: ItemTagsCombine.withTextBefore,
            activeColor: Colors.black,
            textColor: Colors.white,
            color: Colors.black,
          );
        },
      );
    }

    _showAllSubcategoriesTags(List<Subcategory> subcategories) {
      subcategories =
          subcategories.where((i) => i.isSelected == false).toList();
      return Tags(
        verticalDirection: VerticalDirection.up,
        alignment: WrapAlignment.start,
        itemCount: subcategories.length,
        itemBuilder: (int index) {
          final subcategory = subcategories[index];
          return ItemTags(
            onPressed: (item) {
              List<Subcategory> test = [];
              preferencesBloc.changeSubCategory(test);
              subcategory.isSelected = true;
              preferencesBloc.updateSubCategory(subcategory);
            },
            index: index,
            // required
            icon: ItemTagsIcon(
              icon: Icons.add,
            ),
            pressEnabled: true,
            title: subcategory.name,
            active: true,
            activeColor: Colors.black,
            textColor: Colors.white,
            color: Colors.black,
            combine: ItemTagsCombine.withTextBefore,
          );
        },
      );
    }

    return Dialog(
      insetPadding: EdgeInsets.all(10),
      child: Container(
        height: _deviceHeight * 0.9,
        width: _deviceWidth,
        child: FutureBuilder(
          future: UserProvider().getAllSubcategories(),
          builder: (ctx, snapshot) {
            var allSubCategories = snapshot.data;
            preferencesBloc.getSubCategoriesData();
            if (snapshot.hasData) {
              return StreamBuilder(
                  stream: preferencesBloc.subCategoryControllerStream,
                  builder: (ctx, snapshot2) {
                    if (snapshot2.hasData) {
                      var userSubcategories = snapshot2.data as List;

                      validateSubCategories(
                          userSubcategories, allSubCategories);

                      return Container(
                        padding: EdgeInsets.all(10),
                        child: userSubcategories.length > 0
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Elija sus subcategorías"),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(5),
                                    height: _deviceHeight * 0.15,
                                    child: SingleChildScrollView(
                                      child: _showUserSubcategoriesTags(
                                          userSubcategories),
                                    ),
                                  ),
                                  Container(
                                    height: _deviceHeight * 0.65,
                                    padding: EdgeInsets.all(10),
                                    child: SingleChildScrollView(
                                      child: _showAllSubcategoriesTags(
                                          allSubCategories),
                                    ),
                                  ),
                                ],
                              )
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
      ),
    );
  }
}
