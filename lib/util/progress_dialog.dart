
import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      width: 70.0,
      child: CircularProgressIndicator(),
    );
  }
}