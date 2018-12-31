import 'package:flutter/material.dart';
import 'fragment_friend.dart';
import 'fragment_mine.dart';
import 'package:my_mini_app/publish/publish_post.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: choices.length,
        initialIndex: 1,
        child: MainPageView()
    );
  }
}

class MainPageView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class Choice {
  const Choice({this.title, this.icon, this.type});

  final String title;
  final IconData icon;
  final int type;       //控制显示类型，附近的人、好友、我的
}

const List<Choice> choices = const <Choice>[
  const Choice(title: '附近的人', icon: Icons.directions_car, type: 1),
  const Choice(title: '好友', icon: Icons.directions_bike, type: 2),
//  const Choice(title: '我的', icon: Icons.directions_boat, type: 3),
];

class MainTabBarItemView extends StatelessWidget {

  const MainTabBarItemView({Key key, this.choice}) : super(key: key);
  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    switch (choice.type) {
      case 1:
//        return FragmentAround.instance;
        return FragmentAround();
      case 2:
//        return FragmentFriend.instance;
        return FragmentFriend();
      case 3:
        return FragmentMine();
      default:
        break;
    }
  }
}

class _MainPageState extends State<MainPageView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Q晒单"),
        bottom: TabBar(
          isScrollable: true,
          indicatorColor: Colors.blue,
          tabs: choices.map((Choice choice) {
            return Tab(
              text: choice.title,
            );
          }).toList(),
        ),
        backgroundColor: Color.fromARGB(255, 51, 51, 51),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Padding(
              padding: EdgeInsets.all(6.0),
              child: Image.asset("image/iv_main_add.png"),
            ),
            tooltip: 'Add Alarm',
            onPressed: () {
              //跳转发布页面
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => new PublishPostView())
              );
            },
          )
        ],
      ),
      body: TabBarView(
        children: choices.map((Choice choice) {
          return MainTabBarItemView(choice: choice);
        }).toList(),
      ),
    );
  }
}
