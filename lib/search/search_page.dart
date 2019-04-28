import 'package:flutter/material.dart';
import 'package:my_mini_app/util/const_util.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(child: AppBar(
        title: Text("搜索"),
        centerTitle: true,
      ), preferredSize: Size.fromHeight(APPBAR_HEIGHT)),
      body: new _SearchPage(),
    );
  }
}

class _SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _SearchState();
  }
}

class _SearchState extends State<_SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("ningyuwen"),
    );
  }
}
