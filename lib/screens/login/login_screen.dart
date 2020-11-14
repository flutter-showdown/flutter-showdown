import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_showdown/screens/login/blue_wave.dart';
import 'login_form.dart';
import 'moving_pokemon.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: [
            BottomWaveContainer(
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    colors: [Colors.lightBlue[200], Colors.lightBlue],
                  ),
                ),
              ),
            ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
