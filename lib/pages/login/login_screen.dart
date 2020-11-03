import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_showdown/pages/common/login_dialog.dart';
import 'package:flutter_showdown/providers/global_messages.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<GlobalMessages>().user;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(image: AssetImage('assets/icons/pokemonshowdownbeta.png')),
            const SizedBox(height: 8),
            if (user != null)
              Text('Welcome ${user.name}')
            else
              const CircularProgressIndicator(),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final bool result = await showDialog(context: context, builder: (_) => LoginDialog());

                if (result) {
                  Navigator.pushReplacementNamed(context, '/main');
                }
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/main');
              },
              child: const Text('Continue as Guest'),
            ),
          ],
        ),
      ),
    );
  }
}