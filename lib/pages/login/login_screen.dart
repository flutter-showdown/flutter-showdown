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
                  Image.asset('assets/icons/showdown-title.png',
                      height: 100, fit: BoxFit.cover),
                  const SizedBox(height: 8),
                  if (user != null)
                    Text('Welcome ${user.name}',
                        style: const TextStyle(
                            fontFamily: 'Roboto', color: Colors.black45))
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
          Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: Center(
                child: Container(
                  color: Colors.lightBlue[100].withOpacity(0.7),
                  child: const Text(
                    'Toutes les ressources de cette application viennent du site pokemon showdown',
                    style: TextStyle(fontSize: 10, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
              ))
        ]),
      ),
    );
  }
}
