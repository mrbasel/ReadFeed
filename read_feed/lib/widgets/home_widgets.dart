import 'package:flutter/services.dart';

import '../utils/helpers.dart';
import '../widgets/webview_widgets.dart';
import '../models/models.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';



class AddArticleButton extends StatelessWidget {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Positioned(
          child: FloatingActionButton(
          onPressed: () async{
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context){
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
                         }
                        ),
                    
                  ],
            );
              } 
              );
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

class ArticlesListView extends StatelessWidget {
  final List<DocumentSnapshot> documents;

  ArticlesListView({this.documents});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: documents.length,
      itemBuilder: (BuildContext context, int index){
        String id = documents[index].documentID;
        String title = documents[index].data['title'].toString();
        String domain = documents[index].data['domain'].toString();
        String articleUrl = documents[index].data['url'].toString();

        Article article = Article(
          id: id,
          title: title,
          url: articleUrl,
          domain: domain,
        );
        
        return ArticleListItem(article: article);
      }
      );
  }
}


class ArticleListItem extends StatelessWidget {
  final Article article;

  final Decoration containerDecoration = BoxDecoration(
    border: Border(
      bottom: BorderSide(
        color: Colors.grey,
        width: 1
        ),
      )
      );

  ArticleListItem({this.article});

  getImage(){
    Image image; 
    try {
      image = Image.network(article.image);
    
    } catch (e) {
      return SizedBox.shrink();
    }
    return image;
  }

  showOptionsAppBar(){
  }

  @override
  Widget build(BuildContext context) {
    return Container(
            child: ListTile(
              title: Text(article.title),
              trailing: getImage(),
              onLongPress: () => print('Long press!'),
              // TODO: Implement options menu
              
              // ListTile options menu
              // trailing: PopupMenuButton(
              //   onSelected: (choice) => articlePopupChoice(choice: choice, article: article, context: context),
              //   itemBuilder: (BuildContext context ){
              //     return [
              //       PopupMenuItem(
              //         child: Text('Delete', style: TextStyle(color: Colors.red ),),
              //         value: 'delete',
              //         ),
              //         PopupMenuItem(
              //         child: Text('Share'),
              //         value: 'share',
              //         ),
              //     ];
              //   },
              //   ),
              contentPadding: EdgeInsets.all(5),
              subtitle: Text(article.domain),
              onTap: (){
                Navigator.push(context, 
                MaterialPageRoute(
                  builder: (context) => ArticleWebView(article.url,)
                )
                );
              },
          ),

          margin: EdgeInsets.symmetric(horizontal: 15),
          decoration: containerDecoration
          );
    
  }
}



// This displays a snackbar when the user enters the app
// to save copied url 
class ClipBoardSnackBar extends StatefulWidget {
  @override
  ClipBoardSnackBarState createState() => ClipBoardSnackBarState();
}

class ClipBoardSnackBarState extends State<ClipBoardSnackBar> {

  @override
  void initState() {
    super.initState();
    
    // runs once when the widget gets loaded into the widget tree
    WidgetsBinding.instance
        .addPostFrameCallback((_) => showFlushBar('save', save: true));

    }

void showFlushBar(String message, {bool save}){
  Flushbar(
      message: 'Save copied Url?',
      mainButton: FlatButton(
       child: Text('Save', style: TextStyle(color: Colors.white),),
        onPressed: () async {
          if (save == true){
          // Get link from keyboard
          var clipBoardData = await Clipboard.getData('text/plain');
          String clipBoardText = clipBoardData.text; 
          
          // Save link/article
          saveArticle(url: clipBoardText);
          }
        },
        ),
      duration: Duration(seconds: 4),
      )..show(context);
    }

  Widget build(BuildContext context) {
    return Container(
    );
  }
}