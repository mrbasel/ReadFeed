import 'dart:convert';

import 'package:ReadFeed/models/models.dart';
import 'package:ReadFeed/widgets/home_widgets.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<Article> articlesList = [];
  var data;

  @override
  void initState(){
    super.initState();
    data = getArticles();    
  }

  getArticles() async{
    Uri url = Uri.http('read-feed-api.herokuapp.com', '/get_articles');
    var r = await http.get(url);
    var body = jsonDecode(r.body);

     for (var article in body['articles']) {
       articlesList.add(
         Article(
         title: article['title'].split('-')[0],
         url: article['url'],
         domain: article['source']['name'],
         image: article['urlToImage']
       ));
     }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: data,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if (snapshot.connectionState == ConnectionState.done){
            return ListView.builder(
              itemCount: articlesList.length,
              itemBuilder: (BuildContext context, int index){
                return ArticleListItem(article: articlesList[index]);
              }
              );
          }
          else {
            return Center(child: CircularProgressIndicator(),);
          }
        }
        ),
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 0)
      );
  }
}