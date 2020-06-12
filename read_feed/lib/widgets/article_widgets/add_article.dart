import 'package:flutter/material.dart';

import 'package:ReadFeed/utils/save_article.dart';

class AddArticleButton extends StatelessWidget {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: FloatingActionButton(
        onPressed: () async {
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Add Article"),
                  content: Container(
                    margin: EdgeInsets.all(20),
                    child: TextField(
                      controller: controller,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Enter url',
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                        child: Text('Save'),
                        color: Colors.blueAccent,
                        onPressed: () {
                          Navigator.pop(context);
                          return saveArticle(controller: controller);
                        }),
                  ],
                );
              });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
        hoverColor: Colors.blue,
        tooltip: 'Save an article',
      ),
      bottom: 40,
      right: 20,
    );
  }
}
