import 'package:json_annotation/json_annotation.dart';


class LoginBeen {

  var openid;
  var username;
  var headUrl;
  var sex;

  LoginBeen.fromJson(Map<String, dynamic> json) :
        openid = json['openid'],
        username = json['username'],
        headUrl = json['headUrl'],
        sex = json['sex'];

  Map<String, dynamic> toJson() =>
      {
        'openid': openid,
        'username': username,
        'headUrl': headUrl,
        'sex': sex
      };

}