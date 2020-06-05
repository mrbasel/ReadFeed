import 'package:share/share.dart';
import '../services/firestore.dart';
import '../services/api.dart';

// Options menu
articlePopupChoice({String choice, String url, String documentId}){
  if (choice == 'share') return Share.share(url);
  
  else if (choice == 'delete') {
    deleteArticle(documentId);
}
}

// Gets data(url) from input field
saveArticle({controller, url}) async{
  String articleUrl;
  
  if (controller != null){
    articleUrl = controller.text;

  }
  else {
    articleUrl = url;
  }

    
    // fetch article data from api
    Map fetchedArticle = await getArticle(articleUrl);
    controller.clear();

    // Add article to database
    addArticle(fetchedArticle);
    }
