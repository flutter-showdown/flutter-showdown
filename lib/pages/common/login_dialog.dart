import 'package:flutter/material.dart';
import 'package:flutter_showdown/parser.dart';
import 'package:provider/provider.dart';
import 'package:flutter_showdown/providers/global_messages.dart';

class LoginDialog extends StatefulWidget {
  @override
  _LoginDialogState createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  String _username;
  bool _protected = false;
  Future<bool> _logFuture;
  Future<String> _usernameFuture;
  final _formKey = GlobalKey<FormState>();
  final _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _logFuture = Future.value(null);
    _usernameFuture = Future.value(null);
  }

  @override
  void dispose() {
    _inputController.dispose();

    super.dispose();
  }

  void _setUsername() {
    if (_formKey.currentState.validate()) {
      _username = _inputController.text;

      setState(() {
        _usernameFuture = context.read<GlobalMessages>().setUsername(_username)
          ..then((String result) {
            if (result.isNotEmpty) {
              //Failed
              if (result == ';') {
                //Username Protected
                setState(() {
                  _protected = true;
                  _usernameFuture = Future.value(null);
                });
              }
              _inputController.clear();
            } else
              //Success
              Navigator.of(context).pop(true);
          });
      });
    }
  }

  Widget _usernameBuilder() {
    return FutureBuilder(
      future: _usernameFuture,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null || snapshot.data.isNotEmpty) {
            //Ask for new username
            return Container(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (snapshot.data != null)
                      Text(snapshot.data.substring(1),
                          style: const TextStyle(color: Colors.red)),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _inputController,
                        onFieldSubmitted: (_) => _setUsername(),
                        decoration:
                            const InputDecoration(labelText: 'Username'),
                        validator: (String username) {
                          if (Parser.toId(username).isEmpty) {
                            return 'Must contain at least one letter.';
                          }
                          return null;
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          return Container(height: 0);
        }
        return const Center(
            heightFactor: 0, child: CircularProgressIndicator());
      },
    );
  }

  void _setPassword() {
    if (_formKey.currentState.validate()) {
      final password = _inputController.text;

      setState(() {
        debugPrint('$_username => $password');
        _logFuture = context.read<GlobalMessages>().logUser(_username, password)
          ..then((result) {
            if (result) {
              Navigator.of(context).pop(true);
            }
          });
      });
      _inputController.clear();
    }
  }

  Widget _passwordBuilder() {
    return FutureBuilder(
      future: _logFuture,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null || !snapshot.data) {
            return Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (snapshot.data == false)
                      const Text('Wrong Password',
                          style: TextStyle(color: Colors.red)),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _inputController,
                        onFieldSubmitted: (_) => _setPassword(),
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          suffixIcon: Icon(Icons.visibility_off),
                        ),
                        validator: (String password) {
                          if (password.isEmpty) {
                            return 'Must contain at least one letter.';
                          }
                          return null;
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          return Container(height: 0);
        }
        return const Center(
            heightFactor: 0, child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      return Colors.lightBlue.withOpacity(0.7);
    }

    return Column(
      children: [
        if (_protected) _passwordBuilder() else _usernameBuilder(),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(getColor),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/main');
                },
                child: const Text('Continue as Guest'),
              ),
              ElevatedButton(
                onPressed: () {
                  _protected ? _setPassword() : _setUsername();
                },
                child: const Text('Login'),
              ),
            ]),
      ],
    );
  }
}
