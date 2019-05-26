
class CheckUpdateBeen {

  bool newVersion;
  int newVerCode;
  String newVerName;
  String downloadUrl;

  CheckUpdateBeen({this.newVersion, this.newVerCode, this.newVerName, this.downloadUrl});

  CheckUpdateBeen.fromJson(Map<String, dynamic> json) {
    newVersion = json['newVersion'];
    newVerCode = json['newVerCode'];
    newVerName = json['newVerName'];
    downloadUrl = json['downloadUrl'];
  }

}