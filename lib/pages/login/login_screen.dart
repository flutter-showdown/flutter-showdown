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
  Color MyOrange = const Color(0xFFFF881B);
  Color MyPink = const Color(0xFFE62E6F);

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
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                    image: AssetImage('assets/icons/pokemonshowdownbeta.png')),
                const SizedBox(height: 8),
                if (user != null)
                  Text('Welcome ${user.name}')
                else
                  const CircularProgressIndicator(),
                const SizedBox(height: 8),
                LoginForm(),
              ],
            ),
          ),
        ),
        BottomWaveContainer(Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFF881B), Color(0xFFE62E6F)])))),
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
