import 'package:flutter/material.dart';
import 'package:flutter_showdown/extensions/string_extension.dart';
import 'pokemon.dart';

class PokemonCard extends StatelessWidget {
  const PokemonCard(this.pokemon);

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
            'https://play.pokemonshowdown.com/sprites/bwicons/${pokemon.id}.png',
            width: 40,
            height: 40,
          ),
          Text(pokemon.name.capitalize())
        ],
      ),
    ));
  }
}
