import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_mini_app/been/login_been.dart';
import 'package:my_mini_app/home/consume_page.dart';
import 'package:my_mini_app/login/login.dart';
import 'package:my_mini_app/mine/my_collection_page.dart';
import 'package:my_mini_app/mine/my_user_friend_page.dart';
import 'package:my_mini_app/mine/setting_page.dart';
import 'package:my_mini_app/provider/auth_provider.dart';

class NewMineFragment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewMineState();
  }
}

class _NewMineState extends State<NewMineFragment> {
  Stream<LoginBeen> _stream;

  @override
  void initState() {
    _stream = AuthProvider().stream();
    super.initState();
  }

  @override
  void didUpdateWidget(NewMineFragment oldWidget) {
//    print("didUpdateWidget() ${oldWidget.hashCode}");
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: this._stream,
        builder: (context, AsyncSnapshot<LoginBeen> snapshot) {
//          print("登录了 ${snapshot.data.headUrl}");
          if (snapshot.hasData) {
            if (snapshot.data.isLogin) {
              return _loginWidget(snapshot.data);
            } else {
              return _notLoginWidget();
            }
          } else {
            return Center(
              child: const CupertinoActivityIndicator(),
            );
          }
        });
  }

  Widget _notLoginWidget() {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: new Container(
            padding: new EdgeInsets.all(8.0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 150.0,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  Image.asset(
                    "image/user_head.png",
                    width: 60.0,
                    height: 60.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
                    child: OutlineButton(
                        child: Text(
                          "请点击登录",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new LoginPage()),
                          );
                        }),
                  ),
                ],
              ),
            )));
  }

  Widget _loginWidget(LoginBeen loginBeen) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: new Container(
          padding: new EdgeInsets.only(top: 8.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 150.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _userInfo(loginBeen),
              _myAttentionUsers(),
              Divider(
                height: 0.0,
              ),
              _minePublishWidget(),
              Divider(
                height: 0.0,
              ),
              _mineCollectionWidget(),
              Divider(
                height: 0.0,
              ),
              _changeTheme(),
              Divider(
                height: 0.0,
              ),
              _settingWidget(),
              Divider(
                height: 0.0,
              ),
            ],
          ),
        ));
  }

  Widget _userInfo(LoginBeen loginBeen) {
    if (loginBeen.isLogin) {
      return SizedBox(
        height: 120.0,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ClipOval(
                clipBehavior: Clip.hardEdge,
                child: CachedNetworkImage(
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  imageUrl: loginBeen.headUrl,
                ),
              ),
              Text(
                "${loginBeen.username}",
                style: TextStyle(fontSize: 16.0),
              ),
              Divider(
                height: 0.0,
              )
            ],
          ),
        ),
      );
    } else {
      return Center(
        child: CupertinoActivityIndicator(),
      );
    }
  }

  //我关注的人
  Widget _myAttentionUsers() {
    return InkWell(
      child: Container(
          height: 54.0,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: <Widget>[
              const SizedBox(
                width: 20.0,
              ),
              Icon(
                Icons.tag_faces,
                color: Colors.amber,
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: const Text(
                  "我关注的人",
                  style: TextStyle(fontSize: 18.0),
                ),
              )
            ],
          )),
      onTap: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new MyUserFriendPage()));
      },
    );
  }

  Widget _settingWidget() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new SettingPage()));
      },
      child: Container(
          height: 54.0,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: <Widget>[
              const SizedBox(
                width: 20.0,
              ),
              Icon(
                Icons.settings,
                color: Colors.green,
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: const Text(
                  "设置",
                  style: TextStyle(fontSize: 18.0),
                ),
              )
            ],
          )),
    );
  }

  Widget _minePublishWidget() {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new ConsumePage(-1)));
      },
      child: Container(
          height: 54.0,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: <Widget>[
              const SizedBox(
                width: 20.0,
              ),
              Icon(
                Icons.supervised_user_circle,
                color: Colors.purple,
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: const Text(
                  "我发布的",
                  style: TextStyle(fontSize: 18.0),
                ),
              )
            ],
          )),
    );
  }

  Widget _changeTheme() {
    return InkWell(
      onTap: () {
        print("点了换肤");
        changeBrightness();
//        showDialog(
//            context: context,
//            builder: (BuildContext context) {
//              return BrightnessSwitcherDialog();
//            });
      },
      child: Container(
          height: 54.0,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: <Widget>[
              const SizedBox(
                width: 20.0,
              ),
              Icon(
                Icons.brightness_6,
                color: Colors.blue,
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Text(
                  _getSkinName(),
                  style: TextStyle(fontSize: 18.0),
                ),
              )
            ],
          )),
    );
  }

  void changeBrightness() {
    print("brightness is: ${Theme.of(context).brightness}");
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light);
  }

  void changeColor() {
    DynamicTheme.of(context).setThemeData(new ThemeData(
        primaryColor: Theme.of(context).primaryColor == Colors.indigo
            ? Colors.red
            : Colors.indigo));
  }

  String _getSkinName() {
    return Theme.of(context).brightness == Brightness.dark ? "日间模式" : "夜间模式";
  }

  Widget _mineCollectionWidget() {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new MyCollectionPage()));
      },
      child: Container(
          height: 54.0,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: <Widget>[
              const SizedBox(
                width: 20.0,
              ),
              Icon(
                Icons.collections,
                color: Colors.red,
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: const Text(
                  "我收藏的",
                  style: TextStyle(fontSize: 18.0),
                ),
              )
            ],
          )),
    );
  }
}
