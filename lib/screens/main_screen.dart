import 'package:flutter/material.dart';
import 'package:flutter_showdown/screens/home/home_screen.dart';
import 'package:flutter_showdown/screens/pokedex/pokedex.dart';
import 'package:flutter_showdown/screens/rooms/rooms_screen.dart';
import 'package:flutter_showdown/presentation/custom_icons_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:flutter_showdown/providers/global_messages.dart';
import '../utils.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _closed = false;
  int _selectedIndex = 0;
  List<Widget> screens;

  @override
  void initState() {
    super.initState();

    screens = [
      RoomsScreen(onChatChange: () => setState(() => _closed = !_closed)),
      Pokedex(),
      HomeScreen(),
    ];
  }

  void _onItemTapped(int index) {
    if (!_closed) {
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<GlobalMessages>().user;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox.expand(child: screens[_selectedIndex]),
            Positioned(
              bottom: 0,
              child: AnimatedContainer(
                height: _closed ? 0 : 56,
                duration: const Duration(milliseconds: 300),
                width: MediaQuery.of(context).size.width,
                child: BottomNavigationBar(
                  onTap: _onItemTapped,
                  currentIndex: _selectedIndex,
                  selectedItemColor: Colors.amber[800],
                  items: [
                    const BottomNavigationBarItem(
                      label: 'Arena',
                      icon: Icon(CustomIcons.battle),
                    ),
                    const BottomNavigationBarItem(
                      label: 'Pokedex',
                      icon: Icon(CustomIcons.pokeball),
                    ),
                    BottomNavigationBarItem(
                      label: 'Home',
                      icon: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: ThemeData.light().scaffoldBackgroundColor,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                              getAvatarLink(user.avatar),
                            ),
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(width: 1, color: Colors.grey[600]),
                        ),
                      ),
                      activeIcon: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: ThemeData.light().scaffoldBackgroundColor,
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              getAvatarLink(user.avatar),
                            ),
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 1,
                            color: Colors.amber[800],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
