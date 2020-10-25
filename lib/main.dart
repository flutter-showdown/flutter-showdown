import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_showdown/providers/room_messages.dart';
import 'package:flutter_showdown/providers/websockets.dart';
import 'package:provider/provider.dart';

import 'package:flutter_showdown/pages/pokedex/pokedex.dart';
import 'package:flutter_showdown/presentation/custom_icons_icons.dart';
import 'pages/home/home.dart';
import 'pages/rooms/rooms.dart';

void main() {
  sockets.initCommunication();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RoomMessages()),
      ],
      child: MyApp(),
    ),
  );
}

/// This is the main application widget.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: <Widget>[
          Rooms(),
          Pokedex(),
          const Home(),
        ],
        index: _selectedIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.battle),
            label: 'Arena',
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.pokeball),
            label: 'Pokedex',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
