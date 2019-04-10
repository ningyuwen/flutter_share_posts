import 'package:mmkv_flutter/mmkv_flutter.dart';
import 'package:my_mini_app/been/login_been.dart';

class AuthUtil {

  static LoginBeen userInfo;

  //在进入app时调用、在登陆成功时调用
  static Future<void> setUserInfo() async {
    print("AuthUtil getUserInfo()");
    MmkvFlutter mmkv = await MmkvFlutter.getInstance(); //初始化mmkv
    int userId = await mmkv.getInt("userId");
    String openId = await mmkv.getString("openid");
    String userName = await mmkv.getString("username");
    String headUrl = await mmkv.getString("headUrl");
    bool sex = await mmkv.getBool("sex");
    userInfo = new LoginBeen(userId, openId, userName, headUrl, sex);
  }

  static Future<bool> isLogin() async {
    MmkvFlutter mmkv = await MmkvFlutter.getInstance(); //初始化mmkv
    bool isLogin = await mmkv.getBool("isLogin");
    return isLogin;
  }

  static Future<LoginBeen> getUserInfo() async {
    print("AuthUtil getUserInfo()");
    MmkvFlutter mmkv = await MmkvFlutter.getInstance(); //初始化mmkv
    int userId = await mmkv.getInt("userId");
    String openId = await mmkv.getString("openid");
    String userName = await mmkv.getString("username");
    String headUrl = await mmkv.getString("headUrl");
    bool sex = await mmkv.getBool("sex");
    return new LoginBeen(userId, openId, userName, headUrl, sex);
  }

  static Future<void> logout() async {
    MmkvFlutter mmkv = await MmkvFlutter.getInstance(); //初始化mmkv
    await mmkv.setBool("isLogin", false);
  }
}
