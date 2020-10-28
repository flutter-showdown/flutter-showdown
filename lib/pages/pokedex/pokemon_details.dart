import 'package:flutter/material.dart';
import 'package:flutter_showdown/models/pokemon.dart';
import 'package:flutter_showdown/parser.dart';

class PokemonDetails extends StatelessWidget {
  const PokemonDetails(this.pokemon);
  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    final resourceId = pokemon.forme != null
        ? '${Parser.toId(pokemon.baseSpecies)}-${Parser.toId(pokemon.forme.replaceFirst('-Totem', ''))}'
        : Parser.toId(pokemon.name);
    return Scaffold(
      appBar: AppBar(
        title: Text('${pokemon.name} Details'),
      ),
      body: Column(
        children: [
          Center(
            child: Image.network(
              'https://play.pokemonshowdown.com/sprites/gen5/$resourceId.png',
            ),
          ),
        ],
      ),
    );
  }
}
