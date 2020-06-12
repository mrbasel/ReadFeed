import 'package:flutter/material.dart';

import 'package:ReadFeed/models/models.dart';
import 'article_webview.dart';




class ArticleListItem extends StatelessWidget {
  final Article article;
  final Function callbackFunction;
  final bool isSelected;

  final Decoration containerDecoration = BoxDecoration(
    border: Border(
      bottom: BorderSide(
        color: Colors.grey,
        width: 1
        ),
      )
      );

  ArticleListItem({this.article, this.callbackFunction, this.isSelected});

  getImage(){
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
            child: ListTile(
              title: Text(article.title),
              selected: isSelected ?? false,
              trailing: getImage(),
              onLongPress: () {
              // TODO: Change ListTile's color here
                callbackFunction();

              },
              contentPadding: EdgeInsets.all(5),
              subtitle: Text(article.domain),
              onTap: (){
                Navigator.push(context, 
                MaterialPageRoute(
                  builder: (context) => ArticleWebView(article.url,)
                )
                );
              },
          ),

          margin: EdgeInsets.symmetric(horizontal: 15),
          decoration: containerDecoration
          );
    
  }
}
