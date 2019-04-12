import 'package:flutter/material.dart';
import 'package:mmkv_flutter/mmkv_flutter.dart';
import 'package:my_mini_app/been/login_been.dart';
import 'package:my_mini_app/login/login.dart';
import 'package:my_mini_app/util/basic_config.dart';
import 'package:rxdart/rxdart.dart';

class AuthProvider {
  AuthProvider._internal() {
    print("AuthProvider 已经创建了");
    _getUserInfo().asStream().listen((LoginBeen been) {
      print("AuthProvider 添加新的登录账户");
      addLoginBeen(been);
    });
  }

  factory AuthProvider() {
    return _instance;
  }

  static final AuthProvider _instance = new AuthProvider._internal();

  LoginBeen userInfo = new LoginBeen(0, 0, "", "", 0, false);

  final _fetcher = new PublishSubject<LoginBeen>();

  stream() => _fetcher.stream;

  PublishSubject<LoginBeen> getFetcher() {
    return _fetcher;
  }

  void addLoginBeen(LoginBeen loginBeen) {
    print("addLoginBeen() been is: ${loginBeen.isLogin}");
    userInfo = loginBeen;
    _fetcher.sink.add(userInfo);
  }

  void dispose() {
    if (!_fetcher.isClosed) {
      _fetcher.close();
    }
  }

  Future<LoginBeen> _getUserInfo() async {
    print("AuthUtil getUserInfo()");
    MmkvFlutter mmkv = await MmkvFlutter.getInstance(); //初始化mmkv
    int userId = await mmkv.getInt("userId");
    String openId = await mmkv.getString("openid");
    String userName = await mmkv.getString("username");
    String headUrl = await mmkv.getString("headUrl");
    bool sex = await mmkv.getBool("sex");
    bool isLogin = await mmkv.getBool("isLogin");
    return new LoginBeen(userId, openId, userName, headUrl, sex, isLogin);
  }

  void logout() async {
    MmkvFlutter mmkv = await MmkvFlutter.getInstance(); //初始化mmkv
    await mmkv.setBool("isLogin", false);
    userInfo.isLogin = false;
    _fetcher.sink.add(userInfo);
  }

  bool isLogin() {
    return userInfo.isLogin;
  }

  void showLoginDialog(String text) {
    showDialog(
        context: BasicConfig.instance.getContext(),
        builder: (BuildContext context) {
          return AlertDialog(content: new Text(text), actions: <Widget>[
            new FlatButton(
              child: new Text("取消"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("登录"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new LoginPage()));
              },
            )
          ]);
        });
  }
}
