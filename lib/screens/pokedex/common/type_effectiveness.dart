import 'package:flutter/material.dart';
import 'package:flutter_showdown/constants.dart';
import 'package:flutter_showdown/models/pokemon.dart';
import 'package:flutter_showdown/screens/pokedex/common/pokemon_list_item.dart';
import 'package:flutter_showdown/screens/pokedex/common/type_box.dart';
import 'package:provider/provider.dart';

class TypeEffectiveness extends StatelessWidget {
  TypeEffectiveness(this.type)
      : spec = TypeSpec[type],
        chart = Typechart[type];

  final String type;
  final String spec;
  final Map<String, Effectiveness> chart;

  Widget wrappedTypes(String title, List<String> types) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          child: Text(title),
          padding: const EdgeInsets.only(top: 8, bottom: 4),
        ),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: types.map((e) => TypeBox(e)).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> weakAgainst = [];
    final List<String> strongAgainst = [];
    final List<String> noEffectAgainst = [];

    final List<String> immuneTo =
        chart.entries.where((e) => e.value == Effectiveness.Immune).map((e) => e.key).toList();
    final List<String> resists = chart.entries.where((e) => e.value == Effectiveness.Resist).map((e) => e.key).toList();
    final List<String> weakTo =
        chart.entries.where((e) => e.value == Effectiveness.Effective).map((e) => e.key).toList();
    final dex =
        Provider.of<Map<String, Pokemon>>(context, listen: false).values.where((e) => e.types.contains(type)).toList();

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

    return Scaffold(
      appBar: AppBar(
        title: Text(type),
        backgroundColor: TypeBox.typeColors[type][0],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Offensive Effectiveness',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (noEffectAgainst.isNotEmpty) wrappedTypes('No effect against:', noEffectAgainst),
            wrappedTypes('Weak against:', weakAgainst),
            wrappedTypes('Strong against:', strongAgainst),
            const Padding(
              padding: EdgeInsets.only(top: 16, bottom: 4),
              child: Text(
                'Defensive Effectiveness',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            if (immuneTo.isNotEmpty) wrappedTypes('Immune to:', immuneTo),
            wrappedTypes('Resists', resists),
            wrappedTypes('Weak to:', weakTo),
            if (spec != null)
              Padding(
                child: Text(spec),
                padding: const EdgeInsets.symmetric(vertical: 8.0),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Text(
                '$type Pokemons',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dex.length,
              itemBuilder: (_, idx) => Container(
                child: PokemonListItem(dex[idx]),
                color: idx % 2 == 0 ? TypeBox.typeColors[type][0].withOpacity(0.3) : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
