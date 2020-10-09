import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../utils.dart';
import 'login_dialog.dart';
import 'websockets/global_messages.dart';
import 'websockets/global_messages_enums.dart';

class AvatarChoiceDialog extends StatelessWidget {
  static final Future<List<Image>> _trainerList = compute(
      splitImages,
      SplitParameters(
          'https://play.pokemonshowdown.com/sprites/trainers-sheet.png',
          16,
          19));

  List<Widget> _getTiles(BuildContext context, List<Image> list) {
    final List<Widget> tiles = <Widget>[];

    for (int i = 0; i < list.length; i++) {
      tiles.add(InkWell(
        child: list[i],
        onTap: () {
          Navigator.of(context).pop(i + 1);
        },
      ));
    }
    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose Avatar'),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.90,
        height: MediaQuery.of(context).size.height * 0.60,
        child: FutureBuilder(
          future: _trainerList,
          builder: (BuildContext context, AsyncSnapshot<List<Image>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return GridView.count(
                crossAxisCount: 4,
                children: _getTiles(context, snapshot.data),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
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

class RegisterDialog extends StatefulWidget {
  const RegisterDialog(this._username, {Key key}) : super(key: key);

  final String _username;

  @override
  _RegisterDialogState createState() => _RegisterDialogState(_username);
}

class _RegisterDialogState extends State<RegisterDialog> {
  _RegisterDialogState(this._username);

  final String _username;
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
        _registerFuture = globalMessages.registerUser(_username,
            _passwordController.text, _captchaController.text.trim());
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

  //static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

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
                    Image.network(
                        'https://play.pokemonshowdown.com/sprites/gen5ani/pikachu.gif'),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: "Who's That Pokémon?"),
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

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User _user = User();
  final String _avatarLinkPrefix =
      'https://play.pokemonshowdown.com/sprites/trainers/';

  @override
  void initState() {
    super.initState();

    globalMessages.addListener(_globalMessageReceived);
  }

  void _globalMessageReceived(GlobalMessage message) {
    message.when(
        updateUser: (User newUser) {
          setState(() {
            _user = newUser;
            if (int.tryParse(_user.avatar) != null) {
              _user.avatar = battleAvatarNumbers[_user.avatar];
            }
          });
        },
        userDetails: (_) {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: <Widget>[
          const SizedBox(height: 20),
          Container(
            child: _user.avatar != null
                ? Column(
                    children: <Widget>[
                      InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () async {
                          final int newAvatar = await showDialog(
                              context: context,
                              builder: (_) => AvatarChoiceDialog());

                          if (newAvatar != null) {
                            globalMessages.setAvatar(
                                battleAvatarNumbers[newAvatar.toString()]);
                          }
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: Image.network(_avatarLinkPrefix +
                                        _user.avatar +
                                        '.png')
                                    .image,
                                fit: BoxFit.fill),
                            border: Border.all(width: 1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(_user.username),
                      FlatButton(
                        onPressed: () => showDialog<LoginDialog>(
                            context: context, builder: (_) => LoginDialog()),
                        child: const Text('Change Name'),
                      ),
                      if (_user.named && _user.registerTime == null)
                        FlatButton(
                          onPressed: () => showDialog<RegisterDialog>(
                              context: context,
                              builder: (_) => RegisterDialog(_user.username)),
                          child: const Text('Register'),
                        )
                      else
                        // TODO(anyone): Hmmmmmmm
                        Container(width: 0, height: 0),
                    ],
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
