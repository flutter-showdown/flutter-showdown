import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_showdown/models/pokemon.dart';
import 'package:flutter_showdown/parser.dart';

class PokemonDetails extends StatelessWidget {
  const PokemonDetails(this.pokemon);
  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    final forme = pokemon.forme?.replaceFirst('Totem', '');
    final resourceId = pokemon.forme != null
        ? '${Parser.toId(pokemon.baseSpecies)}${forme.isEmpty ? '' : '-'}${Parser.toId(forme)}'
        : Parser.toId(pokemon.name);
    return Scaffold(
      appBar: AppBar(
        title: Text('${pokemon.name} Details'),
      ),
      body: Column(
        children: [
          Center(
            child: CachedNetworkImage(
              imageUrl:
                  'https://play.pokemonshowdown.com/sprites/gen5/$resourceId.png',
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, dynamic error) =>
                  const Icon(Icons.error),
            ),
          ),
        ],
      ),
    );
  }
}
