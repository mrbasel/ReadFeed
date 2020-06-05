import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'dart:async';


class ArticlePage extends StatelessWidget {
  final String articleUrl;
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  ArticlePage({this.articleUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Article Reader'),
        backgroundColor: Colors.deepOrange,
        actions: <Widget>[
          NavigationControls(_controller.future)
        ],
      ),
      body: ArticleWebView(articleUrl, _controller),
    );
  }
}


// Renders given url in a browser
class ArticleWebView extends StatefulWidget {
  final String articleUrl;
  final Completer<WebViewController> _controller;

  ArticleWebView(this.articleUrl, this._controller);

  @override
  ArticleWebViewState createState() => ArticleWebViewState(articleUrl, _controller);
}

class ArticleWebViewState extends State<ArticleWebView> {
  final Completer<WebViewController> _controller;
  final String articleUrl;

  ArticleWebViewState(this.articleUrl, this._controller);
  
  @override
  Widget build(BuildContext context) {
    return WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: articleUrl,
        onWebViewCreated: (WebViewController webViewController){
        _controller.complete(webViewController);
        },
      );
  }
}


class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture) : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady = snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;

        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: !webViewReady ? null : () => navigate(context, controller, goBack: true),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: !webViewReady ? null : () => navigate(context, controller, goBack: false),
            ),
          ],
        );
      },
    );
  }

  navigate(BuildContext context, WebViewController controller,
      {bool goBack: false}) async {
    bool canNavigate =
        goBack ? await controller.canGoBack() : await controller.canGoForward();
    if (canNavigate) {
      goBack ? controller.goBack() : controller.goForward();
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
            content: Text("No ${goBack ? 'back' : 'forward'} history item")),
      );
    }
  }
}



