import 'package:flutter/material.dart';
import 'package:amap_base/amap_base.dart';

class MapWidget extends StatelessWidget {

  AMapController _controller;
  MyLocationStyle _myLocationStyle = MyLocationStyle();

  @override
  Widget build(BuildContext context) {
    return AMapView(
      onAMapViewCreated: (AMapController controller) {
        _controller = controller;
        _controller.setMyLocationStyle(_myLocationStyle);
      },
      amapOptions: AMapOptions(
//        compassEnabled: false,
//        zoomControlsEnabled: true,
        logoPosition: LOGO_POSITION_BOTTOM_CENTER,
//        camera: CameraPosition(
//          target: LatLng(40.851827, 111.801637),
//          zoom: 15,
//        ),
      ),
    );
  }

}