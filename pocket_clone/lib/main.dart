import 'dart:convert';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

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
        String title = documents[index].data['title'].toString();
        String website = documents[index].data['website'].toString();
        
        return ArticleListItem(title, website);
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
  Uri url = Uri.http('3439407f39d4.ngrok.io', '/save', {'url': articleUrl});
  var response = await http.get(url);
  Map data = jsonDecode(response.body);
  return data;   
}

  // renderArticle(){
  //   var data;
  //   if (article != null){
  //     data = article['title'];
  //   }   
  //   else{
  //     data = '';
  //   }
  //   return Html(
  //       data: data
  //       );
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('My app!'),
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
              setState(() {
              article = fetchedArticle;
              });
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

  final Decoration containerDecoration = BoxDecoration(
    border: Border(
      bottom: BorderSide(
        color: Colors.grey,
        width: 1),
      )
      );

  ArticleListItem(this.articleTitle, this.websiteName);

  @override
  Widget build(BuildContext context) {
    return Container(
            child: ListTile(
              title: Text(articleTitle),
              trailing: Icon(Icons.more_horiz, size: 34,),
              contentPadding: EdgeInsets.all(5),
              subtitle: Text(websiteName),
          ),

          margin: EdgeInsets.symmetric(horizontal: 15),
          decoration: containerDecoration
          );
    
  }
}
