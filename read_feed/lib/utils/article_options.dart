import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:flushbar/flushbar.dart';

import 'package:ReadFeed/models/models.dart';
import 'package:ReadFeed/services/firestore.dart';
import 'save_article.dart';


articlePopupChoice({String choice, Article article, context}){
  if (choice == 'share') return Share.share(article.url);
  
  else if (choice == 'delete') {
    deleteArticle(article.id);
    Flushbar(
      message: 'Article deleted',
      duration: Duration(seconds: 4),
      mainButton: FlatButton(
        child: Text('Undo',
        style: TextStyle(
          color: Colors.white
        ),
        ),
        onPressed: (){
          saveArticle(url: article.url);
        },
        ),

    )..show(context);
}
}
