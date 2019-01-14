import 'package:my_mini_app/been/detail_comment.dart';

class PostDetail{
  int id;
  int userId;
  String username;
  String headUrl;
  String content;
  String contentUrl;
  String location;
  double longitude;
  double latitude;
  String store;
  String imgLabel;
  String releaseTime;
  double cost;
  int votes;
  int comments;
  String district;
  String distance;
  bool isVote;
  List<DetailComment> mCommentList;

  PostDetail({
    this.id = 0,
    this.userId = 0,
    this.username = "aduning",
    this.headUrl = "",
    this.content = "",
    this.contentUrl = "",
    this.location = "",
    this.longitude,this.latitude,
    this.store = "",
    this.imgLabel = "",
    this.releaseTime = "",
    this.cost = 0.0,
    this.votes = 0,
    this.comments = 0,
    this.district = "",
    this.distance = "",
    this.isVote = false,
    this.mCommentList,
  });

  static PostDetail fromJson(Map<String,dynamic> json){
    List<DetailComment> detailComments = new List();
    for(var value in json['mCommentList']) {
      detailComments.add(DetailComment.fromJson(value));
    }
    return PostDetail(
      id: json['id'],
      userId: json['userId'],
      username: json['username'],
      headUrl: json['headUrl'],
      content: json['content'],
      contentUrl: json['contentUrl'],
      location: json['location'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      store: json['store'],
      imgLabel: json['imgLabel'],
      releaseTime: json['releaseTime'],
      cost: json['cost'],
      votes: json['votes'],
      comments: json['comments'],
      district: json['district'],
      distance: json['distance'],
      isVote: json['isVote'],
      mCommentList: detailComments
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'username': username,
    'headUrl': headUrl,
    'content': content,
    'contentUrl': contentUrl,
    'location': location,
    'longitude': longitude,
    'latitude': latitude,
    'store': store,
    'imgLabel': imgLabel,
    'releaseTime': releaseTime,
    'cost': cost,
    'votes': votes,
    'comments': comments,
    'district': district,
    'distance': distance,
    'isVote': isVote,
    'mCommentList': mCommentList,
  };
}