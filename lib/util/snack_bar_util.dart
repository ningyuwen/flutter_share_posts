import 'package:flutter/material.dart';

class SnackBarUtil {
  static show(BuildContext context, String content) {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(content, style: Theme.of(context).textTheme.body2),
      backgroundColor: Theme.of(context).backgroundColor,
      duration: Duration(milliseconds: 500),
    ));
  }
}
