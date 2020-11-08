import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_showdown/pages/main_screen.dart';
import 'package:flutter_showdown/startup.dart';
import 'package:flutter_showdown/pages/login/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      Startup(
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/main': (context) => MainScreen(),
      },
    );
  }
}
