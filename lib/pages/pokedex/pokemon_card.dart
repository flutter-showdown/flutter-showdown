import 'package:flutter/material.dart';
import 'package:flutter_showdown/models/pokemon.dart';
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Center(
                  child: Text(
                    pokemon.tier,
                    style:
                        const TextStyle(fontSize: 11, color: Color(0xff888888)),
                  ),
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://play.pokemonshowdown.com/sprites/bwicons/${pokemon.id}.png',
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.network(
                          'https://play.pokemonshowdown.com/sprites/types/${pokemon.types[0]}.png',
                        ),
                        if (pokemon.types.length > 1)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(1, 0, 0, 0),
                            child: Image.network(
                              'https://play.pokemonshowdown.com/sprites/types/${pokemon.types[1]}.png',
                            ),
                          )
                      ],
                    ),
                  ],
                ),
              ),
              if (pokemon.forme != null)
                Row(
                  children: [
                    Text(pokemon.baseSpecies),
                    Text(
                      '-' + pokemon.forme,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                )
              else
                Text(pokemon.name),
              StatsBox(pokemon.baseStats),
            ],
          ),
        ),
      ),
    );
  }
}

class StatBox extends StatelessWidget {
  const StatBox(this.label, this.stat);
  final String label;
  final int stat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xff888888)),
          ),
          Text(
            '$stat',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class StatsBox extends StatelessWidget {
  const StatsBox(this.stats);
  final Stats stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          StatBox('HP', stats.hp),
          StatBox('Atk', stats.atk),
          StatBox('Def', stats.def),
          StatBox('SpA', stats.spa),
          StatBox('SpD', stats.spd),
          StatBox('Spe', stats.spe),
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
            child: StatBox(
                'BST',
                [
                  stats.hp,
                  stats.atk,
                  stats.def,
                  stats.spa,
                  stats.spd,
                  stats.spe
                ].fold(0, (a, b) => a + b)),
          )
        ],
      ),
    );
  }
}
