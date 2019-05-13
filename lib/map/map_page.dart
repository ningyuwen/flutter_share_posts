import 'dart:async';

import 'package:amap_location/amap_location.dart';
import 'package:flutter/material.dart';
import 'package:mmkv_flutter/mmkv_flutter.dart';
import 'package:my_mini_app/been/map_page_been.dart';
import 'package:my_mini_app/map/map_provider.dart';
import 'package:my_mini_app/util/const_util.dart';
import 'package:my_mini_app/util/toast_util.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

///当webview插件更新时，记得修改 WebviewManager 中的：
///webView.getSettings().setUseWideViewPort(true);
///webView.getSettings().setLoadWithOverviewMode(true);

class MapWidget extends StatefulWidget {
  final MapPageBeen _post;

  MapWidget(this._post);

  @override
  State<StatefulWidget> createState() {
    return new _MapState(_post);
  }
}

class _MapState extends State<MapWidget> {
  AMapLocation _location;
  MapPageBeen _post;
  MapProvider _provider = MapProvider.newInstance();
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  String _url;

  _MapState(this._post) {
    print("输出位置：${_post.position}");
    _url =
        "http://47.112.12.104:8080/map/?long=${_post.longitude}&lat=${_post.latitude}&ml=${_post.myLongitude}&mt=${_post.myLatitude}";
    _location = new AMapLocation();
  }

  @override
  void initState() {
    _provider.getPosition((AMapLocation location) {
      _location = location;
      print("当前位置: ${_post.myLongitude}");
      if (_post.myLongitude == 0.0) {
        //没有记录当前位置在MMKV中
        //需要刷新一下
        _post.myLongitude = _location.longitude;
        _post.myLatitude = _location.latitude;
        _url =
            "http://47.112.12.104:8080/map/?long=${_post.longitude}&lat=${_post.latitude}&ml=${_location.longitude}&mt=${_location.latitude}";
        _controller.future.then((WebViewController webViewController) {
          webViewController.loadUrl(_url);
        });
      }
      _saveMyLocation();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            title: Text("地图"),
            centerTitle: true,
            actions: <Widget>[
              NavigationControls(_controller.future),
            ],
          ),
          preferredSize: Size.fromHeight(APPBAR_HEIGHT)),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: _url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          javascriptChannels: <JavascriptChannel>[
            _toasterJavascriptChannel(context),
          ].toSet(),
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
        );
      }),
      floatingActionButton: favoriteButton(),
      bottomSheet: BottomSheet(onClosing: () {
        print("");
      }, builder: (BuildContext context) {
        return Container(
          height: 66.0,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: _bottomNavigationBar(),
          ),
        );
      }),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  Widget favoriteButton() {
    return FutureBuilder<WebViewController>(
        future: _controller.future,
        builder: (BuildContext context,
            AsyncSnapshot<WebViewController> controller) {
          if (controller.hasData) {
            return FloatingActionButton(
              mini: true,
              elevation: 2.0,
              highlightElevation: 2.0,
              backgroundColor: Colors.green,
              onPressed: () async {
                final List<String> mapApps = new List();
                mapApps.add("百度地图");
                mapApps.add("高德地图");
                mapApps.add("腾讯地图");
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          contentPadding: EdgeInsets.all(0.0),
                          content: Container(
                            height: 150.0,
                            child: ListView.separated(
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  child: Container(
                                    height: 50.0,
                                    alignment: Alignment.center,
                                    child: Text(mapApps[index]),
                                  ),
                                  onTap: () {
                                    _launchURL(index);
                                    Navigator.pop(context);
                                  },
                                );
                              },
                              itemCount: mapApps.length,
                              separatorBuilder: (context, index) => Divider(
                                    height: 0.0,
                                  ),
                            ),
                          ));
                    });
              },
              child: const Icon(
                Icons.navigation,
                color: Colors.white,
              ),
            );
          }
          return Container();
        });
  }

  _launchURL(int index) async {
    String uri = "";
    switch (index) {
      case 0: //百度地图
        uri =
            "baidumap://map/direction?destination=name:${_post.store}|latlng:${_post.latitude},${_post.longitude}|addr:${_post.position}&coord_type=bd09ll&mode=driving&src=andr.baidu.openAPIdemo";
        break;
      case 1: //高德地图
        uri =
            "androidamap://route?sourceApplication=amap&slat=${_post.myLatitude}&slon=${_post.myLongitude}&dlat=${_post.latitude}&dlon=${_post.longitude}&dname=${_post.store}&dev=0&t=2";
        break;
      case 2: //腾讯地图
        uri =
            "qqmap://map/routeplan?type=drive&tocoord=${_post.latitude},${_post.longitude}&to=${_post.store}&fromcoord=CurrentLocation";
        break;
    }
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      ToastUtil.showToast("未安装该应用，请使用其它地图应用打开");
      throw 'Could not launch $uri';
    }
  }

  List<Widget> _bottomNavigationBar() {
    List<Widget> widgets = new List();
    widgets.add(
      Positioned(
          left: 10.0,
          top: 12.0,
          right: 60.0,
          child: Text(
            _post.store,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.title,
          )),
    );
    widgets.add(
      Positioned(
        bottom: 12.0,
        left: 10.0,
        right: 60.0,
        child: Text(
          _post.position,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 12.0, color: Theme.of(context).textTheme.body1.color),
        ),
      ),
    );
    return widgets;
  }

  void _saveMyLocation() async {
    MmkvFlutter mmkv = await MmkvFlutter.getInstance(); //初始化mmkv
    await mmkv.setDouble("myNowPositionLongitude", _location.longitude);
    await mmkv.setDouble("myNowPositionLatitude", _location.latitude);
    await mmkv.setBool("loadMapPagePresent", true); //以前是否打开过map page
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture)
      : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;
        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: !webViewReady
                  ? null
                  : () {
                      controller.reload();
                    },
            ),
          ],
        );
      },
    );
  }
}
