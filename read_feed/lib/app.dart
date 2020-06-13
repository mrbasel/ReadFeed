import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'screens/home_screen.dart';
import 'screens/explore_screen.dart';
import 'models/models.dart';

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  int currentIndex = 0;
  final tabs = [HomeScreen(), ExploreScreen()];

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppBarModel>(
        model: AppBarModel(),
        child: Scaffold(
          body: IndexedStack(
            index: currentIndex,
            children: <Widget>[HomeScreen(), ExploreScreen()],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            items: [
              BottomNavigationBarItem(
                  title: Text('Home'), icon: Icon(Icons.home)),
              BottomNavigationBarItem(
                  title: Text('Explore'), icon: Icon(Icons.explore)),
            ],
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ));
  }
}
