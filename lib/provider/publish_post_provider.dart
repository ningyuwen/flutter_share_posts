import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_mini_app/been/been.dart';
import 'package:my_mini_app/util/toast_util.dart';
import 'package:rxdart/rxdart.dart';

class PublishPostProvider {
  final _fetcher = new PublishSubject<File>();

  imgStream() => _fetcher.stream;

  PublishBeen publishBeen = new PublishBeen("", 0.0, null, "", "", "");

  void dispose() {
    if (!_fetcher.isClosed) {
      _fetcher.close();
    }
  }

  //发布
  Future<bool> publishPost(PublishBeen been) async {
    Dio dio = new Dio();
//  dio.options.baseUrl = "http://192.168.0.102:8080/";
//  dio.options.baseUrl = "http://47.112.12.104:8080/wam/";
    dio.options.baseUrl = "http://172.26.52.30:8080/";
    dio.options.method = "post";
    dio.options.connectTimeout = 60000;
    //此行代码非常重要，设置传输文本格式
    dio.options.contentType =
        ContentType.parse("application/x-www-form-urlencoded");

    FormData formData = new FormData.from({
      "store": been.store,
      "cost": been.cost,
      "img": new UploadFileInfo(been.img, "upload.jpg"),
      "content": been.content,
      "imgLabel": been.imgLabel,
      "position": been.position,
      "longitude": been.longitude,
      "latitude": been.latitude,
      "district": been.district,
    });
    Response response = await dio.post(dio.options.baseUrl + "post/releasePost",
        data: formData, options: dio.options);
    Map map = jsonDecode(response.data.toString());
    var basicBeen = new Been.fromJson(map);
    if (basicBeen.code == 0) {
      //发布成功，返回上一页
      return true;
    } else {
      ToastUtil.showToast(basicBeen.data);
      return false;
    }
  }

  static PublishPostProvider newInstance() => new PublishPostProvider();

  void takePhoto() async {
    File file = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 800,
      maxHeight: 600,
    );
    _fetcher.sink.add(file);
    publishBeen.img = file;
  }

  void publish() async {
//    bool success = await publishPost(new PublishBeen(
//        _storeController.text,
//        3.09,
//        _image,
//        _contentController.text,
//        "imageLabel",
//        "番禺大道北666号自在城市花园"));
    bool success = await publishPost(publishBeen);
//    if (success) {
//      Navigator.pop(context);
//    }
  }
}

class PublishBeen {
  String store;
  double cost;
  File img;
  String content;
  String imgLabel;
  String position;
  double longitude = 0.0;
  double latitude = 0.0;
  String district = "番禺区";

  PublishBeen(this.store, this.cost, this.img, this.content, this.imgLabel,
      this.position);

  void setStore(String store) {
    this.store = store;
  }

  File getImg() {
    return img;
  }

}
