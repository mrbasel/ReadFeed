import 'package:cloud_firestore/cloud_firestore.dart';


// Adds article to firestore
void addArticle(article){
  Firestore.instance.runTransaction((transaction) async {
    CollectionReference reference = Firestore.instance.collection('articles');

    Map<String, dynamic> data = {'title': article['title'], 'website': article['url'], 'article_html': article['text'], 'url': article['url']};
    await reference.add(data);
      }
    );
}

// Delete article from firestore
void deleteArticle(String documentId){
  Firestore.instance.runTransaction((transaction) async {
    CollectionReference reference = Firestore.instance.collection('articles');

    await reference.document(documentId).delete();
  }
  );
}

