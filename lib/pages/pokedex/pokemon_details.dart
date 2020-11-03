import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_showdown/models/pokemon.dart';
import 'package:flutter_showdown/pages/pokedex/ability_details.dart';
import 'package:flutter_showdown/parser.dart';

class TypeBox extends StatelessWidget {
  const TypeBox(this.type);
  final String type;

  static Map<String, List<Color>> typeColors = {
    'Bird': const [Color(0xffCBC9CB), Color(0xffAAA6AA), Color(0xffa99890)],
    'Bug': const [Color(0xffA8B820), Color(0xff8D9A1B), Color(0xff616B13)],
    'Dark': const [Color(0xff705848), Color(0xff513F34), Color(0xff362A23)],
    'Dragon': const [Color(0xff7038F8), Color(0xff4C08EF), Color(0xff3D07C0)],
    'Electric': const [Color(0xffF8D030), Color(0xffF0C108), Color(0xffC19B07)],
    'Fairy': const [Color(0xffF830D0), Color(0xffF008C1), Color(0xffC1079B)],
    'Fighting': const [Color(0xffC03028), Color(0xff9D2721), Color(0xff82211B)],
    'Fire': const [Color(0xffF08030), Color(0xffDD6610), Color(0xffB4530D)],
    'Flying': const [Color(0xffA890F0), Color(0xff9180C4), Color(0xff7762B6)],
    'Ghost': const [Color(0xff705898), Color(0xff554374), Color(0xff413359)],
    'Grass': const [Color(0xff78C850), Color(0xff5CA935), Color(0xff4A892B)],
    'Ground': const [Color(0xffE0C068), Color(0xffD4A82F), Color(0xffAA8623)],
    'Ice': const [Color(0xff98D8D8), Color(0xff69C6C6), Color(0xff45B6B6)],
    'Normal': const [Color(0xffA8A878), Color(0xff8A8A59), Color(0xff79794E)],
    'Poison': const [Color(0xffA040A0), Color(0xff803380), Color(0xff662966)],
    'Psychic': const [Color(0xffF85888), Color(0xffF61C5D), Color(0xffD60945)],
    'Rock': const [Color(0xffB8A038), Color(0xff93802D), Color(0xff746523)],
    'Steel': const [Color(0xffB8B8D0), Color(0xff9797BA), Color(0xff7A7AA7)],
    'Water': const [Color(0xff6890F0), Color(0xff386CEB), Color(0xff1753E3)],
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: typeColors[type][2]),
        borderRadius: BorderRadius.circular(4),
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [typeColors[type][0], typeColors[type][1]]),
      ),
      width: 72,
      height: 24,
      child: Center(
          child: Text(
        type.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 13,
          shadows: [
            Shadow(
                offset: Offset(1, 1), blurRadius: 1, color: Color(0xff333333))
          ],
        ),
      )),
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

class PokemonDetails extends StatelessWidget {
  const PokemonDetails(this.pokemon);
  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    final forme = pokemon.forme?.replaceFirst('Totem', '');
    final resourceId = pokemon.forme != null
        ? '${Parser.toId(pokemon.baseSpecies)}${forme.isEmpty ? '' : '-'}${Parser.toId(forme)}'
        : Parser.toId(pokemon.name);

    final pokemonAbilities = [
      pokemon.abilities.first,
      pokemon.abilities.second,
      pokemon.abilities.hidden,
      pokemon.abilities.special,
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 116,
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.black54),
                      borderRadius: BorderRadius.circular(10)),
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://play.pokemonshowdown.com/sprites/gen5/$resourceId.png',
                    placeholder: (context, url) => Container(
                      height: 96,
                      width: 96,
                      child: const Center(
                          heightFactor: 0, child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, dynamic error) =>
                        const Icon(Icons.error),
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
                              vertical: 4, horizontal: 4),
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
                                    border: Border.all(color: Colors.grey[700]),
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Container(width: 64, child: const Text('Types :')),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Abilities :')),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < pokemonAbilities.length; i++)
                          if (pokemonAbilities[i] != null)
                            Row(
                              children: [
                                if (i != 0)
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text('|'),
                                  ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                          builder: (context) => AbilityDetails(
                                              pokemonAbilities[i])),
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
                  )
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
            )
          ],
        ),
      ),
    );
  }
}
