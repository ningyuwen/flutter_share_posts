import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:my_mini_app/been/been.dart';
import 'package:my_mini_app/provider/publish_post_provider.dart';
import 'package:my_mini_app/util/network_tuil.dart';
import 'package:my_mini_app/util/toast_util.dart';

enum RequestMethod { GET, POST, PUT }

class ApiUtil {
  static ApiUtil _apiUtil;
  static Dio _dio; //dio

//  final String SERVER_URL = "http://172.26.52.30:8080"; //windows
  final String SERVER_URL = "http://47.112.12.104:8080/adu"; //线上服务器
//  static const String SERVER_URL = "http://192.168.31.6:8080";  //mac

  ApiUtil() {
    _dio = new Dio();
    _dio.options.baseUrl = SERVER_URL;
    _dio.options.method = "get";
    _dio.options.connectTimeout = 5000;
    _dio.cookieJar = new PersistCookieJar(
        dir: "/data/user/0/com.example.fluttershareposts/app_flutter/cookies");
  }

  static ApiUtil getInstance() {
    if (_apiUtil == null) {
      _apiUtil = new ApiUtil();
    }
    return _apiUtil;
  }

  Future<File> _getLocalFile() async {
    // get the path to the document directory.
    String dir = "/data/user/0/com.example.fluttershareposts/app_flutter/cookies/192.168.31.68080";
    return new File(dir);
  }

  Future<String> _readCounter() async {
    try {
      File file = await _getLocalFile();
      // read the variable as a string from the file.
      String contents = await file.readAsString();
      return contents;
//      return int.parse(contents);
    } on FileSystemException {
      return "hhhhhh";
    }
  }

  //网络请求
  Future<dynamic> netFetch(
      path, RequestMethod method, params, Map<String, String> header) async {
    switch (method) {
      case RequestMethod.GET:
        _dio.options.method = "GET";
        break;
      case RequestMethod.POST:
        _dio.options.method = "POST";
        break;
      default:
        _dio.options.method = "GET";
    }
    //此行代码非常重要，设置传输文本格式
    _dio.options.contentType =
        ContentType.parse("application/x-www-form-urlencoded");
//    print("netFetch data is: ${params.toString()}");

//    String string = await _readCounter();
//    print("cookie is: $string");

    try {
      Response response = await _dio.request(_dio.options.baseUrl + path,
          data: params, options: _dio.options);
      if (response.statusCode == 200) {
//         print(response.data.toString());
        Map map = jsonDecode(response.data.toString());
        var been = new Been.fromJson(map);
        if (been.code == 0) {
          return been.data;
        } else if (been.code == -1) {
          //登陆失效，重新登录
//          SharedPreferences preferences = await SharedPreferences.getInstance();
//          await preferences.setBool("isLogin", false);
          ToastUtil.showToast("操作失败，请稍后重试...");
        }
      } else {
        ToastUtil.showToast(response.statusCode.toString());
      }
    } catch (error) {
//      print("请求出现错误 $error");
      DioError dioError = (error as DioError);
      switch (dioError.type) {
        case DioErrorType.DEFAULT:
          return NetworkUtil.NO_NETWORK;
        case DioErrorType.CONNECT_TIMEOUT:
          return NetworkUtil.CONNECT_TIMEOUT;
        default:
          return NetworkUtil.UNKOWN_ERROR;
      }
    }
    return NetworkUtil.UNKOWN_ERROR;
  }

  //发布
  Future<dynamic> publishPost(PublishBeen been) async {
    Dio dio = new Dio();
    dio.options.baseUrl = SERVER_URL;
    dio.options.method = "post";
    dio.options.contentType = ContentType.parse("multipart/form-data");

    FormData formData = new FormData.from({
      "store": been.store,
      "cost": been.cost,
      "img": new UploadFileInfo(been.img, "upload",
          contentType: ContentType.parse("multipart/form-data")),
      "content": been.content,
      "imgLabel": been.imgLabel,
      "position": been.position,
      "longitude": been.longitude,
      "latitude": been.latitude,
      "district": been.district,
    });

    Response response = await dio.post(
        dio.options.baseUrl + "/post/releasePost",
        data: formData,
        options: dio.options);
//    print(response);
    Map map = jsonDecode(response.data.toString());
    var basicBeen = new Been.fromJson(map);
    if (basicBeen.code == 0) {
      //发布成功，返回上一页
      ToastUtil.showToast("发布成功");
      return basicBeen.data;
    } else {
      ToastUtil.showToast(basicBeen.data);
      return false;
    }
  }
}
