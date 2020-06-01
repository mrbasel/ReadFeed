import 'package:share/share.dart';
import '../services/firestore.dart';


articlePopupChoice(String choice, String link, {String documentId}){
  if (choice == 'share') return Share.share(link);
  
  else if (choice == 'delete') {
    deleteArticle(documentId);
}
}

