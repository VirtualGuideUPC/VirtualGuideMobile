import 'package:flutter/material.dart';
import 'package:tour_guide/data/entities/department.dart';
import 'package:tour_guide/data/providers/experienceProvider.dart';

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
    futureDepartments=ExperienceProvider().getFavoriteExperiencesDepartments();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme:IconThemeData(color:Colors.black26),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("FAVORITOS", style:TextStyle(color:Colors.black26))
      ),
      body:_buildContent(context)
    );
  }
  Widget _buildContent(BuildContext context){
    return FutureBuilder(
      future: futureDepartments,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData){
          return Container(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: ListView(
              children: _buildCards(context,snapshot.data)
            ),
          );
        }else if(snapshot.hasError){
          if(snapshot.error=='401'){
            Future.delayed(Duration.zero, () => Navigator.pushReplacementNamed(context, "login"));
          }else{
            Future.delayed(Duration.zero, () => Navigator.of(context).pop());
          }
          return Container();
        }else{
          return Center(child:CircularProgressIndicator());
        }
      },
    );
  }
  List<Widget> _buildCards(BuildContext context, List<Department>departments){
    final _screenSize=MediaQuery.of(context).size;
    return departments.map((item){
      return Container(
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color:Colors.black45),
              color:Colors.white
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height:_screenSize.width*0.4,
                  color:Colors.red,
                  child:Stack(
                  )
                ),
                Container(
                  padding:EdgeInsets.all(15),
                  child:Text(item.name,textAlign: TextAlign.left,)
                )
              ],
            ),
        );
    }).toList();
  }
}