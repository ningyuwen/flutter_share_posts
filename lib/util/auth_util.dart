import 'package:mmkv_flutter/mmkv_flutter.dart';
import 'package:my_mini_app/been/login_been.dart';

class AuthUtil {
  static Future<bool> isLogin() async {
    MmkvFlutter mmkv = await MmkvFlutter.getInstance(); //初始化mmkv
    bool isLogin = await mmkv.getBool("isLogin");
    return isLogin;
  }

  static Future<LoginBeen> getUserInfo() async {
    print("AuthUtil getUserInfo()");
    MmkvFlutter mmkv = await MmkvFlutter.getInstance(); //初始化mmkv
    String openId = await mmkv.getString("openid");
    String userName = await mmkv.getString("username");
    String headUrl = await mmkv.getString("headUrl");
    bool sex = await mmkv.getBool("sex");
    return new LoginBeen(openId, userName, headUrl, sex);
  }

  static Future<void> logout() async {
    MmkvFlutter mmkv = await MmkvFlutter.getInstance(); //初始化mmkv
    await mmkv.setBool("isLogin", false);
  }
}
