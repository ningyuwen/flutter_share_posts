import 'package:flutter/material.dart';

class SnackBarUtil {

  static show(BuildContext context, String content) {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(content),

      duration: Duration(milliseconds: 500),
    ));

  }

}