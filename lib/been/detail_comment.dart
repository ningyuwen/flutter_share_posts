
class DetailComment {

  int userId;
  int commentId;
  String content;
  String time;
  String username;
  String headUrl;

  DetailComment({
    this.userId,this.commentId,this.content,this.time,this.username,this.headUrl,
  });

  static DetailComment fromJson(Map<String,dynamic> json){
    return DetailComment(
      userId: json['userId'],
      commentId: json['commentId'],
      content: json['content'],
      time: json['time'],
      username: json['username'],
      headUrl: json['headUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'commentId': commentId,
    'content': content,
    'time': time,
    'username': username,
    'headUrl': headUrl,
  };

}