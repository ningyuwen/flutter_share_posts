import 'package:flutter/material.dart';
import 'package:my_mini_app/map/map_provider.dart';
//import 'package:amap_base_navi/amap_base_navi.dart';
//import 'package:amap_base_map/amap_base_map.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';


class MapWidget extends StatelessWidget {

  final String _position;
  final double _latitude;
  final double _longitude;

  MapWidget(this._position, this._latitude, this._longitude);

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: "http://172.25.214.67:8888/",
      appBar: new AppBar(
        title: new Text("地图"),
        centerTitle: true,
      ),
    );

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("地图"),
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
    return new _MapState(_position);
  }
}

class _MapState extends State<_MapWidget> {
  String _position;

  _MapState(String position) {
    _position = position;
  }

  MapProvider _provider = MapProvider.newInstance();

  @override
  void initState() {
    _provider.getPosition((String position) {
      setState(() {
        _position = position;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("地址是: $_position");
//    return

    return Text(
        "$_position and longitude: ${widget._latitude} and ${widget._longitude}");
  }
}
