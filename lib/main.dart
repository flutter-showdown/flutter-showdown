import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_showdown/pages/main_screen.dart';
import 'package:flutter_showdown/pages/login/login_screen.dart';
import 'package:flutter_showdown/providers/room_messages.dart';
import 'package:flutter_showdown/providers/global_messages.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RoomMessages(), lazy: false),
        ChangeNotifierProvider(create: (_) => GlobalMessages(), lazy: false),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/main': (context) => MainScreen(),
      },
    );
  }
}