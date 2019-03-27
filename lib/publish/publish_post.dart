import 'package:flutter/material.dart';
import 'package:my_mini_app/util/toast_util.dart';
import 'package:image_picker/image_picker.dart';

//import 'package:geolocator/geolocator.dart';
// import 'package:my_mini_app/util/api_util.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:convert';
import 'package:my_mini_app/been/been.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

//发布
Future<bool> publishPost(PublishBeen been) async {
  Dio dio = new Dio();
//  dio.options.baseUrl = "http://192.168.0.102:8080/";
//   dio.options.baseUrl = "http://192.168.0.103:8080/";
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
}

class PublishPostView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PublishPostStatefulWidget();
  }
}

class PublishPostStatefulWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PublishPostState();
  }
}

class PublishPostState extends State<PublishPostStatefulWidget> {
//  Image
  double _height = 0;
  var _image;
  final FocusNode _storeFocus = FocusNode();
  final FocusNode _costFocus = FocusNode();
  final FocusNode _positionFocus = FocusNode();
  final FocusNode _contentFocus = FocusNode();
  var currentLocation = <String, double>{};

//  var location = new Location();

//  Position _position;
  final TextEditingController _storeController =
      TextEditingController(text: "");
  final TextEditingController _costController = TextEditingController(text: "");
  final TextEditingController _positionController =
      TextEditingController(text: "");
  final TextEditingController _contentController =
      TextEditingController(text: "");

  //声明一个调用对象，需要把kotlin中注册的ChannelName传入构造函数
//  static const _platform = const MethodChannel('aduning/tencent_location');

  @override
  void initState() {
    super.initState();
    getPosition();
//    _platform.invokeMethod('getCurrentLocation', { 'message': '你点击了按钮！'}); //调用相应方法，并传入相关参数。
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appBar(), body: scrollView());
  }

  Widget rightColumn() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _storeController,
            maxLines: 1,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              hintText: '请输入店名',
            ),
            focusNode: _storeFocus,
            onFieldSubmitted: (term) {
              _fieldFocusChange(context, _storeFocus, _costFocus);
            },
          ),
          TextFormField(
            controller: _costController,
            maxLines: 1,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              hintText: '请输入消费金额',
            ),
            focusNode: _costFocus,
            onFieldSubmitted: (term) {
              _fieldFocusChange(context, _costFocus, _positionFocus);
            },
          ),
          TextFormField(
            controller: _positionController,
            maxLines: 1,
            style: TextStyle(fontSize: 12.0, color: Colors.black),
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
                //此处获取地理位置
//              hintText: _positionStr
                ),
            focusNode: _positionFocus,
            onFieldSubmitted: (term) {
              _fieldFocusChange(context, _positionFocus, _contentFocus);
            },
          ),
          TextFormField(
            controller: _contentController,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.multiline,
            maxLines: 7,
            maxLength: 150,
            style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.normal),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: '什么样的消费体验？',
            ),
            focusNode: _contentFocus,
            onFieldSubmitted: (term) {
              _contentFocus.unfocus();
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: showPicFromFile(),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0, right: 50.0, bottom: 20.0),
            child: Row(
              children: <Widget>[
                photoOrImageButton("拍照"),
                SizedBox(
                  width: 20.0,
                ),
                photoOrImageButton("相册"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode focusOld, FocusNode focusNew) {
    focusOld.unfocus();
    FocusScope.of(context).requestFocus(focusNew);
  }

  Widget photoOrImageButton(String string) {
    return GestureDetector(
      onTap: () {
        if (string == "拍照") {
          //跳转拍照
          getImage();
        } else if (string == "相册") {
          //跳转相册

        }
      },
      child: Container(
          width: 80.0,
          height: 80.0,
          decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          child: Padding(
            padding: EdgeInsets.only(top: 7.5, bottom: 7.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                    width: 40.0,
                    height: 40.0,
                    child: getPhotoInnerImage(string)),
                Text(string,
                    style: TextStyle(color: Colors.grey, fontSize: 13.0))
              ],
            ),
          )),
    );
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 800,
      maxHeight: 600,
    );

    setState(() {
      _image = image;
    });
  }

  Widget getPhotoInnerImage(String string) {
    if (string == "拍照") {
      return Image.asset(
        "image/ic_photo.png",
      );
    } else if (string == "相册") {
      return Image.asset(
        "image/ic_image.png",
      );
    }
    return Text("");
  }

  Widget showPicFromFile() {
    if (_image != null) {
      return Stack(
        alignment: FractionalOffset.topRight,
        children: <Widget>[
          Image.file(_image),
          GestureDetector(
            onTap: () {
              setState(() {
                _image = null;
              });
            },
            child: Padding(
                padding: EdgeInsets.only(top: 15.0, right: 15.0),
                child: Image.asset("image/ic_delete.png", width: 25.0)),
          )
        ],
      );
    }
    return Container(
      height: 0.0,
    );
  }

  void getPosition() async {
//    _position = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
//    print(_position.longitude);
//    setState(() {
//      _positionController.text = _position.toString();
//    });
    // Platform messages may fail, so we use a try/catch PlatformException.
//    try {
//      currentLocation = await location.getLocation();
//      print(currentLocation["longitude"]);
//      setState(() {
//        _positionController.text = currentLocation["longitude"].toString();
//      });
//    } catch (e) {
//      currentLocation = null;
//    }

//    var currentLocation = <String, double>{};
//    var location = new Location();
//    // Platform messages may fail, so we use a try/catch PlatformException.
//    try {
//      currentLocation = location.getLocation as Map<String, double>;
//      ToastUtil.showToast(currentLocation["latitude"].toString());
//    } on PlatformException {
//      currentLocation = null;
//      ToastUtil.showToast("获取位置为空");
//    }

//    AMapLocation location = await AMapLocationClient.getLocation(true);
//    ToastUtil.showToast(location.altitude.toString());


//    var location = new Location();
//
//    location.onLocationChanged().listen((Map<String,double> currentLocation) {
//      print(currentLocation["latitude"]);
//      print(currentLocation["longitude"]);
//      print(currentLocation["accuracy"]);
//      print(currentLocation["altitude"]);
//      print(currentLocation["speed"]);
//      print(currentLocation["speed_accuracy"]); // Will always be 0 on iOS
//      ToastUtil.showToast(currentLocation["latitude"].toString());
//    });
  }

  Widget scrollView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              radius: 18.0,
              child: Image.asset("image/ic_qq.png"),
            ),
            SizedBox(
              width: 10.0,
            ),
            rightColumn()
          ],
        ),
      ),
    );
  }

  Widget appBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Color.fromARGB(255, 51, 51, 51),
      actions: <Widget>[
        ButtonTheme(
          minWidth: 60.0,
          child: RaisedButton(
              color: Color.fromARGB(255, 51, 51, 51),
              onPressed: () {
//                ToastUtil.showToast("发布");
                //发布，检查参数是否齐全
                if (checkArgumentsIsRight()) {
                  ToastUtil.showToast("可以发布");
                  publish();
                }
              },
              child: Text("发布",
                  style: TextStyle(color: Colors.white, fontSize: 16.0))),
        ),
      ],
    );
  }

  bool checkArgumentsIsRight() {
    if (_storeController.text == "") {
      ToastUtil.showToast("请输入店铺名称");
      return false;
    }
    if (_costController.text == "") {
      ToastUtil.showToast("请输入消费金额");
      return false;
    }
    if (_positionController.text == "") {
      ToastUtil.showToast("请输入店铺的位置");
      return false;
    }
    if (_image == null) {
      ToastUtil.showToast("请添加一张美美的图片哦");
      return false;
    }
    return true;
  }

  void publish() async {
    bool success = await publishPost(new PublishBeen(
        _storeController.text,
        3.09,
        _image,
        _contentController.text,
        "imageLabel",
        "番禺大道北666号自在城市花园"));
    if (success) {
      Navigator.pop(context);
    }
  }
}
