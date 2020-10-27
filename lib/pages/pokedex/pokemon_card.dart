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
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 34,
                child: Center(
                  child: Text(
                    pokemon.tier,
                    style:
                        const TextStyle(fontSize: 11, color: Color(0xff888888)),
                  ),
                ),
              ),
              Container(
                width: 65,
                margin: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                child: Column(
                  children: [
                    Image.network(
                      'https://play.pokemonshowdown.com/sprites/bwicons/${pokemon.id}.png',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Center(
                      child: pokemon.forme != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  pokemon.baseSpecies,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Flexible(
                                  child: Text(
                                    '-' + pokemon.forme,
                                    style: const TextStyle(fontSize: 11),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            )
                          : Text(pokemon.name),
                    ),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            pokemon.abilities.first,
                            style: const TextStyle(fontSize: 10),
                          ),
                          if (pokemon.abilities.second != null)
                            Text(
                              pokemon.abilities.second,
                              style: const TextStyle(fontSize: 10),
                            ),
                          if (pokemon.abilities.hidden != null)
                            Text(
                              pokemon.abilities.hidden,
                              style: const TextStyle(fontSize: 10),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              StatsBox(pokemon.baseStats),
            ],
          ),
        ),
      ),
    );
  }
}

class StatBox extends StatelessWidget {
  const StatBox(this.label, this.stat,
      {this.width = 28, this.labelColor = const Color(0xff888888)});
  final String label;
  final int stat;
  final double width;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, color: labelColor),
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
      width: 114,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  StatBox('HP', stats.hp),
                  StatBox('Atk', stats.atk),
                  StatBox('Def', stats.def)
                ],
              ),
              Row(
                children: [
                  StatBox('SpA', stats.spa),
                  StatBox('SpD', stats.spd),
                  StatBox('Spe', stats.spe),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(left: 4),
            child: StatBox(
              'BST',
              stats.hp +
                  stats.atk +
                  stats.def +
                  stats.spa +
                  stats.spd +
                  stats.spe,
              width: 24,
              labelColor: const Color(0xff666666),
            ),
          ),
        ],
      ),
    );
  }
}
