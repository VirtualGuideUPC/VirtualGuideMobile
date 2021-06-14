import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final String placeholder;
  final bool obscureText;
  final Function onChanged;
  final String errorText;
  AuthTextField({@required this.label,@required this.placeholder,this.onChanged,this.obscureText=false,this.errorText});
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        '$label',
        style: TextStyle(fontSize: 18.0, color: Color.fromRGBO(0, 0, 0, 0.6)),
      ),
      SizedBox(height: 5.0),
      TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 0,horizontal:10.0),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: '$placeholder',
            errorText: this.errorText
          ),
          onChanged: onChanged,
      ),
    ]);
  }
}
