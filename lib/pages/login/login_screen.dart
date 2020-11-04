import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_showdown/pages/common/login_dialog.dart';
import 'package:flutter_showdown/providers/global_messages.dart';
import 'green_clipper.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<GlobalMessages>().user;

    return Scaffold(
      body: Container(
        child: Stack(children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/icons/pokemonshowdownbeta.png',
                      height: 70, fit: BoxFit.cover),
                  const SizedBox(height: 8),
                  if (user != null)
                    Text('Welcome ${user.name}')
                  else
                    const CircularProgressIndicator(),
                  const SizedBox(height: 8),
                  Column(
                    children: [
                      LoginDialog(),
                    ],
                  )
                ],
              ),
            ),
          ),
          ClipPath(
            clipper: GreenClipper(),
            child: Container(
              color: Colors.lightBlue[300].withOpacity(0.7),
            ),
          ),
        ]),
      ),
    );
  }
}
