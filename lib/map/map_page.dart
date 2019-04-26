import 'package:amap_location/amap_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:my_mini_app/map/map_provider.dart';

class MapWidget extends StatelessWidget {
  final String _position;
  final double _latitude;
  final double _longitude;

  MapWidget(this._position, this._latitude, this._longitude);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(_position),
        ),
        body: _MapWidget(_position, _latitude, _longitude));
  }
}

class _MapWidget extends StatefulWidget {
  final String _position;
  final double _latitude;
  final double _longitude;

  _MapWidget(this._position, this._latitude, this._longitude);

  @override
  State<StatefulWidget> createState() {
    return new _MapState(_longitude, _latitude);
  }
}

class _MapState extends State<_MapWidget> {
  AMapLocation _location;

  _MapState(double longitude, double latitude) {
    _location = new AMapLocation(longitude: longitude, latitude: latitude);
  }

  MapProvider _provider = MapProvider.newInstance();

  final flutterWebViewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    _provider.getPosition((AMapLocation location) {
      setState(() {
        _location = location;
        flutterWebViewPlugin.reloadUrl(
            "http://47.112.12.104:8080/map/?long=${widget._longitude}&lat=${widget._latitude}&ml=${_location.longitude}&mt=${_location.latitude}");
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("地址是: ${_location.longitude} and: ${_location.latitude}");
    print("地址2市: ${widget._longitude} and: ${widget._latitude}");
    return WebviewScaffold(
//      url: "http://47.112.12.104:8080/map/?long=$_longitude&lat=$_latitude",
//      url: "http://47.112.12.104:8080/map/?long=113.327013&lat=23.119987",
      url:
          "http://47.112.12.104:8080/map/?long=${widget._longitude}&lat=${widget._latitude}&ml=${_location.longitude}&mt=${_location.latitude}",

//      url: "http://47.112.12.104:8080/map/?long=113.373945&lat=22.946402&ml=113.351211&mt=22.988359",
      withZoom: true,
//      withLocalStorage: true,
      useWideViewPort: true,
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                flutterWebViewPlugin.reload();
              },
            ),
            Text("导航")
          ],
        ),
      ),
    );
  }
}
