import 'package:flutter/material.dart';
import 'package:flutter_showdown/pages/pokedex/pokedex.dart';
import 'package:flutter_showdown/pages/rooms/rooms_screen.dart';
import 'package:flutter_showdown/presentation/custom_icons_icons.dart';
import 'package:flutter_showdown/startup.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _closed = false;
  int _selectedIndex = 0;
  List<Widget> screens;

  void _onItemTapped(int index) {
    if (!_closed) {
      setState(() => _selectedIndex = index);
    }
  }

  @override
  void initState() {
    super.initState();

    screens = [
      RoomsScreen(onChatChange: () => setState(() => _closed = !_closed)),
      Pokedex(),
      const Center(child: Text('Home')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Startup(
      child: Scaffold(
        body: Stack(
          children: [
            FractionallySizedBox(
              widthFactor: 1,
              child: screens[_selectedIndex],
            ),
            AnimatedPositioned(
              bottom: _closed ? -56 : 0,
              duration: const Duration(milliseconds: 300),
              width: MediaQuery.of(context).size.width,
              child: BottomNavigationBar(
                onTap: _onItemTapped,
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.amber[800],
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
