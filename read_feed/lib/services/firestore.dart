import 'package:cloud_firestore/cloud_firestore.dart';

// Adds article to firestore
void addArticle(article) {
  Firestore.instance.runTransaction((transaction) async {
    CollectionReference reference = Firestore.instance.collection('articles');
    Map<String, dynamic> data = {
      'title': article['title'],
      'domain': article['domain'],
      'url': article['url'],
      'image': article['image'],
      'time': Timestamp.now()
    };
    await reference.add(data);
  });
}

// Delete article from firestore
void deleteArticle(String documentId) {
  Firestore.instance.runTransaction((transaction) async {
    CollectionReference reference = Firestore.instance.collection('articles');

    await reference.document(documentId).delete();
  });
}
