import 'package:flutter/material.dart';
import 'pokedex/pokedex.dart';

class TeamBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team builder'),
      ),
      body: const Text('oui'),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (context) => Pokedex()),
        ),
      ),
    );
  }
}
