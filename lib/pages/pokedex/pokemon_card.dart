import 'package:flutter/material.dart';
import 'package:flutter_showdown/models/pokemon.dart';
import 'package:flutter_showdown/extensions/string_extension.dart';
import './pokemon_details.dart';

class PokemonCard extends StatelessWidget {
  const PokemonCard(this.pokemon);

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
                builder: (context) => PokemonDetails(pokemon)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Row(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Image.network(
                    'https://play.pokemonshowdown.com/sprites/bwicons/${pokemon.id}.png',
                    width: 40,
                    height: 40,
                  ),
                  Row(
                    children: [
                      Image.network(
                        'https://play.pokemonshowdown.com/sprites/types/Fire.png',
                        width: 32,
                        height: 12,
                      ),
                      Image.network(
                        'https://play.pokemonshowdown.com/sprites/types/Fire.png',
                        width: 32,
                        height: 12,
                      ),
                    ],
                  ),
                ],
              ),
              Text(pokemon.name.capitalize())
            ],
          ),
        ),
      ),
    );
  }
}
