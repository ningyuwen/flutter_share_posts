
import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:my_mini_app/util/const_util.dart';
import 'package:my_mini_app/util/toast_util.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatelessWidget {

  final Completer<WebViewController> _controller = Completer<WebViewController>();

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
            border: Border(top: BorderSide(color: Colors.black38, width: 0.0),)
          ),
          padding: EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0.0),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(icon: Icon(Icons.arrow_back,), padding: EdgeInsets.all(0.0), highlightColor: Colors.black, onPressed: () {
                _webViewController.canGoBack().then((bool canGoBack) {
                  if (canGoBack) {
                    _webViewController.goBack();
                  }
                });
              }),
              IconButton(icon: Icon(Icons.arrow_forward,), onPressed: () {
                _webViewController.canGoForward().then((bool canGoForward) {
                  if (canGoForward) {
                    _webViewController.goForward();
                  }
                });
              }),
              IconButton(icon: Icon(Icons.refresh,), onPressed: () {
                _webViewController.reload();
              })
            ],
          ),
        ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          ToastUtil.showToast(message.message);
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

}