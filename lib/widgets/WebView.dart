/*
 * @Author: your name
 * @Date: 2021-08-09 18:02:31
 * @LastEditTime: 2021-08-13 17:23:51
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /Rocks_Flutter/lib/widgets/WebView.dart
 */
import 'dart:async';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hdec_flutter/pages/medeia/LoadingPage.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class MyWebView extends StatefulWidget {
  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<MyWebView> {
  String url = Get.arguments['url'];
  String title = Get.arguments['title'] ?? '内容详情';
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? Scaffold(
            appBar: AppBar(
              title: Text(title),
              leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back_ios)),
              // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
            ),
            // We're using a Builder here so we have a context that is below the Scaffold
            // to allow calling Scaffold.of(context) so we can show a snackbar.
            body: Builder(builder: (BuildContext context) {
              return WebView(
                initialUrl: url,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
                onProgress: (int progress) {
                  LoadingPage();
                },
                onPageStarted: (String url) {
                  print('Page started loading: $url');
                },
                onPageFinished: (String url) {
                  print('Page finished loading: $url');
                },
                gestureNavigationEnabled: true,
              );
            }),
          )
        : Platform.isAndroid
            ? WebviewScaffold(
                url: url,
                mediaPlaybackRequiresUserGesture: false,
                appBar: AppBar(
                  title: Text(title),
                ),
                withZoom: true,
                withLocalStorage: true,
                hidden: true,
                initialChild: Container(child: LoadingPage()),
              )
            : Container();
  }
}
