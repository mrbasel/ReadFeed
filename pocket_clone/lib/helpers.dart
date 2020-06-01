import 'package:share/share.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


articlePopupChoice(String choice, String link, {String documentId}){
  if (choice == 'share') return Share.share(link);
  
  else {
    Firestore.instance.runTransaction((transaction) async {
    CollectionReference reference = Firestore.instance.collection('articles');

    await reference.document(documentId).delete();
    print('deleted!');
  }
    );
}
}

