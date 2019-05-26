import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_mini_app/util/const_util.dart';
import 'package:my_mini_app/util/toast_util.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatelessWidget {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  final String _title;

  final String _initialUrl;

  WebViewController _webViewController;

  WebViewPage(this._title, this._initialUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            title: Text(_title),
            centerTitle: true,
          ),
          preferredSize: Size.fromHeight(APPBAR_HEIGHT)),
      body: WebView(
        initialUrl: _initialUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
          _webViewController = webViewController;
        },
        javascriptChannels: <JavascriptChannel>[
          _toasterJavascriptChannel(context),
        ].toSet(),
        onPageFinished: (String url) {
          print('Page finished loadingHHH: $url');
        },
      ),
      bottomNavigationBar: Container(
        height: 45.0,
        decoration: BoxDecoration(
            border: Border(
          top: BorderSide(color: Colors.black38, width: 0.0),
        )),
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: InkWell(
                child: LayoutBuilder(builder: (context, constraint) {
                  return Container(
                    height: constraint.biggest.height,
                    width: 350,
                    child: Icon(
                      Icons.arrow_back,
                    ),
                  );
                }),
                onTap: () {
                  _webViewController.canGoBack().then((bool canGoBack) {
                    if (canGoBack) {
                      _webViewController.goBack();
                    }
                  });
                },
              ),
            ),
            Flexible(
              flex: 1,
              child: InkWell(
                child: LayoutBuilder(builder: (context, constraint) {
                  return Container(
                    height: constraint.biggest.height,
                    width: 350,
                    child: Icon(
                      Icons.arrow_forward,
                    ),
                  );
                }),
                onTap: () {
                  _webViewController.canGoForward().then((bool canGoForward) {
                    if (canGoForward) {
                      _webViewController.goForward();
                    }
                  });
                },
              ),
            ),
            Flexible(
              flex: 1,
              child: InkWell(
                child: LayoutBuilder(builder: (context, constraint) {
                  return Container(
                    height: constraint.biggest.height,
                    width: 350,
                    child: Icon(
                      Icons.refresh,
                    ),
                  );
                }),
                onTap: () {
                  _webViewController.reload();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          print("message");
          ToastUtil.showToast(message.message);
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}
