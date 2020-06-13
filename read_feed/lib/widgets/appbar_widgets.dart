import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:ReadFeed/models/models.dart';
import 'package:ReadFeed/utils/article_options.dart';



class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  MainAppBar({Key key, this.title, this.color})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0
  final String title;
  final Color color;

  @override
  _MainAppBarState createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
 
  // Article selectedArticle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title ?? 'ReadFeed'),
      backgroundColor: widget.color ?? null,
    );
  }
}


class OptionsAppBar extends StatefulWidget implements PreferredSizeWidget {
  OptionsAppBar({Key key, this.callBackFunction})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  final Function callBackFunction;

  @override
  _OptionsAppBarState createState() => _OptionsAppBarState();
}

class _OptionsAppBarState extends State<OptionsAppBar> {
  Color backButtonColor = Colors.white;
  Color forwardButtonColor = Colors.white;
  // Article selectedArticle;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppBarModel>(
        builder: (context, _, model) => AppBar(
              backgroundColor: Colors.blueAccent[100],
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.delete), onPressed: () => print('Delete')),
                PopupMenuButton(
                  onSelected: (choice) {
                    articlePopupChoice(
                      choice: choice,
                      context: context,
                      article: model.selectedArticle
                      );
                      model.hideOptionsAppbar();
                    },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
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
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: Colors.white,
                  onPressed: () => model.hideOptionsAppbar()),
            ));
  }
}
