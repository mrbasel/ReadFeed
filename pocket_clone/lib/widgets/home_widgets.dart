import 'package:flutter/services.dart';

import '../services/firestore.dart';
import '../services/api.dart';
import '../utils/helpers.dart';
import 'main_widgets.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
          stream: Firestore.instance.collection('articles').snapshots(),
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
        String website = documents[index].data['website'].toString();
        String articleHtml = documents[index].data['article_html'].toString();
        String articleUrl = documents[index].data['url'].toString();
        
        return ArticleListItem(articleTitle: title, id: id, websiteName: website, articleHtml: articleHtml, url: articleUrl);
      }
      );
  }
}


class ArticleListItem extends StatelessWidget {
  final String websiteName;
  final String articleTitle;
  final String id;
  final String articleHtml;
  final String url;

  final Decoration containerDecoration = BoxDecoration(
    border: Border(
      bottom: BorderSide(
        color: Colors.grey,
        width: 1
        ),
      )
      );

  ArticleListItem({this.id, this.articleTitle, this.websiteName, this.articleHtml, this.url});

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
              subtitle: Text(websiteName),
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

  ArticlePage({this.articleUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar,
      body: ArticleWebView(articleUrl)
    );
  }
}


// Renders given url in a browser
class ArticleWebView extends StatefulWidget {
  final String articleUrl;

  ArticleWebView(this.articleUrl);

  @override
  ArticleWebViewState createState() => ArticleWebViewState(articleUrl);
}

class ArticleWebViewState extends State<ArticleWebView> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  final String articleUrl;

  ArticleWebViewState(this.articleUrl);
  
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
