import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:convert';
import 'package:my_mini_app/been/been.dart';
import 'package:my_mini_app/util/toast_util.dart';
//import 'package:jaguar_retrofit/jaguar_retrofit.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum RequestMethod { GET, POST, PUT }

class ApiUtil {
  static ApiUtil _apiUtil;
  static Dio _dio; //dio

  ApiUtil() {
    _dio = new Dio();
    // _dio.options.baseUrl = "http://172.26.52.30:8080";
    _dio.options.baseUrl = "http://172.26.52.30:8080";
//    _dio.options.baseUrl = "http://192.168.0.102:8080";
    _dio.options.method = "get";
    _dio.options.connectTimeout = 60000;
    //此行代码非常重要，设置传输文本格式
    _dio.options.contentType =
        ContentType.parse("application/x-www-form-urlencoded");
  }

  static ApiUtil getInstance() {
    if (_apiUtil == null) {
      _apiUtil = new ApiUtil();
    }
    return _apiUtil;
  }

  //网络请求
  Future<dynamic> netFetch(path, RequestMethod method, params,
      Map<String, String> header) async {
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
    print("netFetch data is: ${params.toString()}");
    try {
      Response response = await _dio.request(_dio.options.baseUrl + path,
          data: params, options: _dio.options);
      if (response.statusCode == 200) {
        print(response.data.toString());
        Map map = jsonDecode(response.data.toString());
        var been = new Been.fromJson(map);
        if (been.code == 0) {
          return been.data;
        } else if (been.code == -1) {
          //登陆失效，重新登录
          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.setBool("isLogin", false);
        }
      } else {
        ToastUtil.showToast(response.statusCode.toString());
      }
    } catch (error) {
      print(error);
    }
    return "sad";
  }

}
