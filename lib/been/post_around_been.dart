import 'dart:convert';

class Posts {
  String username = "";
  String head_url = "";
  int distance = 0;
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
        imageUrls.add(img["url"]); //我们自己服务器的图片
      }
    }
    bool isVote;
    if (json['isVote'] is bool) {
      isVote = json['isVote'];
    } else if (json['isVote'] is int){
      if (json['isVote'] == 1) {
        isVote = true;
      } else {
        isVote = false;
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
        isVote: isVote,
        meituanId: json['storeId_meituan']);
  }

  Map<String, dynamic> toJson() {
    List<String> list = new List();
    for (var img in imgUrls) {
      Map<String, String> mapUrl = new Map();
      if (meituanId.isNotEmpty) {
        img = img.replaceAll("@600w_480h", "");
      }
      mapUrl['url'] = img;
      list.add(jsonEncode(mapUrl));
    }
    Map<String, dynamic> map = new Map();
    map['username'] = username;
    map['head_url'] = head_url;
    distance = 0;
    map['distance'] = distance;
    map['id'] = id;
    map['userId'] = userId;
    map['content'] = content;
    map['imgUrl'] = list.toString();
    map['position'] = position;
    map['longitude'] = longitude;
    map['latitude'] = latitude;
    map['store'] = store;
    map['imgLabel'] = imgLabel;
    map['releaseTime'] = releaseTime;
    map['cost'] = cost;
    map['votes'] = votes;
    map['comments'] = comments;
    map['district'] = district;
    map['isVote'] = isVote;
    map['storeId_meituan'] = meituanId;
    return map;
  }
}
