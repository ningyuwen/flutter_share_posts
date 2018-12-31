import 'package:flutter/material.dart';

class FragmentMine extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MineState();
  }
}

class MineState extends State<FragmentMine> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Text("ning");
  }

  @override
  bool get wantKeepAlive => true;
}
