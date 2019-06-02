import 'dart:io';

import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:my_mini_app/been/check_update_been.dart';
import 'package:my_mini_app/provider/auth_provider.dart';
import 'package:my_mini_app/provider/check_update_provider.dart';
import 'package:my_mini_app/util/const_util.dart';
import 'package:my_mini_app/util/snack_bar_util.dart';
import 'package:my_mini_app/util/toast_util.dart';
import 'package:my_mini_app/webview/webview_page.dart';
import 'package:package_info/package_info.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingPage extends StatelessWidget {
  static const String PAGE_NAME_OPEN_SOURCE = "关于作者";

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: _bodyWidget(context));
  }

  Widget _appBar() {
    return PreferredSize(
        child: AppBar(
          title: Text("设置"),
          centerTitle: true,
        ),
        preferredSize: Size.fromHeight(APPBAR_HEIGHT));
  }

  Widget _bodyWidget(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView.separated(
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return _openSourceWidget(context);
                case 1:
                  return _checkUpdateWidget();
                case 2:
                  return _logoutWidget(context);
              }
            },
            separatorBuilder: (context, index) => Divider(
                  height: 0.0,
                ),
            itemCount: 4),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: FutureBuilder(
              future: _getVersion(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  print("version is: ${snapshot.data}");
                  return Text("V${snapshot.data}");
                } else {
                  return CupertinoActivityIndicator();
                }
              },
            ),
          ),
        )
      ],
    );
  }

  void _logout() async {
    AuthProvider().logout();
  }

  Widget _openSourceWidget(BuildContext context) {
    return InkWell(
      child: Container(
        height: 50.0,
        padding: EdgeInsets.only(left: 18.0, right: 10.0),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(PAGE_NAME_OPEN_SOURCE),
            Icon(
              Icons.chevron_right,
              color: Colors.black54,
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => new WebViewPage(
                    PAGE_NAME_OPEN_SOURCE, "https://github.com/ningyuwen")));
      },
    );
  }

  Widget _checkUpdateWidget() {
    return new _CheckUpdateWidget();
  }

  Widget _logoutWidget(BuildContext context) {
    return InkWell(
      child: Container(
        height: 50.0,
        padding: EdgeInsets.only(left: 18.0, right: 10.0),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("退出登录"),
            Icon(
              Icons.chevron_right,
              color: Colors.black54,
            )
          ],
        ),
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  content: new Text("您确定退出登录吗？"),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("取消"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    new FlatButton(
                      child: new Text("确定"),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _logout();
                        Navigator.of(context).pop();
                      },
                    )
                  ]);
            });
      },
    );
  }

  Future<String> _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}

class _CheckUpdateWidget extends StatefulWidget {
  @override
  _CheckUpdateWidgetState createState() {
    return _CheckUpdateWidgetState();
  }
}

class _CheckUpdateWidgetState extends State<_CheckUpdateWidget> {
  String _promptText = "j";

  CheckUpdateProvider _checkUpdateProvider = CheckUpdateProvider.newInstance();

  @override
  void initState() {
    _checkUpdateProvider.checkUpdate();
    super.initState();
  }

  @override
  void dispose() {
    FlutterDownloader.registerCallback(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 50.0,
        padding: EdgeInsets.only(left: 18.0, right: 10.0),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("检查更新"),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _checkUpdateProvider.streamBuilder(
                    success: (CheckUpdateBeen checkUpdateBeen) {
                  if (checkUpdateBeen.newVersion) {
                    return Text("可升级最新版本${checkUpdateBeen.newVerName}",
                        style: const TextStyle(fontSize: 14.0));
                  } else {
                    return Text("当前已是最新版本",
                        style: const TextStyle(fontSize: 14.0));
                  }
                }, loading: () {
                  return CupertinoActivityIndicator(radius: 8.0);
                }, error: (error) {
                  return Text("");
                }),
                Icon(
                  Icons.chevron_right,
                  color: Colors.black54,
                )
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return CupertinoActivityIndicator();
            });
        _checkUpdateProvider
            .checkUpdate()
            .then((CheckUpdateBeen checkUpdateBeen) {
          Navigator.pop(context);
          if (checkUpdateBeen.newVersion) {
            //有新版本
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      content: Text("当前有新版本可更新，是否需要更新？"),
                      actions: <Widget>[
                        new FlatButton(
                          child: new Text("取消"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        new FlatButton(
                          child: new Text("确定"),
                          onPressed: () {
                            Navigator.of(context).pop();
                            downloadApk(checkUpdateBeen.downloadUrl);
                          },
                        )
                      ]);
                });
          } else {
            SnackBarUtil.show(context, "当前暂无新版本");
          }
        });
      },
    );
  }

  int _progress = 0;

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

    print(
        "完整的路径是：${downloadsDirectory.path + downloadUrl.substring(downloadUrl.lastIndexOf("/"))}");

    showDialog(
        context: context,
        builder: (context) {
          return _ProgressDialog(
              taskId,
              downloadsDirectory.path +
                  downloadUrl.substring(downloadUrl.lastIndexOf("/")));
        });
  }
}

class _ProgressDialog extends Dialog {
  String _taskId = "";
  String filePath = "";

  _ProgressDialog(this._taskId, this.filePath);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Material(
        type: MaterialType.transparency,
        child: _MyDialog(_taskId, filePath),
      ),
    );
  }
}

class _MyDialog extends StatefulWidget {
  int _progress = 0;
  String _taskId = "";
  String filePath = "";

  _MyDialog(this._taskId, this.filePath);

  @override
  _MyDialogState createState() {
    return _MyDialogState();
  }
}

class _MyDialogState extends State<_MyDialog> {
  @override
  void initState() {
    FlutterDownloader.registerCallback(
        (String id, DownloadTaskStatus status, int progress) {
      // code to update your UI
      print(progress);
      if (id == widget._taskId) {
        setState(() {
          widget._progress = progress;
        });
      }
      if (status == DownloadTaskStatus.complete) {
        checkPermissionAndInstall(widget.filePath);
        Navigator.pop(context);
      }
    });
    super.initState();
  }

  Future<bool> _getFileWritePermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permission != PermissionStatus.granted) {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.storage]);
      if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
        //安装应用
        return true;
      } else {
        //没有权限
        return false;
      }
    } else {
      return true;
    }
  }

  void checkPermissionAndInstall(String path) {
    _getFileWritePermission().then((hasPermission) {
      if (hasPermission) {
        installApk(path);
      } else {
        ToastUtil.showToast("请打开所需权限后重试...");
      }
    });
  }

  void installApk(String path) {
    InstallPlugin.installApk(path, 'com.example.fluttershareposts')
        .then((result) {
      print('install apk $result');
    }).catchError((error) {
      print('install apk error: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new CircularPercentIndicator(
          radius: 120.0,
          lineWidth: 13.0,
          animation: false,
          percent: widget._progress * 1.0 / 100,
          center: new Text(
            "${widget._progress}%",
            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
//          footer: new Text(
//            "Downloading...",
//            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
//          ),
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: Colors.purple,
        ),
        SizedBox(
          height: 10.0,
        ),
        RaisedButton(
          onPressed: () {
            //取消
            Navigator.pop(context);
            FlutterDownloader.cancel(taskId: widget._taskId);
          },
          child: Text("取消"),
        )
      ],
    ));
  }

  void setProgress(int progress) {
//    setState(() {
//      widget._progress = progress;
//    });
  }
}
