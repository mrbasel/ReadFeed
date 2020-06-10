import 'package:flutter/material.dart';


class Destination {
  const Destination(this.title, this.icon, this.color);
  final String title;
  final IconData icon;
  final MaterialColor color;
}

const List<Destination> allDestinations = <Destination>[
  Destination('Home', Icons.home, Colors.teal),
  Destination('Business', Icons.business, Colors.cyan),
  Destination('School', Icons.school, Colors.orange),
  Destination('Flight', Icons.flight, Colors.blue)
];


class DestinationView extends StatefulWidget {
  const DestinationView({ Key key, this.destination }) : super(key: key);

  final Destination destination;

  @override
  _DestinationViewState createState() => _DestinationViewState();
}

class _DestinationViewState extends State<DestinationView> {
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: 'sample text: ${widget.destination.title}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.destination.title} Text'),
        backgroundColor: widget.destination.color,
      ),
      backgroundColor: widget.destination.color[100],
      body: Container(
        padding: const EdgeInsets.all(32.0),
        alignment: Alignment.center,
        child: TextField(controller: _textController),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

}


class HomePageTest extends StatefulWidget {
  @override
  _HomePageTestState createState() => _HomePageTestState();
}

class _HomePageTestState extends State<HomePageTest> with TickerProviderStateMixin<HomePageTest> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
        IndexedStack(
          index: _currentIndex,
          children: <Widget>[
            DestinationView(destination: allDestinations[0]),
            DestinationView(destination: allDestinations[1]),
            DestinationView(destination: allDestinations[2]),
            DestinationView(destination: allDestinations[3]),

          ],
          // children: allDestinations.map<Widget>((Destination destination) {
          //   return DestinationView(destination: destination);
          // }).toList(),
        ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: allDestinations.map((Destination destination) {
          return BottomNavigationBarItem(
            icon: Icon(destination.icon),
            backgroundColor: destination.color,
            title: Text(destination.title)
          );
        }).toList(),
      ),
    );
  }
}
