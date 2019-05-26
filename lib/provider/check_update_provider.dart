import 'dart:io';

import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:my_mini_app/been/check_update_been.dart';
import 'package:my_mini_app/util/api_util.dart';
import 'package:package_info/package_info.dart';
import 'package:rxdart/rxdart.dart';

class CheckUpdateProvider {
  final String _EMPTY = "_empty_";

  final _fetcher = new PublishSubject<CheckUpdateBeen>();

  CheckUpdateBeen _data = new CheckUpdateBeen();

  stream() => _fetcher.stream;

  void dispose() {
    if (!_fetcher.isClosed) {
      _fetcher.close();
    }
    FlutterDownloader.registerCallback(null);
  }

  static CheckUpdateProvider newInstance() => new CheckUpdateProvider();

  Future<CheckUpdateBeen> checkUpdate() async {
    String platform = "";
    if (Platform.isAndroid) {
      platform = "android";
    } else if (Platform.isIOS) {
      platform = "ios";
    }
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    print(version);
    print(buildNumber);
    dynamic map = await ApiUtil.getInstance().netFetch(
        "/app/hasNewVersion",
        RequestMethod.GET,
        {"platform": platform, "verCode": buildNumber},
        null);
    print(map);
    if (map is Map) {
      _data = CheckUpdateBeen.fromJson(map);
      _fetcher.sink.add(_data);
      return _data;
    } else {
      return null;
    }
  }

  Widget streamBuilder<T>({
    T initialData,
    Function success,
    Function error,
    Function empty,
    Function loading,
    Function finished,
  }) {
    return StreamBuilder(
        stream: stream(),
        initialData: initialData,
        builder: (context, AsyncSnapshot<T> snapshot) {
          if (finished != null) {
            finished();
          }
          if (snapshot.hasData) {
            if (success != null) return success(snapshot.data);
          } else if (snapshot.hasError) {
            final errorStr = snapshot.error;
            if (errorStr == _EMPTY) {
              if (empty != null) return empty();
            } else {
              if (error != null) return error(errorStr);
            }
          } else {
            if (loading != null) return loading();
          }
        });
  }

  void downloadApk(String downloadUrl) async {
    Directory downloadsDirectory =
        await DownloadsPathProvider.downloadsDirectory;
    print(downloadsDirectory.path);
    final taskId = await FlutterDownloader.enqueue(
      url: downloadUrl,
      savedDir: downloadsDirectory.path,
      showNotification: true,
      // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
//    FlutterDownloader.registerCallback((id, status, progress) {
//      // code to update your UI
//    });
  }
}
