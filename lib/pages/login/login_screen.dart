import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_showdown/pages/login/blue_wave.dart';
import 'login_form.dart';
import 'moving_pokemon.dart';

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
    return SafeArea(
        top: false,
        bottom: true,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Stack(children: [
            BottomWaveContainer(Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.center,
                        colors: [Colors.lightBlue[200], Colors.lightBlue])))),
            PokemonAnimation(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage('assets/images/showdown-title.png'),
                  height: 200,
                  width: 300,
                  fit: BoxFit.fitWidth,
                ),
                LoginForm(),
              ],
            ),
            Positioned(
                left: 0.0,
                right: 0.0,
                bottom: 0.0,
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(6.0),
                    color: Colors.lightBlue[100].withOpacity(0.7),
                    child: const Text(
                      'We do not own any of the resources used in this application',
                      style: TextStyle(fontSize: 10, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )),
          ]),
        ));
  }
}
