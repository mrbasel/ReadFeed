import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:ReadFeed/services/firestore.dart';
import 'package:ReadFeed/utils/save_article.dart';
import 'package:ReadFeed/utils/show_flush_bar.dart';
import 'package:ReadFeed/models/models.dart';

class DeleteIcon extends StatelessWidget {
  final AppBarModel model;

  DeleteIcon({@required this.model});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          deleteArticle(model.selectedArticle.id);
          model.hideOptionsAppbar();
          showFlushBar(
              message: 'Article Deleted',
              context: context,
              button: FlatButton(
                child: Text(
                  'Undo',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  saveArticle(url: model.selectedArticle.url);
                },
              ));
        });
  }
}

class SaveIcon extends StatelessWidget {
  final AppBarModel model;

  SaveIcon({@required this.model});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.save_alt),
        onPressed: () {
          Map article = {
            'title': model.selectedArticle.title,
            'domain': model.selectedArticle.domain,
            'url': model.selectedArticle.url,
            'image': model.selectedArticle.image,
            'time': Timestamp.now()
          };
          addArticle(article);
          model.hideOptionsAppbar();
          showFlushBar(context: context, message: 'Article Saved', duration: Duration(seconds: 1, milliseconds: 500));
        });
  }
}
