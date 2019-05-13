import 'dart:async';

import 'package:amap_location/amap_location.dart';
import 'package:flutter/material.dart';
import 'package:simple_permissions/simple_permissions.dart';

void main() async {
  AMapLocationClient.setApiKey("4c6f8a60ec44f308a05d60c65ce721a2");
  await AMapLocationClient.startup(new AMapLocationOption( desiredAccuracy:CLLocationAccuracy.kCLLocationAccuracyHundredMeters  ));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();

  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
//    // Platform messages may fail, so we use a try/catch PlatformException.
//    try {
//      platformVersion = await FlutterAmapPlugin.platformVersion;
//    } on PlatformException {
//      platformVersion = 'Failed to get platform version.';
//    }

    AMapLocation location =
        await AMapLocationClient.getLocation(true);

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    print(location.formattedAddress);
    print(location.country);
    print(location.latitude);
    print(location.longitude);

    setState(() {
      _platformVersion = location.formattedAddress;
    });
  }

  @override
  Widget build(BuildContext context) {
    getPermission();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }

  void getPermission() async {
    bool hasPermission =
        await SimplePermissions.checkPermission(Permission.AlwaysLocation);
    if (hasPermission) {
      initPlatformState();
    } else {
      PermissionStatus status =
          await SimplePermissions.requestPermission(Permission.AlwaysLocation);
      if (status == PermissionStatus.authorized) {
        print("您打开了位置权限");
        initPlatformState();
      } else {
        print("您关闭了位置权限");
      }
    }
  }
}
