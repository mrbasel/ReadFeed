import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:ReadFeed/widgets/article_widgets/add_article.dart';
import 'package:ReadFeed/widgets/article_widgets/article_stream.dart';
import 'package:ReadFeed/models/models.dart';
import 'package:ReadFeed/widgets/appbar_widgets.dart';


class HomeScreen extends StatelessWidget {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppBarModel>(
        builder: (context, _, model) => Scaffold(
            appBar: model.isSelected ? OptionsAppBar() : MainAppBar() ,
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
            )));
  }
}
