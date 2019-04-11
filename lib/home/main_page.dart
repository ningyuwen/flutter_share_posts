import 'package:amap_location/amap_location.dart';
import 'package:flutter/material.dart';
import 'package:my_mini_app/been/mine_post_been.dart';
import 'package:my_mini_app/provider/auth_provider.dart';
import 'package:my_mini_app/publish/publish_post.dart';
import 'package:my_mini_app/util/basic_config.dart';
import 'package:my_mini_app/util/toast_util.dart';
import 'package:simple_permissions/simple_permissions.dart';

import 'fragment_friend.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BasicConfig.instance.setContext(context);
    return MainPageView();
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
  final int type; //控制显示类型，附近的人、好友、我的
}

//const List<Choice> choices = const <Choice>[
//  const Choice(title: '附近的人', icon: Icons.directions_car, type: 1),
//  const Choice(title: '关注', icon: Icons.directions_bike, type: 2),
//  const Choice(title: '我的', icon: Icons.directions_boat, type: 3),
//];

class MainTabBarItemView extends StatelessWidget {
  const MainTabBarItemView({Key key, this.choice}) : super(key: key);
  final Choice choice;

  @override
  Widget build(BuildContext context) {
    switch (choice.type) {
      case 1:
        return FragmentAround();
      case 2:
        return FragmentFriend();
      case 3:
        return FragmentMine();
      default:
        break;
    }
  }
}

class _MainPageState extends State<MainPageView>
    with AutomaticKeepAliveClientMixin {
  int _currentIndex = 0;
  FragmentAround _fragmentAround;
  FragmentFriend _fragmentFriend;
  FragmentMine _fragmentMine;
  List<Widget> _screens = [];

  @override
  void initState() {
    print("_MainPageState initState() 了了了");
    _fragmentAround = new FragmentAround();
    _fragmentFriend = new FragmentFriend();
    _fragmentMine = new FragmentMine();
    _screens.add(_fragmentAround);
    _screens.add(_fragmentFriend);
    _screens.add(_fragmentMine);
    _getFileWritePermission();
    super.initState();
  }

  void _getFileWritePermission() async {
    bool hasPermission = await SimplePermissions.checkPermission(
        Permission.WriteExternalStorage);
    if (!hasPermission) {
      PermissionStatus status = await SimplePermissions.requestPermission(
          Permission.WriteExternalStorage);
      if (status == PermissionStatus.authorized) {
//        ToastUtil.showToast("您打开了位置权限");
      } else {
//        ToastUtil.showToast("您关闭了位置权限");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Q晒单",
//          style: TextStyle(fontSize: 18.0, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 51, 51, 51),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Padding(
              padding: EdgeInsets.all(6.0),
              child: Image.asset("image/iv_main_add.png"),
            ),
            tooltip: '发布',
            onPressed: () {
              //跳转发布页面
              _jumpToPublishPage();
            },
          )
        ],
      ),
      body: _showBodyWidget(),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color.fromARGB(255, 51, 51, 51),
          items: [
            BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(Icons.home,
                    color: _currentIndex == 0 ? Colors.blue : Colors.white),
                title: new Text("附近",
                    style: new TextStyle(color: Colors.white, fontSize: 14.0))),
            BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(Icons.tag_faces,
                    color: _currentIndex == 1 ? Colors.blue : Colors.white),
                title: new Text("关注",
                    style: new TextStyle(color: Colors.white, fontSize: 14.0))),
            BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(
                  Icons.assignment_ind,
                  color: _currentIndex == 2 ? Colors.blue : Colors.white,
                ),
                title: new Text("我的",
                    style: new TextStyle(color: Colors.white, fontSize: 14.0))),
          ]),
    );
  }

  @override
  void dispose() {
    AMapLocationClient.shutdown();
    super.dispose();
  }

  void _jumpToPublishPage() async {
    if (AuthProvider().userInfo.isLogin) {
      _jump();
    } else {
      AuthProvider().showLoginDialog("发布点评需要您先登录，是否需要进行登录？");
    }
  }

  void _jump() async {
    Posts post = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => new PublishPostView()));
    if (post != null) {
      //更新我的页面
//      PublishMinePagesProvider().addPost(post);
    }
  }

  Widget _showBodyWidget() {
    return IndexedStack(
      index: _currentIndex,
      children: _screens,
    );
  }

  Widget _page(int index) {
    ToastUtil.showToast(context.widget.toString());
    switch (index) {
      case 0:
        return _fragmentAround;
      case 1:
        return _fragmentFriend;
      case 2:
        return _fragmentMine;
    }
    return _fragmentAround;
  }

  @override
  bool get wantKeepAlive => true;
}
