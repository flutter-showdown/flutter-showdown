import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_showdown/providers/global_messages.dart';
import 'package:flutter_showdown/providers/global_messages_enums.dart';

import '../../constants.dart';
import '../../utils.dart';
import '../common/login_dialog.dart';
import 'avatar_dialog.dart';
import 'register_dialog.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User _user = User();

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
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: <Widget>[
          const SizedBox(height: 20),
          if (_user.avatar != null)
            Column(
              children: <Widget>[
                InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () async {
                    final int newAvatar = await showDialog(context: context, builder: (_) => AvatarDialog());

                    if (newAvatar != null) {
                      globalMessages.setAvatar(BATTLEAVATARNUMBERS[newAvatar.toString()]);
                    }
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: Image.network(getAvatarLink(_user.avatar)).image,
                        fit: BoxFit.fill,
                      ),
                      border: Border.all(width: 1),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(_user.name),
                FlatButton(
                  onPressed: () => showDialog<LoginDialog>(
                      context: context, builder: (_) => LoginDialog()),
                  child: const Text('Change Name'),
                ),
                if (_user.named && _user.registered == null)
                  FlatButton(
                    onPressed: () => showDialog<RegisterDialog>(
                        context: context,
                        builder: (_) => RegisterDialog(_user.name)),
                    child: const Text('Register'),
                  )
              ],
            )
          else
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
