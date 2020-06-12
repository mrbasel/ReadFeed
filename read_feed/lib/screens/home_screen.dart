import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ReadFeed/widgets/article_widgets/add_article.dart';
import 'package:ReadFeed/widgets/article_widgets/article_stream.dart';



class HomeScreen extends StatelessWidget {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List'),
      ),
      body: Stack(
      children: <Widget>[
        ListView(
          children: <Widget>[
        ArticlesStream(),
        ],
        ),
        
        // Floating button for saving articles
        AddArticleButton(),
        // ClipBoardSnackBar(),
      ],
    )  

    );
  }
}