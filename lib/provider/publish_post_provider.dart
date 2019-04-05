import 'dart:convert';
import 'dart:io';

import 'package:amap_location/amap_location.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_mini_app/been/been.dart';
import 'package:my_mini_app/util/toast_util.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simple_permissions/simple_permissions.dart';
//import '';

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
  dio.options.baseUrl = "http://192.168.0.101:8080/";
//  dio.options.baseUrl = "http://47.112.12.104:8080/wam/";
//    dio.options.baseUrl = "http://172.26.52.30:8080/";
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

  //系统相册
  void getGalleryPhoto() async {
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (file == null) {
      return;
    }
    int size = await file.length();
    print("file size is1: ${size / 1000}");
    _fetcher.sink.add(file);
    publishBeen.img = file;
  }

  void takePhoto() async {
    File file = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1280,
    );
    if (file == null) {
      return;
    }
    int size = await file.length();
    print("file size is2: ${size / 1000}");
    _fetcher.sink.add(file);
    publishBeen.img = file;
  }

  void deleteImg() {
    publishBeen.img = null;
    _fetcher.sink.add(null);
  }

  void getPosition(Function setPosition) async {
    getFileWritePermission();

    bool hasPermission =
        await SimplePermissions.checkPermission(Permission.AlwaysLocation);
    if (hasPermission) {
      showMyPosition(setPosition);
    } else {
      PermissionStatus status =
          await SimplePermissions.requestPermission(Permission.AlwaysLocation);
      if (status == PermissionStatus.authorized) {
        ToastUtil.showToast("您打开了位置权限");
        showMyPosition(setPosition);
      } else {
        ToastUtil.showToast("您关闭了位置权限");
      }
    }
  }

  void showMyPosition(Function setPosition) async {
    AMapLocation location = await AMapLocationClient.getLocation(true);
    print(location.formattedAddress);
    print(location.country);
    print(location.latitude);
    print(location.longitude);
    publishBeen.longitude = location.longitude;
    publishBeen.latitude = location.latitude;
    setPosition(location.formattedAddress);
  }

  void getFileWritePermission() async {
    bool hasPermission = await SimplePermissions.checkPermission(Permission.WriteExternalStorage);
    if (!hasPermission) {
      await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
    }
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
