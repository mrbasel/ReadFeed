import 'dart:async';
import 'dart:convert';

import 'helpers.dart';

import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage(),);
  }
}

class ArticlesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection('articles').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return ArticlesListView(documents: snapshot.data.documents);
        }
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


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  dynamic article;
  final controller = TextEditingController();

  getArticle(articleUrl) async{
  Uri url = Uri.http('a9d8ca92d277.ngrok.io', '/save', {'url': articleUrl});
  var response = await http.get(url);
  Map data = jsonDecode(response.body);
  return data;   
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Article Reader'),
        backgroundColor: Colors.deepOrange,
      ),
      body:
        ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(20),
            child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter url',
            ),
          ),
          ),
          Align(
            alignment: Alignment.center,
            child: FlatButton(
            child: Text('Save'),
            color: Colors.blueAccent,
            onPressed: () async{
              String articleUrl = controller.text;
              Map fetchedArticle = await getArticle(articleUrl);
              controller.clear();

              // Firestore.instance.collection('articles').add({'title': fetchedArticle['title'], 'website': fetchedArticle['url']});
              Firestore.instance.runTransaction((transaction) async {
                CollectionReference reference = Firestore.instance.collection('articles');

                await reference.add({'title': fetchedArticle['title'], 'website': fetchedArticle['url'], 'article_html': fetchedArticle['text'], 'url': fetchedArticle['url']});
              }
              );
            },
          ),
          ),
          
          Container(
            child: Text('Saved Articles',
          style: TextStyle(
            fontSize: 28,
          ),
          textAlign: TextAlign.center,
          ),
          margin: EdgeInsets.only(top: 20, bottom: 15),
          ),

          // List of saved articles
          ArticlesStream()
          ],
      ), 
          
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
        width: 1),
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
                  builder: (context) => ArticlePage(id: id, articleTitle: articleTitle, websiteName: websiteName, articleHtml: articleHtml, articleUrl: url,)
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
  final String websiteName;
  final String articleTitle;
  final String id;
  final String articleHtml;
  final String articleUrl;

  ArticlePage({this.websiteName, this.articleTitle, this.id, this.articleHtml, this.articleUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Article Reader'),
        backgroundColor: Colors.deepOrange,
      ),
      body: ArticleWebView(articleUrl)
    );
  }
}



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
        javascriptMode: JavascriptMode.unrestricted ,
        initialUrl: articleUrl,
        onWebViewCreated: (WebViewController webViewController){
          _controller.complete(webViewController);
        },
      );
  }
}
