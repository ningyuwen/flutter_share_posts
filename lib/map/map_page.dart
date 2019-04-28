import 'package:amap_location/amap_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:my_mini_app/been/map_page_been.dart';
import 'package:my_mini_app/been/post_around_been.dart';
import 'package:my_mini_app/map/map_provider.dart';
import 'package:my_mini_app/util/const_util.dart';
import 'package:url_launcher/url_launcher.dart';

class MapWidget extends StatelessWidget {
//  final String _position;
//  final double _latitude;
//  final double _longitude;
  final MapPageBeen _post;

  MapWidget(this._post);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(child: AppBar(
          title: Text("地图"),
          centerTitle: true,
        ), preferredSize: Size.fromHeight(APPBAR_HEIGHT)),
        body: _MapWidget(_post));
  }
}

class _MapWidget extends StatefulWidget {
  final MapPageBeen _post;

  _MapWidget(this._post);

  @override
  State<StatefulWidget> createState() {
    return new _MapState(_post);
  }
}

class _MapState extends State<_MapWidget> {
  AMapLocation _location;
  MapPageBeen _post;

  _MapState(this._post) {
    print("输出位置：${_post.position}");
    _location =
        new AMapLocation(longitude: _post.longitude, latitude: _post.latitude);
  }

  MapProvider _provider = MapProvider.newInstance();

  final flutterWebViewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    _provider.getPosition((AMapLocation location) {
      setState(() {
        _location = location;
        flutterWebViewPlugin.reloadUrl(
            "http://47.112.12.104:8080/map/?long=${_post.longitude}&lat=${_post.latitude}&ml=${_location.longitude}&mt=${_location.latitude}");
//            "http://192.168.1.103:8088/?long=113.373945&lat=22.946402&ml=113.351211&mt=22.988359");
      });
    });

//    flutterWebViewPlugin.reloadUrl(
////            "http://47.112.12.104:8080/map/?long=${widget._longitude}&lat=${widget._latitude}&ml=${_location.longitude}&mt=${_location.latitude}");
//        "http://192.168.1.103:8088/?long=113.373945&lat=22.946402&ml=113.351211&mt=22.988359");
    super.initState();
  }

  _launchURL() async {
//    Uri uri =
    String url =
        "baidumap://map/direction?destination=${_post.position}&latlng=${_post.latitude},${_post.longitude}&coord_type=bd09ll&mode=driving&src=andr.baidu.openAPIdemo";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    print("地址是: ${_location.longitude} and: ${_location.latitude}");
    print("地址2市: ${_post.longitude} and: ${_post.latitude}");
    return WebviewScaffold(
//      url:
//          "http://47.112.12.104:8080/map/?long=${widget._longitude}&lat=${widget._latitude}&ml=${_location.longitude}&mt=${_location.latitude}",

        url: "",
//            "http://192.168.1.103:8088/?long=113.373945&lat=22.946402&ml=113.351211&mt=22.988359",
        withZoom: true,
        useWideViewPort: true,
        bottomNavigationBar: Container(
            width: MediaQuery.of(context).size.width,
            height: 70.0,
            child: Stack(
              children: <Widget>[
                Positioned(
                    left: 10.0,
                    top: 14.0,
                    right: 60.0,
                    child: Text(
                      _post.store,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.title,
                    )),
                Positioned(
                  bottom: 14.0,
                  left: 10.0,
                  right: 60.0,
                  child: Text(
                    _post.position,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12.0,
                        color: Theme.of(context).textTheme.body1.color),
                  ),
                ),
                Positioned(
                    right: 14.0,
                    bottom: 14.0,
                    top: 14.0,
                    child: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: IconButton(
                          icon: Icon(
                            Icons.navigation,
                            size: 24.0,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _launchURL();
                          }),
                    ))
              ],
            )));
  }
}
