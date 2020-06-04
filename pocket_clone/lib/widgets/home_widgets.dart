// import 'package:flutter/services.dart';

import 'package:flutter/services.dart';

import '../services/firestore.dart';
import '../services/api.dart';
import '../utils/helpers.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flushbar/flushbar.dart';

import 'dart:async';


class AddArticleButton extends StatelessWidget {
  final controller = TextEditingController();

  saveArticle() async{
    String articleUrl = controller.text;
    
    // fetch article data from api
    Map fetchedArticle = await getArticle(articleUrl);
    controller.clear();

    // Add article to database
    addArticle(fetchedArticle);
    }

  @override
  Widget build(BuildContext context) {
    return Positioned(
          child: FloatingActionButton(
          onPressed: () async{
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context){
                return AlertDialog(
                  title: Text("Add Article"),
                  content: Container(
                    margin: EdgeInsets.all(20),
                    child: TextField(
                    controller: controller,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Enter url',
                  ),
          ),
          ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Save'),
                      color: Colors.blueAccent,
                      onPressed: () {
                        Navigator.pop(context);
                        return saveArticle();
                         }
                        ),
                    
                  ],
            );
              } 
              );
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blueAccent,
          hoverColor: Colors.blue,
          tooltip: 'Save an article',
          ),
          bottom:30,
          left: 20,
         );
  }
}


class ArticlesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            child: Text('Saved Articles',
          style: TextStyle(
            fontSize: 28,
          ),
          textAlign: TextAlign.center,
          ),
          margin: EdgeInsets.only(top: 20, bottom: 15),
          ),
          
        StreamBuilder(
          stream: Firestore.instance.collection('articles').orderBy('time', descending: true).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
              return ArticlesListView(documents: snapshot.data.documents);
        }
        )

      ],
      );
  }
}

class ArticlesListView extends StatelessWidget {
  final List<DocumentSnapshot> documents;

  ArticlesListView({this.documents});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: documents.length,
      itemBuilder: (BuildContext context, int index){
        String id = documents[index].documentID;
        String title = documents[index].data['title'].toString();
        String domain = documents[index].data['domain'].toString();
        String articleUrl = documents[index].data['url'].toString();
        
        return ArticleListItem(articleTitle: title, id: id, domain: domain, url: articleUrl);
      }
      );
  }
}


class ArticleListItem extends StatelessWidget {
  final String articleTitle;
  final String id;
  final String domain;
  final String url;

  final Decoration containerDecoration = BoxDecoration(
    border: Border(
      bottom: BorderSide(
        color: Colors.grey,
        width: 1
        ),
      )
      );

  ArticleListItem({this.id, this.articleTitle, this.domain, this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
            child: ListTile(
              title: Text(articleTitle),
              trailing: PopupMenuButton(
                onSelected: (value) => articlePopupChoice(value, url, documentId: id),
                itemBuilder: (BuildContext context ){
                  return [
                    PopupMenuItem(
                      child: Text('Delete', style: TextStyle(color: Colors.red ),),
                      value: 'delete',
                      ),
                      PopupMenuItem(
                      child: Text('Share'),
                      value: 'share',
                      ),
                  ];
                },
                ),
              contentPadding: EdgeInsets.all(5),
              subtitle: Text(domain),
              onTap: (){
                Navigator.push(context, 
                MaterialPageRoute(
                  builder: (context) => ArticlePage(articleUrl: url,)
                )
                );
              },
          ),

          margin: EdgeInsets.symmetric(horizontal: 15),
          decoration: containerDecoration
          );
    
  }
}


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




// This displays a snackbar when the user enters the app
// to save copied url 
class ClipBoardSnackBar extends StatefulWidget {
  @override
  ClipBoardSnackBarState createState() => ClipBoardSnackBarState();
}

class ClipBoardSnackBarState extends State<ClipBoardSnackBar> {

  @override
  void initState() {
    super.initState();
    
    // runs once when the widget gets loaded into the widget tree
    WidgetsBinding.instance
        .addPostFrameCallback((_) => showFlushBar('save', save: true));

    }

void showFlushBar(String message, {bool save}){
  Flushbar(
      message: 'Save copied Url?',
      mainButton: FlatButton(
       child: Text('Save', style: TextStyle(color: Colors.white),),
        onPressed: () async {
          if (save == true){
          // Get link from keyboard
          var clipBoardData = await Clipboard.getData('text/plain');
          String clipBoardText = clipBoardData.text; 
          
          // Save link/article
          var article = await getArticle(clipBoardText);
          addArticle(article);
          }
        },
        ),
      duration: Duration(seconds: 4),
      )..show(context);
    }

  Widget build(BuildContext context) {
    return Container(
    );
  }
}