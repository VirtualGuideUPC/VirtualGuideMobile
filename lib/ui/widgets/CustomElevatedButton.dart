import 'package:flutter/material.dart';

Widget customElevatedButton(String title, String icon, Function performFunction){
  return ElevatedButton(
    style: ButtonStyle(
        backgroundColor:
        MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(color: Colors.grey)))),
    onPressed: () {
      performFunction();
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(icon, height: 24, width: 24,),
        SizedBox(
          width: 10.0,
          height: 52.0,
        ),
        Text(title),
      ],
    ),
  );
}