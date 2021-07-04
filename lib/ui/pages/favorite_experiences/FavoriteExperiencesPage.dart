import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:tour_guide/data/entities/department.dart';
import 'package:tour_guide/data/entities/experience.dart';
import 'package:tour_guide/data/entities/experienceDetailed.dart';
import 'package:tour_guide/data/providers/experienceProvider.dart';
import 'package:tour_guide/main.dart';
import 'package:tour_guide/ui/helpers/utils.dart';
import 'package:tour_guide/ui/routes/routes.dart';

class FavoriteExperiences extends StatefulWidget {
  FavoriteExperiences({Key key}) : super(key: key);

  @override
  _FavoriteExperiencesState createState() => _FavoriteExperiencesState();
}

class _FavoriteExperiencesState extends State<FavoriteExperiences> {
  Future<List<Experience>> futureExperiences;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    final Department department = ModalRoute.of(context).settings.arguments;// error when trying to retrieve the argument passed to this widget from the initState method, thats why it is being done in this weird method
    futureExperiences=ExperienceProvider().getFavoriteExperiences(department.id.toString());
  }
  @override
  Widget build(BuildContext context) {
    final Department department = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme:IconThemeData(color:Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title:Text(department.name, style:TextStyle(color:Colors.black))
      ),
      body:_buildContent(context)
    );
  }
    Widget _buildContent(BuildContext context){
    return FutureBuilder(
      future: futureExperiences,
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
  List<Widget> _buildCards(BuildContext context, List<Experience> experiences){
    return experiences.map((item){
      return Container(
        margin:EdgeInsets.only(bottom:40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                _buildCarousel(context, item),
                Positioned(right:10,top:10,child:Icon(Icons.favorite))
              ],
            ),
            SizedBox(height:10),
            Row(children: _buildRatingBar(context, item)),
            SizedBox(height:10),
            Text(item.name,style:TextStyle(fontSize:20))
          ],
        ),
      );
    }
    ).toList();
  }
  Widget _buildCarousel(BuildContext context, Experience experienceDetails){
    final _screenSize=MediaQuery.of(context).size;
    return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
        width: double.infinity,
        height:_screenSize.width*0.5,
        child:Image(
          image:Utils.getPosterImage(experienceDetails.picture),
          fit: BoxFit.cover,
        )
      )
      // child:Carousel(
      //   borderRadius: true,
      //   radius: Radius.circular(20),
      //   images:experienceDetails.pictures.map(
      //     (item) => NetworkImage(item)
      //   ).toList()
      // )
    );
  }
  List<Widget> _buildRatingBar(BuildContext context, Experience experienceDetailed){
    int numFillStars=experienceDetailed.avgRanking.toInt();
    bool halfStart=experienceDetailed.avgRanking%1!=0;
    List<Widget> stars=[];
    for(int i=1;i<=5;i++){
      if(i<=numFillStars){
        stars.add(Icon(Icons.star_outlined));
      }else{
        if(halfStart){
          stars.add(Icon(Icons.star_half_outlined));
          halfStart=false;
        }
        else{ 
          stars.add(Icon(Icons.star_outline));
        }
      }
    }
    return stars;
  }

}