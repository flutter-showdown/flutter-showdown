import 'package:flutter/material.dart';
import 'package:flutter_showdown/constants.dart';
import 'package:flutter_showdown/pages/common/button_plain_color.dart';
import 'package:flutter_showdown/providers/global_messages.dart';
import 'package:provider/provider.dart';
import '../../utils.dart';
import '../common/login_dialog.dart';
import 'avatar_dialog.dart';
import 'register_dialog.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<GlobalMessages>().user;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 56),
        child: Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () async {
                final int newAvatar = await showDialog(
                  context: context,
                  builder: (_) => AvatarDialog(),
                );
                if (newAvatar != null) {
                  context
                      .read<GlobalMessages>()
                      .setAvatar(BattleAvatarNumbers[newAvatar.toString()]);
                }
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: Image.network(getAvatarLink(user.avatar)).image,
                    fit: BoxFit.fill,
                  ),
                  border: Border.all(width: 1),
                ),
              ),
            ),
            const SizedBox(width: 8),
            FlatButton(
              child: Text(user.name),
              onPressed: () async {
                showDialog<LoginDialog>(
                    context: context, builder: (_) => LoginDialog());
              },
            ),
            if (user.group != ' ') const SizedBox(width: 8),
            if (user.group != ' ') Text(Groups[user.group]),
            const SizedBox(width: 8),
            if (user.named && !user.registered)
              ElevatedButton(
                child: const Text('Register'),
                onPressed: () {
                  showDialog<RegisterDialog>(
                      context: context,
                      builder: (_) => RegisterDialog(user.name));
                },
              ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ButtonPlainColor(
                  onTap: () {
                    context.read<GlobalMessages>().logout();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  text: 'Logout'),
            )
          ],
        ),
      ),
    );
  }
}
