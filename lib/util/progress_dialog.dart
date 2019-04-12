import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProgressDialog {
  static void showProgressDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (context) {
          return SpinKitCircle(
            color: Theme.of(context).accentColor,
          );
        });
  }
}
