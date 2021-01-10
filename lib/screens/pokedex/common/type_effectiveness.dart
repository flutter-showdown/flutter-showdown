import 'package:flutter/material.dart';
import 'package:flutter_showdown/constants.dart';
import 'package:flutter_showdown/models/pokemon.dart';
import 'package:flutter_showdown/screens/pokedex/common/type_box.dart';
import 'package:flutter_showdown/screens/pokedex/common/get_icon_index.dart';
import 'package:flutter_showdown/screens/pokedex/pokemon/pokemon_details.dart';
import 'package:provider/provider.dart';

class TypeEffectiveness extends StatelessWidget {
  const TypeEffectiveness(this.type);

  final String type;

  @override
  Widget build(BuildContext context) {
    final chart = Typechart[type];
    final spec = TypeSpec[type];
    final List<String> weakAgainst = [];
    final List<String> strongAgainst = [];
    final List<String> noEffectAgainst = [];
    final List<String> immuneTo = chart.entries
        .where((e) => e.value == Effectiveness.Immune)
        .map((e) => e.key)
        .toList();
    final List<String> resists = chart.entries
        .where((e) => e.value == Effectiveness.Resist)
        .map((e) => e.key)
        .toList();

    Typechart.forEach((key, value) {
      value.forEach((k, value) {
        if (k == type) {
          if (value == Effectiveness.Resist) {
            weakAgainst.add(key);
          }
          if (value == Effectiveness.Effective) {
            strongAgainst.add(key);
          }
          if (value == Effectiveness.Immune) {
            noEffectAgainst.add(key);
          }
        }
      });
    });

    final dex = Provider.of<Map<String, Pokemon>>(context, listen: false)
        .values
        .where((e) => e.types.contains(type))
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TypeBox.typeColors[type][0],
        title: Text(type),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Offensive Effectiveness',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (noEffectAgainst.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 4),
                    child: Text('No effect against:'),
                  ),
                  Wrap(
                    children: noEffectAgainst.map((e) => TypeBox(e)).toList(),
                    spacing: 4,
                    runSpacing: 4,
                  ),
                ],
              ),
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 4),
              child: Text('Weak against:'),
            ),
            Wrap(
              children: weakAgainst.map((e) => TypeBox(e)).toList(),
              spacing: 4,
              runSpacing: 4,
            ),
            if (strongAgainst.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 4),
                    child: Text('Strong against:'),
                  ),
                  Wrap(
                    children: strongAgainst.map((e) => TypeBox(e)).toList(),
                    spacing: 4,
                    runSpacing: 4,
                  ),
                ],
              ),
            const Padding(
              padding: EdgeInsets.only(top: 16, bottom: 4),
              child: Text(
                'Defensive Effectiveness',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            if (immuneTo.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 4),
                    child: Text('Immune to:'),
                  ),
                  Wrap(
                    children: immuneTo.map((e) => TypeBox(e)).toList(),
                    spacing: 4,
                    runSpacing: 4,
                  ),
                ],
              ),
            if (resists.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 4),
                    child: Text('Resists'),
                  ),
                  Wrap(
                    children: resists.map((e) => TypeBox(e)).toList(),
                    spacing: 4,
                    runSpacing: 4,
                  ),
                ],
              ),
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 4),
              child: Text('Weak to:'),
            ),
            Wrap(
              children: chart.entries
                  .where((e) => e.value == Effectiveness.Effective)
                  .map((e) => TypeBox(e.key))
                  .toList(),
              spacing: 4,
              runSpacing: 4,
            ),
            if (spec != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(spec),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Text(
                '$type Pokemons',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: dex.length,
                itemBuilder: (_, idx) => Container(
                  child: PokemonListChild(dex[idx]),
                  color: idx % 2 == 0
                      ? TypeBox.typeColors[type][0].withOpacity(0.3)
                      : Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PokemonListChild extends StatelessWidget {
  const PokemonListChild(this.pokemon);

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<void>(
              builder: (context) => PokemonDetails(pokemon)),
        ),
        child: Container(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Image.asset(
                    'assets/pokemon-icons/${getIconIndex(pokemon)}.png'),
              ),
              Expanded(child: Text(pokemon.name)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: pokemon.types
                      .map((t) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: TypeBox(
                              t,
                              width: 58,
                              height: 16,
                              fontSize: 9,
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
