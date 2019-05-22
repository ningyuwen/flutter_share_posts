import 'package:flutter/material.dart';

class SnackBarUtil {
  static show(BuildContext context, String content, {SnackBarAction action, int milliseconds = 600}) {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(content,
          style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : Colors.white)),
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.black,
      duration: Duration(milliseconds: milliseconds),
      action: action,
    ));
  }
}
