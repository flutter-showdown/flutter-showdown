import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_showdown/pages/login/blue_wave.dart';
import 'package:provider/provider.dart';
import 'package:flutter_showdown/providers/global_messages.dart';

import 'login_form.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final double startingHeight = 20.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<GlobalMessages>().user;

    return Scaffold(
      body: Stack(children: [
        BottomWaveContainer(Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    colors: [Colors.blue, Colors.green])))),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('assets/icons/pokemon2.png'),
              height: 200,
              width: 250,
              fit: BoxFit.fitWidth,
            ),
            if (user == null) const CircularProgressIndicator(),
            LoginForm(),
          ],
        ),
        Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Center(
              child: Container(
                color: Colors.lightBlue[100].withOpacity(0.7),
                child: const Text(
                  'All ressources of this application belongs to the website pokemon showdown',
                  style: TextStyle(fontSize: 10, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            )),
      ]),
    );
  }
}
