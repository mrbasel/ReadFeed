import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'article_list.dart';



class ArticlesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            child: Text('Saved Articles',
          style: TextStyle(
            fontSize: 28,
          ),
          textAlign: TextAlign.center,
          ),
          margin: EdgeInsets.only(top: 20, bottom: 15),
          ),
          
        StreamBuilder(
          stream: Firestore.instance.collection('articles').orderBy('time', descending: true).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
              return ArticlesListView(documents: snapshot.data.documents);
        }
        )

      ],
      );
  }
}