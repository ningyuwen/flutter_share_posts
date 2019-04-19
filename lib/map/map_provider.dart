
//import 'package:amap_base_search/amap_base_search.dart';
import 'package:amap_location/amap_location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

class MapProvider {
  final String _EMPTY = "_empty_";

  final _fetcher = new PublishSubject<String>();

  String _data;

  stream() => _fetcher.stream;

  void dispose() {
    if (!_fetcher.isClosed) {
      _fetcher.close();
    }
  }

  @override
  String toString() {
    return super.toString();
  }

  static MapProvider newInstance() => new MapProvider();

  void getPosition(Function setPosition) async {
    getLocationPermission(setPosition);
  }

  void showMyPosition(Function setPosition) async {
    AMapLocation location = await AMapLocationClient.getLocation(true);
    print(location.formattedAddress);
    print("经纬度: ${location.longitude}, ${location.latitude}");
    String position = location.district +
        location.street +
        location.number +
        "靠近" +
        location.POIName;
    print(position);
    setPosition(location);
  }

  void getLocationPermission(Function setPosition) async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);
    print("serviceStatus is: $permission");
    if (permission == PermissionStatus.granted) {
      print("有位置权限");
      showMyPosition(setPosition);
    } else {
      Map<PermissionGroup, PermissionStatus> permissions =
      await PermissionHandler()
          .requestPermissions([PermissionGroup.location]);
      if (permissions[PermissionGroup.location] == PermissionStatus.granted) {
        print("有位置权限了");
        showMyPosition(setPosition);
      } else {
        print("没有位置权限");
      }
    }
  }

  void searchPosition(String position, Function success) async {
//    GeocodeResult geocodeResult = await AMapSearch().searchGeocode(position, "番禺区");
//    success(geocodeResult);
  }
}