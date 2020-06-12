import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/home_widgets.dart';



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