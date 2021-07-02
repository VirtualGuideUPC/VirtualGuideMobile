import 'package:flutter/material.dart';
import 'package:tour_guide/data/entities/experience.dart';
import 'package:tour_guide/ui/widgets/FlipCardWidget.dart';

class DropdownSheet extends StatelessWidget {

  final List<Experience> experiences;
  final String title;
  DropdownSheet({@required this.experiences,@required this.title,Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                color: Color.fromRGBO(79, 77, 140, 1),
              ),
              height: MediaQuery.of(context).size.height - 100.0,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                    Container(
                    width: double.infinity,
                    height: 20,
                    child: Center(
                      child: Container(
                        width: 100,
                        height: 3,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    width:double.infinity,
                    height:30,
                    child:Center(
                      child:Text(title,style: TextStyle(color: Colors.white,fontSize: 15, fontWeight: FontWeight.bold))
                    )
                  ),
                  SizedBox(height:10),
                  Flexible(
                    child:GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20.0,

                    children: _buildExperiences(context)
                  ),
                  )
                ],
              ));
  }
  List<Widget> _buildExperiences(context){
    return experiences.map((item){
      return FlipCard(
        experience:item,
        horizontalPadding: 10,
        onTap: (){
          Navigator.pushNamed(context, 'experience-detail', arguments: item );
        },
      );
    }).toList();
  }
}