import 'package:flutter/material.dart';


class AppBarWidgets {
  static AppBar mainAppBar = AppBar(
    title: Text('News'),
  );
  
  static AppBar optionsAppBar = AppBar(
    backgroundColor: Colors.blueAccent[100],
    actions: <Widget>[
      IconButton(icon: Icon(Icons.delete), onPressed: () => print('Delete')),
      PopupMenuButton(  
        onSelected: (choice) => print(choice),
      itemBuilder: (BuildContext context ){
          return [
            PopupMenuItem(
              child: Text('Delete', style: TextStyle(color: Colors.red ),),
            value: 'delete',
            ),
            PopupMenuItem(
              child: Text('Share'),
            value: 'share',
            ),
        ];
      },
      ),
    ],
    leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => print('back'), color: Colors.white,),
  );
}



class OptionsAppBar extends StatefulWidget implements PreferredSizeWidget {
    OptionsAppBar({Key key, this.callBackFunction}) : preferredSize = Size.fromHeight(kToolbarHeight), super(key: key);

    @override
    final Size preferredSize; // default is 56.0

    final Function callBackFunction;
  
  
    @override
    _OptionsAppBarState createState() => _OptionsAppBarState();
}

 class _OptionsAppBarState extends State<OptionsAppBar> {
   Color backButtonColor = Colors.white;
   Color forwardButtonColor = Colors.white;
   

     @override
     Widget build(BuildContext context) {
       return AppBar(
    backgroundColor: Colors.blueAccent[100],
    actions: <Widget>[
      IconButton(icon: Icon(Icons.delete), onPressed: () => print('Delete')),
      PopupMenuButton(  
        onSelected: (choice) => print(choice),
      itemBuilder: (BuildContext context ){
          return [
            PopupMenuItem(
              child: Text('Delete', style: TextStyle(color: Colors.red ),),
            value: 'delete',
            ),
            PopupMenuItem(
              child: Text('Share'),
            value: 'share',
            ),
        ];
      },
      ),
    ],
    leading: IconButton(icon: Icon(Icons.arrow_back), color: Colors.white, onPressed: () => widget.callBackFunction()),
  );
     }
 }