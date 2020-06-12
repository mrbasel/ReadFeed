import 'package:ReadFeed/services/firestore.dart';
import 'package:ReadFeed/services/api.dart';


// Gets data(url) from input field
saveArticle({controller, url}) async{
  String articleUrl;
  
  if (controller != null){
    articleUrl = controller.text;
    controller.clear();

  }
  else {
    articleUrl = url;
  }

    
    // fetch article data from api
    Map fetchedArticle = await getArticle(articleUrl);

    // Add article to database
    addArticle(fetchedArticle);
    }
