import 'package:flutter/material.dart';
import 'package:my_mini_app/provider/auth_provider.dart';
import 'package:my_mini_app/util/const_util.dart';
import 'package:my_mini_app/webview/webview_page.dart';

class SettingPage extends StatelessWidget {
  static const String PAGE_NAME_OPEN_SOURCE = "开源代码";

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: _bodyWidget(context));
  }

  Widget _appBar() {
    return PreferredSize(child: AppBar(
      title: Text("设置"),
      centerTitle: true,
    ), preferredSize: Size.fromHeight(APPBAR_HEIGHT));
  }

  Widget _bodyWidget(BuildContext context) {
    return ListView.separated(itemBuilder: (context, index) {
      switch (index) {
        case 0:
          return _openSourceWidget(context);
        case 1:
          return _checkUpdateWidget();
        case 2:
          return _logoutWidget(context);
      }
    }, separatorBuilder: (context, index) => Divider(
      height: 0.0,
    ), itemCount: 3);
  }

  void _logout() async {
    AuthProvider().logout();
  }

  Widget _openSourceWidget(BuildContext context) {
    return InkWell(
      child: Container(
        height: 50.0,
        padding: EdgeInsets.only(left: 10.0),
        alignment: Alignment.centerLeft,
        child: Text(PAGE_NAME_OPEN_SOURCE),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => new WebViewPage(PAGE_NAME_OPEN_SOURCE, "https://github.com/ningyuwen/flutter_share_posts")));
      },
    );
  }

  Widget _checkUpdateWidget() {
    return InkWell(
      child: Container(
        height: 50.0,
        padding: EdgeInsets.only(left: 10.0),
        alignment: Alignment.centerLeft,
        child: Text("检查更新"),
      ),
      onTap: () {

      },
    );
  }

  Widget _logoutWidget(BuildContext context) {
    return InkWell(
      child: Container(
        height: 50.0,
        padding: EdgeInsets.only(left: 10.0),
        alignment: Alignment.centerLeft,
        child: Text("退出登录"),
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
}
