

import 'package:rxdart/rxdart.dart';

class MyUserFriendsBeen {
  int userId;
  String userName;
  String headUrl;
  bool sex;
  bool isFriend = true;
  PublishSubject<bool> publishSubject = new PublishSubject<bool>();

  MyUserFriendsBeen({this.userId, this.userName, this.headUrl, this.sex, this.isFriend, this.publishSubject});

  MyUserFriendsBeen.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    headUrl = json['headUrl'];
    if (headUrl.isEmpty) {
      headUrl = "https://www.dpfile.com/ugc/user/anonymous.png";
    }
    sex = json['sex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['headUrl'] = this.headUrl;
    data['sex'] = this.sex;
    return data;
  }
}