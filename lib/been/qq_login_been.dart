import 'dart:convert';

class QQLoginBeen {

  var openid;
  var access_token;


  QQLoginBeen(this.openid, this.access_token);

  QQLoginBeen.fromJson(Map<String, dynamic> json)
      : openid = json['openid'],
        access_token = json['access_token'];

  Map<String, dynamic> toJson() =>
      {
        'openid': openid,
        'access_token': access_token
      };

}