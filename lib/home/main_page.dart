import 'package:amap_location/amap_location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_mini_app/been/consume_post_been.dart';
import 'package:my_mini_app/provider/auth_provider.dart';
import 'package:my_mini_app/provider/db_provider.dart';
import 'package:my_mini_app/provider/return_top_provider.dart';
import 'package:my_mini_app/publish/publish_post.dart';
import 'package:my_mini_app/search/search.dart';
import 'package:my_mini_app/search/search_page.dart';
import 'package:my_mini_app/util/basic_config.dart';
import 'package:my_mini_app/util/const_util.dart';
import 'package:permission_handler/permission_handler.dart';

import 'fragment_main_router.dart';

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
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permission != PermissionStatus.granted) {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.storage]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            child: AppBar(
              title: Container(
                width: MediaQuery.of(context).size.width,
                child: GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Text(
                      "Q晒单",
                    ),
                  ),
                  onDoubleTap: () {
                    ReturnTopProvider().addEvent(_currentIndex);
                  },
                ),
              ),
              titleSpacing: 0.0,
              automaticallyImplyLeading: false,
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Theme.of(context).primaryColor,
                  ),
                  tooltip: '搜索',
                  onPressed: () {
                    //跳转发布页面
                    showSearchMine(
                        context: context, delegate: SearchBarDelegate(context));
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).primaryColor,
                  ),
                  tooltip: '发布',
                  onPressed: () {
                    //跳转发布页面
                    _jumpToPublishPage(); //测试时不允许使用发布接口
                  },
                )
              ],
            ),
            preferredSize: Size.fromHeight(APPBAR_HEIGHT)),
        body: _showBodyWidget(),
        bottomNavigationBar: Container(
            height: APPBAR_HEIGHT,
            decoration: BoxDecoration(
                border: Border(
              top: BorderSide(color: Colors.black38, width: 0.0),
            )),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _itemBottomBar(Icons.home, "附近", 0),
                _itemBottomBar(Icons.tag_faces, "关注", 1),
                _itemBottomBar(Icons.assignment_ind, "我的", 2),
              ],
            )));
  }

  Widget _itemBottomBar(IconData icon, String text, int index) {
    return Flexible(
      flex: 1,
      child: InkWell(
        child: LayoutBuilder(builder: (context, constraint) {
//          return IconButton(
//            icon: Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//              mainAxisSize: MainAxisSize.min,
//              children: <Widget>[
//                Icon(
//                  icon,
//                  color: _currentIndex == index ? Colors.blue : Colors.grey,
//                  size: 24.0,
//                ),
//                Text(
//                    text,
//                    style: TextStyle(
//                        color: Theme.of(context).textTheme.button.color,
//                        fontSize: 12.0))
//              ],
//            ),
//            onPressed: () {
//
//            },
//          );

          return Container(
            height: constraint.biggest.height,
            width: 350,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  icon,
                  color: _currentIndex == index ? Colors.blue : Colors.grey,
                  size: 24.0,
                ),
                Text(
                    text,
                    style: TextStyle(
                        color: _currentIndex == index ? Colors.blue : Theme.of(context).textTheme.button.color,
                        fontSize: 12.0))
              ],
            ),
          );
        }),
        onTap: () {
          if (_currentIndex != index) {
            setState(() {
              _currentIndex = index;
            });
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    AMapLocationClient.shutdown();
    AuthProvider().dispose();
    ReturnTopProvider().dispose();
    DBProvider.db.close();
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

  @override
  bool get wantKeepAlive => true;
}
