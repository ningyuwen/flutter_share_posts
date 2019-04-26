import 'package:flutter/material.dart';
import 'package:my_mini_app/home/fragment_friend_page.dart';
import 'package:my_mini_app/home/fragment_around_page.dart';
import 'package:my_mini_app/home/new_mine_fragment.dart';

//好友fragment
class FragmentFriend extends StatelessWidget {
  static FragmentFriend _instance;

  factory FragmentFriend() => _getInstance();

  static FragmentFriend get instance => _getInstance();

  FragmentFriend._internal() {
    // 初始化
//    createState();
  }

  static FragmentFriend _getInstance() {
    if (_instance == null) {
      _instance = new FragmentFriend._internal();
    }
    return _instance;
  }

  @override
  Widget build(BuildContext context) {
    return FragmentFriendPage();
  }
}

//附近的人fragment
class FragmentAround extends StatelessWidget {
  static FragmentAround _instance;

  factory FragmentAround() => _getInstance();

  static FragmentAround get instance => _getInstance();

  FragmentAround._internal() {
    // 初始化
//    createState();
  }

  static FragmentAround _getInstance() {
    if (_instance == null) {
      _instance = new FragmentAround._internal();
    }
    return _instance;
  }

  @override
  Widget build(BuildContext context) {
    return FragmentAroundPage();
  }
}

//好友fragment
class FragmentMine extends StatelessWidget {
  static FragmentMine _instance;

  factory FragmentMine() => _getInstance();

  static FragmentMine get instance => _getInstance();

  FragmentMine._internal() {
    // 初始化
//    createState();
  }

  static FragmentMine _getInstance() {
    if (_instance == null) {
      _instance = new FragmentMine._internal();
    }
    return _instance;
  }

  @override
  Widget build(BuildContext context) {
//    return FragmentMineWidget();
    return NewMineFragment();
  }
}
