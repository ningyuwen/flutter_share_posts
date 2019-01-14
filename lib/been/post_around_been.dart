import 'package:decimal/decimal.dart';

class Post{
  String username = "";
  String head_url = "";
  int distance;
  int id;
  int userId;
  String content = "";
  String imgUrl = "";
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

  Post({
    this.username,this.head_url,this.distance,this.id,this.userId,
    this.content,this.imgUrl,this.position,this.longitude,this.latitude,
    this.store,this.imgLabel,this.releaseTime,this.cost,this.votes,
    this.comments,this.district,this.isVote
  });

  static Post fromJson(Map<String,dynamic> json){
    return Post(
      username: json['username'],
      head_url: json['head_url'],
      distance: json['distance'],
      id: json['id'],
      userId: json['userId'],
      content: json['content'],
      imgUrl: json['imgUrl'],
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
        isVote: json['isVote']
    );
  }

  Map<String, dynamic> toJson() => {
    'username': username,
    'head_url': head_url,
    'distance': distance,
    'id': id,
    'userId': userId,
    'content': content,
    'imgUrl': imgUrl,
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
  };
}