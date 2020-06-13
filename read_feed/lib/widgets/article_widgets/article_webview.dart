import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:ReadFeed/widgets/appbar_widgets.dart';


class ArticleWebView extends StatefulWidget {
  final String url;

  ArticleWebView(this.url);

  @override
  _ArticleWebViewState createState() => _ArticleWebViewState(url);
}

class _ArticleWebViewState extends State<ArticleWebView> {
  final String url;
  InAppWebViewController webView;
  dynamic appBar = MainAppBar();

  _ArticleWebViewState(this.url);

AppBar getAppBar({webView, Color color, String title}) {
  return AppBar(
  title: Text(title ?? 'ReadFeed'),
  backgroundColor: color,
  actions: <Widget>[
    IconButton(
      icon: Icon(Icons.refresh,), 
      onPressed: (){
        webView.reload();
      }
      ),
    IconButton(
      icon: Icon(Icons.arrow_back,), 
      onPressed: (){
        webView.goBack();
      }
      ),
    IconButton(
      icon: Icon(Icons.arrow_forward,), 
      onPressed: (){
        webView.goForward();
      }
      )
  ],
);
}

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
           appBar = getAppBar(webView: webView);
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