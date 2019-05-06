import 'dart:convert';

class ConsumePost {
  int userId;
  String username;
  String headUrl;
  double cost;
  List<Posts> posts;

  ConsumePost({this.userId, this.username, this.headUrl, this.cost, this.posts});

  ConsumePost.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    username = json['username'];
    headUrl = json['headUrl'];
    cost = json['cost'] == 0 ? 0.0 : json['cost'];
    if (json['posts'] != null) {
      posts = new List<Posts>();
      json['posts'].forEach((v) {
        posts.add(new Posts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['username'] = this.username;
    data['headUrl'] = this.headUrl;
    data['cost'] = this.cost;
    if (this.posts != null) {
      data['posts'] = this.posts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Posts {
  int id;
  int userId;
  String content;
  List<String> imgUrls = new List();
  String position;
  double longitude;
  double latitude;
  String store;
  String imgLabel;
  String releaseTime;
  double cost;
  int votes;
  int comments;
  String district;
  String meituanId;

  Posts(
      {this.id,
      this.userId,
      this.content,
      this.imgUrls,
      this.position,
      this.longitude,
      this.latitude,
      this.store,
      this.imgLabel,
      this.releaseTime,
      this.cost,
      this.votes,
      this.comments,
      this.district,
      this.meituanId});

  Posts.fromJson(Map<String, dynamic> json) {
    List<String> imageUrls = new List();
    List list = jsonDecode(json['imgUrl'].toString());
    String meituanId = json['storeId_meituan'];
    for (var img in list) {
      if (meituanId != null) {
        imageUrls.add(img["url"] + "@800w_640h"); //美团获取的图片，480h是根据高度来获取对应大小的图片
      } else {
        imageUrls.add(img["url"]);  //我们自己服务器的图片
      }
    }
    id = json['id'];
    userId = json['userId'];
    content = json['content'];
    imgUrls = imageUrls;
    position = json['position'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    store = json['store'];
    imgLabel = json['imgLabel'];
    releaseTime = json['releaseTime'];
    cost = json['cost'];
    votes = json['votes'];
    comments = json['comments'];
    district = json['district'];
    meituanId = json['storeId_meituan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['content'] = this.content;
    data['imgUrl'] = this.imgUrls;
    data['position'] = this.position;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['store'] = this.store;
    data['imgLabel'] = this.imgLabel;
    data['releaseTime'] = this.releaseTime;
    data['cost'] = this.cost;
    data['votes'] = this.votes;
    data['comments'] = this.comments;
    data['district'] = this.district;
    return data;
  }
}
