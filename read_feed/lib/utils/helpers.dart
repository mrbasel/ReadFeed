import 'package:flutter/material.dart';
import 'package:ReadFeed/models/models.dart';
import 'package:share/share.dart';
import '../services/firestore.dart';
import '../services/api.dart';

import 'package:flushbar/flushbar.dart';


// Options menu
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

// Gets data(url) from input field
saveArticle({controller, url}) async{
  String articleUrl;
  
  if (controller != null){
    articleUrl = controller.text;
    controller.clear();

  }
  else {
    articleUrl = url;
  }

    
    // fetch article data from api
    Map fetchedArticle = await getArticle(articleUrl);

    // Add article to database
    addArticle(fetchedArticle);
    }
