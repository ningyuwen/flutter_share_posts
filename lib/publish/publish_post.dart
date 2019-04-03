import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mmkv_flutter/mmkv_flutter.dart';
import 'package:my_mini_app/provider/publish_post_provider.dart';
import 'package:my_mini_app/util/toast_util.dart';

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
  PublishPostProvider _postProvider;
  final FocusNode _storeFocus = FocusNode();
  final FocusNode _costFocus = FocusNode();
  final FocusNode _positionFocus = FocusNode();
  final FocusNode _contentFocus = FocusNode();
  var currentLocation = <String, double>{};

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
    _postProvider = PublishPostProvider.newInstance();
    print("initState()");
    super.initState();
  }

  @override
  void dispose() {
    _postProvider.dispose();
    print("dispose()");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: _scrollView());
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
              child: new _PhotosListWidget(_postProvider),
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
          _postProvider.takePhoto();
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

  Widget _scrollView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipOval(
              child: _UserHeadWidget(),
            ),
            const SizedBox(
              width: 10.0,
            ),
            rightColumn()
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Color.fromARGB(255, 51, 51, 51),
      actions: <Widget>[
        ButtonTheme(
          minWidth: 60.0,
          child: RaisedButton(
              color: Color.fromARGB(255, 51, 51, 51),
              onPressed: () {
//                发布，检查参数是否齐全
                if (checkArgumentsIsRight()) {
                  ToastUtil.showToast("可以发布");
//                  _postProvider.publish();
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
    if (_postProvider.publishBeen.img == null) {
      ToastUtil.showToast("请添加一张美美的图片哦");
      return false;
    }
    return true;
  }
}

class _PhotosListWidget extends StatefulWidget {
  final PublishPostProvider _postProvider;

  _PhotosListWidget(this._postProvider);

  @override
  State<StatefulWidget> createState() {
    return new _PhotoListState();
  }
}

class _PhotoListState extends State<_PhotosListWidget> {
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: widget._postProvider.imgStream(),
        builder: (context, AsyncSnapshot<File> snapshot) {
          if (snapshot.hasData) {
            return Stack(
              alignment: FractionalOffset.topRight,
              children: <Widget>[
                Image.file(snapshot.data),
                GestureDetector(
                  onTap: () {
                    return Container(
                      height: 0.0,
                    );
                  },
                  child: Padding(
                      padding: EdgeInsets.only(top: 15.0, right: 15.0),
                      child: Image.asset("image/ic_delete.png", width: 25.0)),
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Container(
              height: 0.0,
            );
          } else {
            return Container(
              height: 0.0,
            );
          }
        });
  }
}

class _UserHeadWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _UserHeadState();
  }
}

class _UserHeadState extends State<_UserHeadWidget> {
  Stream<String> _stream;

  @override
  void initState() {
    _stream = _getUserHeadUrl().asStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _stream,
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return CachedNetworkImage(
                height: 40.0,
                width: 40.0,
                fit: BoxFit.cover,
                imageUrl: snapshot.data);
          } else {
            return CircularProgressIndicator(strokeWidth: 1.0);
          }
        });
  }

  Future<String> _getUserHeadUrl() async {
    MmkvFlutter mmkv = await MmkvFlutter.getInstance(); //初始化mmkv
    return await mmkv.getString("headUrl");
  }
}
