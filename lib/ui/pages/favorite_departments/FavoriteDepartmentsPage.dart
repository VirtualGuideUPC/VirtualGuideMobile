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
    futureDepartments=ExperienceProvider().getFavoriteExperiencesDepartments();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme:IconThemeData(color:Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("FAVORITOS", style:TextStyle(color:Colors.black))
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
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: ListView(
              children: _buildCards(context,snapshot.data)
            ),
          );
        }else if(snapshot.hasError){
          if(snapshot.error=='401'){
            //TODO: handle session expired
            Future.delayed(Duration.zero, () => Utils.homeNavigator.currentState.pop());
          }else{
            Future.delayed(Duration.zero, () => Utils.homeNavigator.currentState.pop());
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
    final _imageGridWidth=_screenSize.width-50;
    final _imageGridHeight=_screenSize.width*0.4;

    return departments.map((item){
      return GestureDetector(
              onTap: (){
                Utils.homeNavigator.currentState.pushNamed(routeHomeFavoriteExperiencesPage, arguments: item);
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color:Colors.black45),
                  color:Colors.white
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: _imageGridWidth,
                          height:_imageGridHeight,
                          child: Stack(
                            children: [
                              Positioned(
                                width: _imageGridWidth*0.6,
                                height:_imageGridHeight,
                                child: Container(
                                  padding: EdgeInsets.only(right: 4),
                                                            child: FadeInImage(
                                    placeholder: AssetImage('assets/img/loading.gif'),
                                    image: Utils.getPosterImage(_getImgUrlFormDepartment(item.pictures,0)),
                                    fit:BoxFit.cover
                                  ),
                                ),
                              ),
                              Positioned(
                                width: _imageGridWidth*0.4,
                                height:_imageGridHeight*0.5,
                                top:0,
                                right:0,
                                child: FadeInImage(
                                  placeholder: AssetImage('assets/img/loading.gif'),
                                  image: Utils.getPosterImage(_getImgUrlFormDepartment(item.pictures,1)),
                                  fit:BoxFit.cover
                                ),
                              ),
                              Positioned(
                                width: _imageGridWidth*0.4,
                                height:_imageGridHeight*0.5,
                                bottom:0,
                                right:0,
                                child: Container(
                                    padding: EdgeInsets.only(top:4),
                                                            child: FadeInImage(
                                    placeholder: AssetImage('assets/img/loading.gif'),
                                    image: Utils.getPosterImage(_getImgUrlFormDepartment(item.pictures,2)),
                                    fit:BoxFit.cover
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding:EdgeInsets.all(20),
                          child:Text(item.name,style:TextStyle(fontSize:20))
                        )
                      ],
                  ),
                ),
          ),
      );
    }).toList();
  }
  String _getImgUrlFormDepartment(List<String>urls,int index){
    if(index<urls.length){
      return urls[index];
    }else{
      return '';
    }
  }
}