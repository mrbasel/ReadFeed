import 'package:flutter/material.dart';
import 'package:pocket_clone/widgets/main_widgets.dart';

import 'screens/home_screen.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar,
      body: HomeScreen(),
    );
  }
}


