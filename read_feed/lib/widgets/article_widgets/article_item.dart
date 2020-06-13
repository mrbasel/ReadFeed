import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:ReadFeed/models/models.dart';

import 'article_webview.dart';

class ArticleListItem extends StatelessWidget {
  final Article article;
  final Function callbackFunction;

  final Decoration containerDecoration = BoxDecoration(
      border: Border(
    bottom: BorderSide(color: Colors.grey, width: 1),
  ));

  ArticleListItem({this.article, this.callbackFunction});

  getImage() {
    Image image;
    try {
      image = Image.network(article.image);
    } catch (e) {
      return SizedBox.shrink();
    }
    return image;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ScopedModelDescendant<AppBarModel>(
            builder: (context, _, model) => ListTile(
                  title: Text(article.title),
                  selected: model.isSelected && model.selectedArticle.url == article.url ? true : false ,
                  trailing: getImage(),
                  onLongPress: () {
                    model.showOptionsAppbar(article);

                  },
                  contentPadding: EdgeInsets.all(5),
                  subtitle: Text(article.domain),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ArticleWebView(
                                  article.url,
                                )));
                  },
                )),
        margin: EdgeInsets.symmetric(horizontal: 15),
        decoration: containerDecoration);
  }
}
