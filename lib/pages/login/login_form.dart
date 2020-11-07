import 'package:flutter/material.dart';
import 'package:flutter_showdown/pages/common/button_outline_color.dart';
import 'package:flutter_showdown/pages/common/button_plain_color.dart';
import 'package:flutter_showdown/parser.dart';
import 'package:provider/provider.dart';
import 'package:flutter_showdown/providers/global_messages.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String _username;
  bool _protected = false;
  bool _loginAsUser = false;
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

              Navigator.pushReplacementNamed(context, '/main');
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
            return Column(
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
                    decoration: const InputDecoration(labelText: 'Username'),
                    validator: (String username) {
                      if (Parser.toId(username).isEmpty) {
                        return 'Must contain at least one letter.';
                      }
                      return null;
                    },
                  ),
                )
              ],
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
        //debugPrint('$_username => $password');
        _logFuture = context.read<GlobalMessages>().logUser(_username, password)
          ..then((result) {
            if (result) {
              Navigator.pushReplacementNamed(context, '/main');
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
            return Column(
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
            );
          }
          return Container(height: 0);
        }
        return const Center(
            heightFactor: 0, child: CircularProgressIndicator());
      },
    );
  }

  void _setLoginAsUser(bool value) {
    setState(() {
      _loginAsUser = value;
    });
  }

  void _pushMain() {
    Navigator.pushReplacementNamed(context, '/main');
  }

  Widget _showInputs() {
    return Center(
        child: Column(
      children: [
        if (_protected) _passwordBuilder() else _usernameBuilder(),
        Container(
          padding: const EdgeInsets.only(top: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ButtonOutlineColor(
                    text: 'cancel',
                    actionName: () => setState(() {
                          _loginAsUser = false;
                        })),
              ),
              const SizedBox(
                width: 15.0,
              ),
              if (_protected)
                Expanded(
                    child: ButtonPlainColor(
                        text: 'login', actionName: _setPassword))
              else
                Expanded(
                    child: ButtonPlainColor(
                        text: 'validate', actionName: _setUsername))
            ],
          ),
        ),
      ],
    ));
  }

  Widget _chooseButton() {
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 55.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        ButtonOutlineColor(text: 'Login as guest', actionName: _pushMain),
        const SizedBox(
          height: 15.0,
        ),
        ButtonPlainColor(
            text: 'Login',
            actionName: () => setState(() {
                  _loginAsUser = true;
                }))
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [if (_loginAsUser) _showInputs() else _chooseButton()],
        ),
      ),
    );
  }
}
