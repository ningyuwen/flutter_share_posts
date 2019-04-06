import 'dart:convert';
import 'dart:io';

import 'package:amap_location/amap_location.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_mini_app/been/been.dart';
import 'package:my_mini_app/been/mine_post_been.dart';
import 'package:my_mini_app/util/api_util.dart';
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

  static PublishPostProvider newInstance() => new PublishPostProvider();

  void publish(Function success) async {
    print(publishBeen.toString());
    dynamic data = await ApiUtil.getInstance().publishPost(publishBeen);
    if (data is Map) {
      Posts post = Posts.fromJson(data);
      success(post);
    } else {
      ToastUtil.showToast("发布失败: ${data.toString()}");
    }
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
    getLocationPermission(setPosition);
  }

  void showMyPosition(Function setPosition) async {
    AMapLocation location = await AMapLocationClient.getLocation(true);
    print(location.formattedAddress);
    print("经纬度: ${location.longitude}, ${location.latitude}");
    String position = location.district + location.street + location.number + "靠近" + location.POIName;
    print(position);
    publishBeen.longitude = location.longitude;
    publishBeen.latitude = location.latitude;
    publishBeen.position = position;
    publishBeen.district = location.district;
    setPosition(position);
  }

  void getLocationPermission(Function setPosition) async {
    bool hasPermission =
    await SimplePermissions.checkPermission(Permission.AlwaysLocation);
    if (hasPermission) {
      showMyPosition(setPosition);
    } else {
      PermissionStatus status =
      await SimplePermissions.requestPermission(Permission.AlwaysLocation);
      if (status == PermissionStatus.authorized) {
//        ToastUtil.showToast("您打开了位置权限");
        showMyPosition(setPosition);
      } else {
//        ToastUtil.showToast("您关闭了位置权限");
      }
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
  String district = "";

  PublishBeen(this.store, this.cost, this.img, this.content, this.imgLabel,
      this.position);

  @override
  String toString() {
    return "$store, $cost, $img, $content, $imgLabel, $position, $latitude, $longitude, $district";
  }

}
