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


////好友fragment
//class FragmentFriend extends StatelessWidget {
//  static FragmentFriend _instance;
//
//  factory FragmentFriend() => _getInstance();
//
//  static FragmentFriend get instance => _getInstance();
//
//  FragmentFriend._internal() {
//    // 初始化
////    createState();
//  }
//
//  static FragmentFriend _getInstance() {
//    if (_instance == null) {
//      _instance = new FragmentFriend._internal();
//    }
//    return _instance;
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return FragmentFriendAndAround();
//  }
//}