import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/services.dart';

import 'save_article.dart';

// This displays a snackbar when the user enters the app
// to save copied url
// class ClipBoardSnackBar extends StatefulWidget {
//   @override
//   ClipBoardSnackBarState createState() => ClipBoardSnackBarState();
// }

// class ClipBoardSnackBarState extends State<ClipBoardSnackBar> {

//   @override
//   void initState() {
//     super.initState();

//     // runs once when the widget gets loaded into the widget tree
//     WidgetsBinding.instance
//         .addPostFrameCallback((_) => showFlushBar(message:'save', save: true));

//     }

// void showFlushBar({@required String message, bool save}){
//   Flushbar(
//       message: message,
//       mainButton: FlatButton(
//        child: Text('Save', style: TextStyle(color: Colors.white),),
//         onPressed: () async {
//           if (save == true){
//           // Get link from keyboard
//           var clipBoardData = await Clipboard.getData('text/plain');
//           String clipBoardText = clipBoardData.text;

//           // Save link/article
//           saveArticle(url: clipBoardText);
//           }
//         },
//         ),
//       duration: Duration(seconds: 4),
//       )..show(context);
//     }

//   Widget build(BuildContext context) {
//     return Container(
//     );
//   }
// }

showFlushBar({String message, @required context, Widget button, Duration duration}) {
  return Flushbar(
    message: message,
    duration: duration ?? Duration(seconds: 3),
    mainButton: button,
  )..show(context);
}

