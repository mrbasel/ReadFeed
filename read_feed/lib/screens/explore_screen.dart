import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';

import 'dart:convert';

import 'package:ReadFeed/models/models.dart';
import '../widgets/appbar_widgets.dart';
import 'package:ReadFeed/widgets/article_widgets/article_item.dart';
import 'package:ReadFeed/widgets/appbar_options_widgets/option_widgets.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<Article> articlesList = [];
  var data;
  var currentAppBar;

  @override
  void initState() {
    super.initState();
    data = getArticles();
    currentAppBar = MainAppBar();
  }

  getArticles() async {
    Uri url = Uri.http('read-feed-api.herokuapp.com', '/get_articles');
    var r = await http.get(url);
    var body = jsonDecode(r.body);

    for (var article in body['articles']) {
      articlesList.add(Article(
          title: article['title'].split('-')[0],
          url: article['url'],
          domain: article['source']['name'],
          image: article['urlToImage']));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppBarModel>(builder: (context, _, model) {
      return Scaffold(
        appBar: model.isSelected
            ? OptionsAppBar(
                optionButton: SaveIcon(model: model),
              )
            : currentAppBar,
        body: Container(
            child: FutureBuilder(
                future: data,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                        itemCount: articlesList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ArticleListItem(
                            article: articlesList[index],
                          );
                        });
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
            margin: EdgeInsets.symmetric(vertical: 15, horizontal: 0)),
      );
    });
  }
}
