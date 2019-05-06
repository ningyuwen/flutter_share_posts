import 'dart:convert';

class Posts {
  String username = "";
  String head_url = "";
  int distance;
  int id;
  int userId;
  String content = "";
  List<String> imgUrls = new List();
  String position = "";
  double longitude;
  double latitude;
  String store;
  String imgLabel;
  String releaseTime;
  double cost;
  int votes;
  int comments;
  String district;
  bool isVote;
  String meituanId;

  Posts(
      {this.username,
      this.head_url,
      this.distance,
      this.id,
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
      this.isVote,
      this.meituanId});

  static Posts fromJson(Map<String, dynamic> json) {
    List<String> imageUrls = new List();
    List list = jsonDecode(json['imgUrl'].toString());
    String meituanId = json['storeId_meituan'];
    for (var img in list) {
      if (meituanId != null) {
        imageUrls.add(img["url"] + "@600w_480h"); //美团获取的图片，480h是根据高度来获取对应大小的图片
      } else {
        imageUrls.add(img["url"]);  //我们自己服务器的图片
      }
    }
    return Posts(
        username: json['username'],
        head_url: json['head_url'],
        distance: json['distance'],
        id: json['id'],
        userId: json['userId'],
        content: json['content'],
        imgUrls: imageUrls,
        position: json['position'],
        longitude: json['longitude'],
        latitude: json['latitude'],
        store: json['store'],
        imgLabel: json['imgLabel'],
        releaseTime: json['releaseTime'],
        cost: json['cost'],
        votes: json['votes'],
        comments: json['comments'],
        district: json['district'],
        isVote: json['isVote'],
        meituanId: json['storeId_meituan']);
  }

  Map<String, dynamic> toJson() => {
        'username': username,
        'head_url': head_url,
        'distance': distance,
        'id': id,
        'userId': userId,
        'content': content,
        'imgUrl': imgUrls,
        'position': position,
        'longitude': longitude,
        'latitude': latitude,
        'store': store,
        'imgLabel': imgLabel,
        'releaseTime': releaseTime,
        'cost': cost,
        'votes': votes,
        'comments': comments,
        'district': district,
        'isVote': isVote,
        'storeId_meituan': meituanId,
      };
}
