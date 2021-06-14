import 'package:flutter/material.dart';

class BigButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  BigButton({@required this.label, this.onPressed});
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      elevation: 0.0,
      primary: Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    );

    return ElevatedButton(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
          child: Text('$label',style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.9), fontSize: 18.0)),
        ),
        style: style,
        onPressed:onPressed        
        );
  }
}