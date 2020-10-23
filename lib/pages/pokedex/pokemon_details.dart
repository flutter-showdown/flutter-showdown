import 'package:flutter/material.dart';
import 'package:flutter_showdown/extensions/string_extension.dart';
import 'package:flutter_showdown/models/pokemon.dart';

class PokemonDetails extends StatelessWidget {
  const PokemonDetails(this.pokemon);
  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    final name = pokemon.name.capitalize();
    return Scaffold(
      appBar: AppBar(
        title: Text('$name Details'),
      ),
      body: Column(
        children: [
          Center(
            child: Image.network(
              'https://play.pokemonshowdown.com/sprites/ani/${pokemon.name}.gif',
            ),
          ),
        ],
      ),
    );
  }
}
