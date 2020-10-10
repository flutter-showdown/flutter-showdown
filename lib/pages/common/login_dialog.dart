import 'package:flutter/material.dart';

import '../websockets/global_messages.dart';

class LoginDialog extends StatefulWidget {
  @override
  _LoginDialogState createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  String _newUsername;
  Future<bool> _logFuture;
  Future<bool> _nameFuture;

  @override
  void initState() {
    super.initState();

    _logFuture = Future.value(null);
    _nameFuture = Future.value(null);
  }

  void _setUsername(String username) {
    setState(() {
      _nameFuture = globalMessages.setUsername(username)
        ..then((result) {
          setState(() {
            _newUsername = username;
          });
        });
    });
  }

  void _logUser(String password) {
    setState(() {
      _logFuture = globalMessages.logUser(_newUsername, password);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change Name'),
      content: FutureBuilder(
        future: _nameFuture,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) {
              //Ask for new username
              return TextField(
                decoration: const InputDecoration(labelText: 'Username'),
                onSubmitted: (String username) => _setUsername(username),
              );
            } else if (snapshot.data) {
              //Name changed
              return Container(width: 0, height: 0);
            } else {
              //The username is protected
              return FutureBuilder(
                future: _logFuture,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data == null) {
                      return TextField(
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          suffixIcon: Icon(Icons.visibility_off),
                        ),
                        obscureText: true,
                        onSubmitted: (String password) => _logUser(password),
                      );
                    } else if (snapshot.data) {
                      return const Text('Success');
                    } else {
                      return const Text('Failed');
                    }
                  }
                  return const CircularProgressIndicator();
                },
              );
            }
          }
          return const CircularProgressIndicator();
        },
      ),
      actions: <Widget>[
        FlatButton(
          child: const Text('Close'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
