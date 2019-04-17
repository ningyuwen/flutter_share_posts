import 'package:flutter/material.dart';
//import 'package:amap_base/amap_base.dart';
import 'package:amap_base_search/amap_base_search.dart';
//import 'package:amap_base_search/src/map/amap_view.dart';
import 'package:my_mini_app/map/map_provider.dart';

class MapWidget extends StatelessWidget {

//  AMapController _controller;
//  MyLocationStyle _myLocationStyle = MyLocationStyle();

  final String _position;
  
  MapWidget(this._position);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("地图"),
      ),
      body: _MapWidget(_position)
    );
  }
}

class _MapWidget extends StatefulWidget {

  final String _position;
  _MapWidget(this._position);

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
    _provider.searchPosition(_position, (GeocodeResult result) {
      print("得到位置了： ${result.geocodeAddressList[0].formatAddress}");
      setState(() {
        _position = result.geocodeAddressList[0].latLng.latitude.toString();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("地址是: $_position");
    return Text(_position);
  }

}