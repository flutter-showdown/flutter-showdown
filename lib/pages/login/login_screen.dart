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
            const Image(
              image: AssetImage('assets/icons/pokemonshowdownbeta.png'),
            ),
            const SizedBox(height: 8),
            if (user != null)
              Text('Welcome ${user.name}')
            else
              const CircularProgressIndicator(),
            const SizedBox(height: 8),
            ElevatedButton(
              child: const Text('Login'),
              onPressed: () {
                showDialog<LoginScreen>(
                  context: context,
                  builder: (_) => LoginDialog(),
                );
                if (context.read<GlobalMessages>().user.named) {
                  Navigator.pushReplacementNamed(context, '/main');
                }
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              child: const Text('Continue as Guest'),
              onPressed: () => Navigator.pushReplacementNamed(context, '/main'),
            ),
          ],
        ),
      ),
    );
  }
}
