import 'package:ReadFeed/widgets/main_widgets.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';


import 'dart:async';


class ArticleWebView extends StatefulWidget {
  final String url;

  ArticleWebView(this.url);

  @override
  _ArticleWebViewState createState() => _ArticleWebViewState(url);
}

class _ArticleWebViewState extends State<ArticleWebView> {
  final String url;
  InAppWebViewController webView;
  AppBar appBar = mainAppBar;

  _ArticleWebViewState(this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Container(
     child: InAppWebView(
       initialUrl: url,
       onWebViewCreated: (InAppWebViewController controller) {
         webView = controller;
         setState(() {
           appBar = getAppBar(webView);
         }
         );
       },
     )
      )
    );

    //   ),  
    // );
  }
}