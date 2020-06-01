import 'package:flutter/material.dart';

import '../widgets/home_widgets.dart';


class HomeScreen extends StatelessWidget {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        AddArticleForm(controller),
        ArticlesStream()

      ],
    );
  }
}