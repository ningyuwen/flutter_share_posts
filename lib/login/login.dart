import 'package:flutter/material.dart';
import 'package:flutter_qq/flutter_qq.dart';
import 'package:mmkv_flutter/mmkv_flutter.dart';
import 'package:my_mini_app/been/login_been.dart';
import 'package:my_mini_app/provider/auth_provider.dart';
import 'package:my_mini_app/util/api_util.dart';
import 'package:my_mini_app/util/toast_util.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoginView();
  }
}

class LoginView extends StatefulWidget {
  final String name = "登录页面";

  @override
  _LoginState createState() {
    FlutterQq.registerQQ('1106940064');
    return _LoginState();
  }
}

class _LoginState extends State<LoginView> {
  
  @override
  void initState() {
    super.initState();
  }

  Future<Null> _handleLogin() async {
    try {
      var qqResult = await FlutterQq.login();
      if (qqResult.code == 0) {
        print("json data is: ${qqResult.response["accessToken"].toString()}");
        //发送openid到服务器
        var loginMap = await ApiUtil.getInstance().netFetch(
            "/user/login",
            RequestMethod.POST,
            {
              "access_token": qqResult.response["accessToken"],
              "openid": qqResult.response["openid"]
            },
            null);
        LoginBeen loginBeen = new LoginBeen.fromJson(loginMap);
        loginBeen.isLogin = true;
        AuthProvider().addLoginBeen(loginBeen);
        _saveDataToLocal(loginBeen);
        print('hello this is data: ${loginBeen.headUrl}');
        Navigator.pop(context);
      } else if (qqResult.code == 1) {
        ToastUtil.showToast("登录失败 ${qqResult.message}");
      }
    } catch (error) {
      print("flutter_plugin_qq_example:" + error.toString());
    }
  }

  void _saveDataToLocal(LoginBeen loginBeen) async {
    MmkvFlutter mmkv = await MmkvFlutter.getInstance(); //初始化mmkv
    await mmkv.setInt("userId", loginBeen.userId);
    await mmkv.setString("openid", loginBeen.openid);
    await mmkv.setString("username", loginBeen.username);
    await mmkv.setString("headUrl", loginBeen.headUrl);
    await mmkv.setBool("sex", loginBeen.sex);
    await mmkv.setBool("isLogin", true);
    print("saveDataToSharedPref savedata is success");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 51, 51, 52),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Image.asset(
                "image/ic_logo.png",
                width: 150.0,
                height: 150.0,
              ),
              SizedBox(
                height: 250.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 120.0,
                    height: 1.0,
                    color: Colors.white,
                  ),
                  //点击QQ图标登陆
                  GestureDetector(
                    onTap: () {
                      _handleLogin();
                    },
                    child: Image.asset(
                      "image/ic_qq.png",
                      width: 50.0,
                      height: 50.0,
                    ),
                  ),
                  Container(
                    width: 120.0,
                    height: 1.0,
                    color: Colors.white,
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "QQ号快捷登录",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ));
  }
}
