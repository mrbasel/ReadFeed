import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';


// class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
//     CustomAppBar({Key key, this.webView}) : preferredSize = Size.fromHeight(kToolbarHeight), super(key: key);

//     @override
//     final Size preferredSize; // default is 56.0

//   InAppWebViewController webView;
  
//     @override
//     _CustomAppBarState createState() => _CustomAppBarState(webView);
// }

// class _CustomAppBarState extends State<CustomAppBar> {
//   InAppWebViewController webView;
//   Color backButtonColor = Colors.white;
//   Color forwardButtonColor = Colors.white;


//   _CustomAppBarState(this.webView);

//     @override
//     Widget build(BuildContext context) {
//         return AppBar(
//         title: Text('ReadFeed'),
//         backgroundColor: Colors.deepOrange,
//         actions: <Widget>[
//     IconButton(
//       icon: Icon(Icons.refresh,), 
//       onPressed: (){
//         webView.reload();
//       }
//       ),
//     IconButton(
//       icon: Icon(Icons.arrow_back,), 
//       onPressed: (){
//         webView.goBack();
//       }
//       ),
//     IconButton(
//       icon: Icon(Icons.arrow_forward,), 
//       onPressed: (){
//         webView.goForward();
//       }
//       )
//   ],
//       );
//     }
// }


AppBar mainAppBar = 
  AppBar(
        title: Text('ReadFeed'),
        backgroundColor: Colors.deepOrange,
      );



AppBar getAppBar(webView) {
  return AppBar(
  title: Text('ReadFeed'),
  backgroundColor: Colors.deepOrange,
  actions: <Widget>[
    IconButton(
      icon: Icon(Icons.refresh,), 
      onPressed: (){
        webView.reload();
      }
      ),
    IconButton(
      icon: Icon(Icons.arrow_back,), 
      onPressed: (){
        webView.goBack();
      }
      ),
    IconButton(
      icon: Icon(Icons.arrow_forward,), 
      onPressed: (){
        webView.goForward();
      }
      )
  ],
);
}