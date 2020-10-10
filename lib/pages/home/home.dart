import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../common/login_dialog.dart';
import '../websockets/global_messages.dart';
import '../websockets/global_messages_enums.dart';
import 'avatar_dialog.dart';
import 'register_dialog.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
                              builder: (_) => AvatarDialog());

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
