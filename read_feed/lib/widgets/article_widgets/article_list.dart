import 'package:flutter/material.dart';

import 'package:ReadFeed/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'article_item.dart';



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

        Article article = Article(
          id: id,
          title: title,
          url: articleUrl,
          domain: domain,
        );
        
        return ArticleListItem(article: article);
      }
      );
  }
}