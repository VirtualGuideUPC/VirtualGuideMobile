import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:tour_guide/data/entities/subcategory.dart';
import 'package:tour_guide/data/entities/user.dart';
import 'package:tour_guide/data/providers/userProvider.dart';
import 'package:tour_guide/ui/bloc/provider.dart';
import 'package:tour_guide/ui/bloc/signinBloc.dart';
import 'package:tour_guide/ui/helpers/utils.dart';
import 'package:tour_guide/ui/routes/routes.dart';

class TravelSubcategoryPage extends StatefulWidget {
  @override
  _TravelSubcategoryPageState createState() => _TravelSubcategoryPageState();
}

class _TravelSubcategoryPageState extends State<TravelSubcategoryPage> {

  User user;
  String headerText = "Intereses seleccionados:";
  Future<List<Subcategory>> futureSubcategories;
  List<Subcategory> selectedSubcategories = [];
  List<int> selectedSubcategoriesIds;
  bool flagRequestSubmitted = false;

  @override
  void initState() {
    super.initState();
    futureSubcategories = UserProvider().getAllSubcategories();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = ModalRoute
        .of(context)
        .settings
        .arguments;
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
              Utils.mainNavigator.currentState.pushReplacementNamed(routeLogin);
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            _buildContent(context),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0,right: 10, left: 10),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: BorderSide(color: Colors.grey)))),
                    onPressed: () {
                      selectedSubcategoriesIds = selectedSubcategories.map((e) => e.id).toList();
                      user.subcategories = selectedSubcategoriesIds;
                      _signin(bloc, context);
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
                ),
              ),
            ),
          ],
        )
    );
  }

  Widget _buildContent(BuildContext context) {
    return FutureBuilder(
      future: futureSubcategories,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Text( "Elige algunos intereses tuyos",
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center),
                Divider(height: 12, color: Colors.white,),
                Text( "Esto hará que tengas recomendaciones más acertadas de lugares turísticos",
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.center),
                Divider(color: Colors.white,),
                Container(
                  height: 108,
                  color: Colors.grey.shade300,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Text(headerText),
                        _showSubcategories(snapshot.data),
                      ],
                    ),
                  ),
                ),
                Divider(),
                Text(  "Intereses sugeridos",
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center),
                Divider(color: Colors.white,),
                _showSubcategoriesTags(snapshot.data)
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
          return Container();
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Container _showSubcategories(List<Subcategory> subcategories) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 30.0,
        child: new ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            if (subcategories != null)
              for (var subcategory in subcategories) if(subcategory.isSelected) uploadSubcategory(subcategory)
            else
              Text("") //CircularProgressIndicator()
          ],
        ));
  }

  GestureDetector uploadSubcategory(Subcategory subcategory) {
    return GestureDetector(
      onTap: ()  => updateSubcategorySelection(subcategory),
      child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: getSubcategoryWidget(subcategory)
      ),
    );
  }

  Widget getSubcategoryWidget(Subcategory subcategory) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(right: 12, left: 12),
        child: Row(
          children: [
            Text(subcategory.name,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            VerticalDivider(width: 6,),
            Icon(Icons.clear, color: Colors.white, size: 16,)
          ],
        ),
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(6)
      ),
    );
  }


  _showSubcategoriesTags(List<Subcategory> subcategories){

    subcategories = subcategories.where((i) => !i.isSelected).toList();
    return Tags(
      alignment: WrapAlignment.start,
      itemCount: subcategories.length,
      itemBuilder: (int index){
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
          onPressed: (item) => updateSubcategorySelection(subcategory),
          activeColor: Colors.black,
          color: Colors.white,
        );
      },
    );
  }

  _signin(SigninBloc bloc, BuildContext context) {
    if (flagRequestSubmitted) {
      return;
    }
    BuildContext alertContext;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          alertContext = context;
          return AlertDialog(
              backgroundColor: Colors.white,
              content: Center(
                child: CircularProgressIndicator(),
              ));
        });

    bloc
        .signin(
        user.name, user.lastName, user.email, "123456", user.birthday, "1", user.icon, user.typePlaces, user.categories, user.subcategories)
        .then((String result) {
      //if (alertContext != null) Navigator.of(alertContext).pop();
      Utils.mainNavigator.currentState
          .pushReplacementNamed(routeFinishRegister);
    }).catchError((error) {
      if (alertContext != null) Navigator.of(alertContext).pop();
      bloc.changeRequestResult(error.toString());
      flagRequestSubmitted = false;
    });

    flagRequestSubmitted = true;
  }

  updateSubcategorySelection(Subcategory subcategory){
    if (!subcategory.isSelected) {
      selectedSubcategories.add(subcategory);
    }
    setState(() {
      subcategory.isSelected = !subcategory.isSelected;
    });
   // selectedSubcategories.add(subcategory);
    // headerText = "Has escogido " + selectedSubcategories.length.toString() + " subcategorías";
  }

}
