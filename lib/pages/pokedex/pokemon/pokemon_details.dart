import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_showdown/models/pokemon.dart';
import 'package:flutter_showdown/pages/pokedex/ability/ability_details.dart';
import 'package:flutter_showdown/pages/pokedex/common/type_box.dart';
import 'package:flutter_showdown/pages/pokedex/moves/move_card.dart';
import 'package:flutter_showdown/parser.dart';
import 'package:flutter_showdown/constants.dart';
import 'package:provider/provider.dart';
import '../common/get_icon_index.dart';

class PokemonDetails extends StatelessWidget {
  const PokemonDetails(this.pokemon);

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    final forme = pokemon.forme?.replaceFirst('Totem', '');
    final pokeId = Parser.toId(pokemon.name);
    final resourceId = pokemon.forme != null
        ? '${Parser.toId(pokemon.baseSpecies)}${forme.isEmpty ? '' : '-'}${Parser.toId(forme)}'
        : pokeId;

    final pokemonAbilities = [
      pokemon.abilities.first,
      pokemon.abilities.second,
      pokemon.abilities.hidden,
      pokemon.abilities.special,
    ];

    final learnsetId =
        pokemon.forme != null ? Parser.toId(pokemon.baseSpecies) : pokeId;
    final learnsets =
        Provider.of<Map<String, List<String>>>(context, listen: false);
    final learnset = learnsets[pokeId] ?? learnsets[learnsetId];

    final dex = Provider.of<Map<String, Pokemon>>(context, listen: false);
    // Widget _getNextEvo() {

    // }

    Widget _evoTree() {
      //   Pokemon current = pokemon;
      //   while (current.prevo != null) {
      //     final poke = dex[Parser.toId(current.prevo)];
      //     current = poke;
      //   }
      //   final Pokemon base = current;
      //   print(base.name);
      //   return Row(
      //     children: [
      //       EvoBox(base),
      //       for (base.evos),
      //     ],
      //   );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height + 100,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 116,
                    height: 116,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          TypeBox.typeColors[pokemon.types[0]][0],
                          TypeBox.typeColors[pokemon
                              .types[pokemon.types.length > 1 ? 1 : 0]][0]
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(2.5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: '$ServerUrl/sprites/gen5/$resourceId.png',
                        placeholder: (context, url) => Container(
                          height: 96,
                          width: 96,
                          child: const Center(
                              heightFactor: 0,
                              child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, dynamic error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                  Container(
                    width: 232,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 4,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (pokemon.id > 0)
                                  Text(
                                    '#${pokemon.id}',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                Container(
                                  child: Text(pokemon.tier),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 4),
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.grey[700]),
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                  width: 64, child: const Text('Types :')),
                              Row(
                                children: pokemon.types
                                    .map((t) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: TypeBox(t),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(width: 64, child: const Text('Size :')),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    '${pokemon.height} m, ${pokemon.weight} kg'),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16, left: 8),
                child: Text('Abilities :'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    for (int i = 0; i < pokemonAbilities.length; i++)
                      if (pokemonAbilities[i] != null)
                        Row(
                          children: [
                            if (i != 0)
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text('|'),
                              ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                      builder: (context) =>
                                          AbilityDetails(pokemonAbilities[i])),
                                );
                              },
                              child: Text(
                                  '${pokemonAbilities[i]}${i == 2 ? ' (H)' : i == 3 ? ' (S)' : ''}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      decoration: TextDecoration.underline,
                                      color: Colors.blue[800])),
                            ),
                          ],
                        ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Base stats :',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    StatBox('HP', pokemon.baseStats.hp),
                    StatBox('Attack', pokemon.baseStats.atk),
                    StatBox('Defense', pokemon.baseStats.def),
                    StatBox('Sp. Atk', pokemon.baseStats.spa),
                    StatBox('Sp. Def', pokemon.baseStats.spd),
                    StatBox('Speed', pokemon.baseStats.spe),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 70,
                            margin: const EdgeInsets.only(right: 8),
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Total :',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                          Container(
                            width: 32,
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${pokemon.baseStats.bst}',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Text('Evolution: '),
              Padding(padding: const EdgeInsets.all(8.0), child: _evoTree()
                  // child: Row(
                  //   children: [
                  //     // if (pokemon.prevo == null && pokemon.evos == null)
                  //     //   const Text('Does not evolve'),
                  //     // if (pokemon.prevo != null) EvoBox(pokemon.prevo),
                  //     // EvoBox(pokemon.name),
                  //     // if (pokemon.evos != null) EvoBox(pokemon.evos[0]),
                  //   ],
                  // ),
                  ),
              const Text('Moves: '),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView.builder(
                    itemCount: learnset.length,
                    itemBuilder: (_, idx) => MoveCard(learnset[idx]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EvoBox extends StatelessWidget {
  const EvoBox(this.pokemon);
  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Image.asset('assets/pokemon-icons/${getIconIndex(pokemon)}.png'),
          Text(pokemon.name),
        ],
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
    int width = stat.floor();
    if (width > 200) {
      width = 200;
    }
    int color = (stat * 180 / 255).floor();
    if (color > 360) {
      color = 360;
    }
    return Row(
      children: [
        Container(
            width: 70,
            margin: const EdgeInsets.only(right: 8),
            alignment: Alignment.centerRight,
            child: Text('$label :')),
        Container(
            width: 32,
            margin: const EdgeInsets.only(right: 8),
            alignment: Alignment.centerRight,
            child: Text('$stat',
                style: const TextStyle(fontWeight: FontWeight.bold))),
        Expanded(
          child: Stack(children: [
            Container(
              height: 12,
              width: width.toDouble(),
              decoration: BoxDecoration(
                border: Border.all(
                    color: HSLColor.fromAHSL(1, color.toDouble(), 0.75, 0.35)
                        .toColor()),
                borderRadius: BorderRadius.circular(2),
                color: HSLColor.fromAHSL(1, color.toDouble(), 0.85, 0.45)
                    .toColor(),
              ),
            ),
            Positioned(
              top: 1,
              left: 1,
              child: Container(
                height: 3.2,
                width: width.toDouble() - (width < 2 ? width : 2),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(2),
                      topRight: Radius.circular(2)),
                  color: HSLColor.fromAHSL(1, color.toDouble(), 0.85, 0.55)
                      .toColor(),
                ),
              ),
            ),
          ]),
        )
      ],
    );
  }
}
