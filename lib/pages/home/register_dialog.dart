import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_showdown/providers/global_messages.dart';


class RegisterDialog extends StatefulWidget {
  const RegisterDialog(this._username, {Key key}) : super(key: key);

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

    _registerFuture = Future<String>.value('');
  }

  void _registerUser() {
    if (_formKey.currentState.validate()) {
      setState(() {
        _registerFuture = globalMessages.registerUser(widget._username, _passwordController.text, _captchaController.text.trim());
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
      title: const Text('Register your account'),
      content: FutureBuilder<String>(
        future: _registerFuture,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data != 'success') {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      snapshot.data.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                    TextFormField(
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(labelText: 'Password'),
                      controller: _passwordController,
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
                      decoration:
                          const InputDecoration(labelText: 'Confirm Password'),
                      controller: _cpasswordController,
                      validator: (String value) {
                        if (value.length < 5) {
                          return 'Must be at least 5 characters long';
                        } else if (value != _passwordController.text) {
                          return 'Your passwords do not match';
                        }
                        return null;
                      },
                    ),
                    Image.network('https://play.pokemonshowdown.com/sprites/gen5ani/pikachu.gif'),
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Who's That Pokémon?"),
                      controller: _captchaController,
                      onFieldSubmitted: (_) => _registerUser(),
                    ),
                  ],
                ),
              );
            } else {
              return const Text('Registered');
            }
          }
          return const CircularProgressIndicator();
        },
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => _registerUser(),
          child: const Text('Register'),
        ),
        FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
