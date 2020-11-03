import 'package:flutter/material.dart';
import 'package:flutter_showdown/pages/main_screen.dart';
import 'package:flutter_showdown/startup.dart';
import 'package:flutter_showdown/pages/login/login_screen.dart';

void main() {
  runApp(
    Startup(
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
