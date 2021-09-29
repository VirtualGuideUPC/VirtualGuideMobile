import 'package:flutter/material.dart';

class NotificationUtil {
  void showSnackbar(BuildContext context, String message, String type,
      SnackBarAction action) {
    Color background = Colors.white;
    if (type == "error") {
      background = Colors.red;
    }
    if (type == "success") {
      background = Colors.green.shade800;
    }

    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: background,
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      action: action,
      duration: Duration(milliseconds: 500),
    ));
  }
}
