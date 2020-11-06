import 'package:flutter/material.dart';
import 'package:flutter_showdown/providers/global_messages.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class RegisterDialog extends StatefulWidget {
  const RegisterDialog(this._username);

  final String _username;

  @override
  _RegisterDialogState createState() => _RegisterDialogState();
}

class _RegisterDialogState extends State<RegisterDialog> {
  Future<String> _registerFuture;
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _cpasswordController = TextEditingController();
  final _captchaController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _registerFuture = Future<String>.value(null);
  }

  void _registerUser() {
    if (_formKey.currentState.validate()) {
      setState(() {
        _registerFuture = context.read<GlobalMessages>().registerUser(
              widget._username,
              _passwordController.text,
              _captchaController.text,
            )..then((result) {
                if (result.isEmpty) {
                  Navigator.of(context).pop();
                }
              });
      });
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _cpasswordController.dispose();
    _captchaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Register ${widget._username}'),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 0.0),
      content: FutureBuilder<String>(
        future: _registerFuture,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null || snapshot.data.isNotEmpty) {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (snapshot.data != null)
                      Text(
                        snapshot.data.toString(),
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    TextFormField(
                      autofocus: true,
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator: (String value) {
                        if (value.length < 5) {
                          return 'Must be at least 5 characters long';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                      controller: _cpasswordController,
                      decoration:
                          const InputDecoration(labelText: 'Confirm Password'),
                      validator: (String value) {
                        if (value.length < 5) {
                          return 'Must be at least 5 characters long';
                        } else if (value != _passwordController.text) {
                          return "Your passwords don't match";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Image.network(ServerUrl + '/sprites/gen5ani/pikachu.gif'),
                    TextFormField(
                      controller: _captchaController,
                      decoration: const InputDecoration(labelText: "Who's That Pokémon?"),
                      onFieldSubmitted: (_) => _registerUser(),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'You must provide a name';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              );
            } else {
              return const Text('Registered');
            }
          }
          return Container(height: 250, child: const Center(child: CircularProgressIndicator()));
        },
      ),
      actions: [
        FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        FlatButton(
          onPressed: () => _registerUser(),
          child: const Text('Confirm'),
        )
      ],
    );
  }
}