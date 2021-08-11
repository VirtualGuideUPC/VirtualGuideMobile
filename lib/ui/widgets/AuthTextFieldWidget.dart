import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final String placeholder;
  final bool obscureText;
  final Function onChanged;
  final Function onTap;
  final String errorText;
  final TextEditingController controller;

  AuthTextField(
      {@required this.label,
      @required this.placeholder,
      this.onChanged,
      this.onTap,
      this.obscureText = false,
      this.errorText,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        '$label',
        style: TextStyle(fontSize: 18.0, color: Color.fromRGBO(0, 0, 0, 0.6)),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 5.0),
      TextField(
        controller: controller,
        obscureText: obscureText,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: '$placeholder',
            errorText: this.errorText),
        onChanged: onChanged,
        onTap: onTap,
      ),
    ]);
  }
}
