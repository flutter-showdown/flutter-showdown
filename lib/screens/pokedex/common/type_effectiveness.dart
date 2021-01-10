import 'package:flutter/material.dart';
import 'package:flutter_showdown/constants.dart';
import 'package:flutter_showdown/screens/pokedex/common/type_box.dart';

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
              child: Text('Weak Against:'),
            ),
            Wrap(
              children: weakAgainst.map((e) => TypeBox(e)).toList(),
              spacing: 4,
              runSpacing: 4,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 4),
              child: Text('Strong Against:'),
            ),
            Wrap(
              children: strongAgainst.map((e) => TypeBox(e)).toList(),
              spacing: 4,
              runSpacing: 4,
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
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 4),
              child: Text('Resist:'),
            ),
            Wrap(
              children: chart.entries
                  .where((e) => e.value == Effectiveness.Resist)
                  .map((e) => TypeBox(e.key))
                  .toList(),
              spacing: 4,
              runSpacing: 4,
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
              )
          ],
        ),
      ),
    );
  }
}
