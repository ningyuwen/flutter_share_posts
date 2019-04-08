import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_mini_app/been/login_been.dart';
import 'package:my_mini_app/home/fragment_mine.dart';
import 'package:my_mini_app/login/login.dart';
import 'package:my_mini_app/mine/my_user_friend_page.dart';
import 'package:my_mini_app/mine/setting_page.dart';
import 'package:my_mini_app/provider/auth_provider.dart';
import 'package:my_mini_app/util/auth_util.dart';
import 'package:my_mini_app/util/snack_bar_util.dart';
import 'package:rxdart/rxdart.dart';

class NewMineFragment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewMineState();
  }
}

class _NewMineState extends State<NewMineFragment> {
  PublishSubject<bool> _fetcher;
  Future<LoginBeen> _loginFuture;

  @override
  void initState() {
    _fetcher = AuthProvider().getFetcher();
    _loginFuture = AuthUtil.getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _fetcher.stream,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data) {
              return _loginWidget();
            } else {
              return _notLoginWidget();
            }
          } else {
            return Center(
              child: CircularProgressIndicator(strokeWidth: 1.0),
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
                              color: Colors.blue),
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

  Widget _loginWidget() {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: new Container(
          padding: new EdgeInsets.all(8.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 150.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _userInfo(),
              _myAttentionUsers(),
              Divider(
                color: Colors.black26,
              ),
              _minePublishWidget(),
              Divider(color: Colors.black26),
              _settingWidget(),
              Divider(
                color: Colors.black26,
              ),
            ],
          ),
        ));
  }

  Widget _userInfo() {
    return StreamBuilder(
        stream: _loginFuture.asStream(),
        builder: (context, AsyncSnapshot<LoginBeen> snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
              height: 120.0,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ClipOval(
                      child: CachedNetworkImage(
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        imageUrl: snapshot.data.headUrl,
                      ),
                    ),
                    Text(
                      "${snapshot.data.username}",
                      style: TextStyle(fontSize: 16.0, color: Colors.black54),
                    ),
                    Divider(
                      height: 2.0,
                      color: Colors.black26,
                    )
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  //我关注的人
  Widget _myAttentionUsers() {
    return GestureDetector(
      onTap: () {
//        SnackBarUtil.show(context, "点击我关注的人");
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new MyUserFriendPage()));
      },
      child: Container(
          height: 40.0,
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
              Text(
                "我关注的人",
                style: TextStyle(fontSize: 18.0, color: Colors.black87),
              ),
            ],
          )),
    );
  }

  Widget _settingWidget() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new SettingPage()));
      },
      child: Container(
          height: 40.0,
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
              Text(
                "设置",
                style: TextStyle(fontSize: 18.0, color: Colors.black87),
              ),
            ],
          )),
    );
  }

  Widget _minePublishWidget() {
    return GestureDetector(
      onTap: () {
//        SnackBarUtil.show(context, "点击我发布的");
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new ConsumePage(-1)));
      },
      child: Container(
          height: 40.0,
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
              Text(
                "我发布的",
                style: TextStyle(fontSize: 18.0, color: Colors.black87),
              ),
            ],
          )),
    );
  }
}
