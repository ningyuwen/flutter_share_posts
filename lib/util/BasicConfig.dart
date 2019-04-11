import 'package:flutter/material.dart';

class BasicConfig {
  BuildContext _context;

  static final BasicConfig instance = new BasicConfig._internal();

  BasicConfig._internal();

  BuildContext getContext() {
    return _context;
  }

  void setContext(BuildContext context) {
    _context = context;
  }
}
