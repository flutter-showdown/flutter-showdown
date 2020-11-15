import 'package:flutter/material.dart';
import 'package:flutter_showdown/screens/common/button_outline_color.dart';
import 'package:flutter_showdown/screens/common/button_plain_color.dart';
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
  bool _guest = true;
  bool _obscure = true;
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
                    onTap: () {
                      setState(() {
                        _guest = false;
                      });
                    },
                    controller: _inputController,
                    onFieldSubmitted: (_) {
                      if (_guest)
                        Navigator.pushReplacementNamed(context, '/main');
                      else
                        _setUsername();
                      _inputController.clear();
                    },
                    decoration: InputDecoration(
                      hintText: context.watch<GlobalMessages>().user.name,
                    ),
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
                  const Text(
                    'Wrong Password',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _inputController,
                    onFieldSubmitted: (_) => _setPassword(),
                    autofocus: true,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: GestureDetector(
                        onTap: () => setState(() => _obscure = !_obscure),
                        child: Icon(_obscure
                            ? Icons.visibility_off
                            : Icons.remove_red_eye),
                      ),
                    ),
                    validator: (String password) {
                      if (password.isEmpty) {
                        return 'Must contain at least one letter.';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            );
          }
          return Container(height: 0);
        }
        return const Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: Center(heightFactor: 0, child: CircularProgressIndicator()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //state ?
    final user = context.watch<GlobalMessages>().user;

    if (user != null && user.named) {
      Future.microtask(() => Navigator.pushReplacementNamed(context, '/main'));
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          margin: const EdgeInsets.only(bottom: 56),
          child: user != null
              ? Column(
                  children: [
                    if (_protected) _passwordBuilder() else _usernameBuilder(),
                    const SizedBox(height: 16),
                    if (_protected)
                      Row(
                        children: [
                          Expanded(
                            child: ButtonOutlineColor(
                              text: 'Cancel',
                              onTap: () => setState(() {
                                _logFuture = Future.value(null);
                                _inputController.clear();
                                _guest = true;
                                _protected = false;
                              }),
                            ),
                          ),
                          const SizedBox(width: 15.0),
                          Expanded(
                            child: ButtonPlainColor(
                              text: 'Login',
                              onTap: _setPassword,
                            ),
                          ),
                        ],
                      )
                    else
                      ButtonPlainColor(
                        text: 'Continue${_guest ? ' as guest' : ''}',
                        onTap: () {
                          if (_guest)
                            Navigator.pushReplacementNamed(context, '/main');
                          else
                            _setUsername();
                          _inputController.clear();
                        },
                      ),
                  ],
                )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
