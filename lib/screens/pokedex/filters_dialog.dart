import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_showdown/models/pokemon.dart';
import 'package:flutter_showdown/screens/pokedex/common/type_box.dart';

const List<String> tiers = [
  'All',
  '(PU)',
  '(Uber)',
  'CAP',
  'CAP LC',
  'CAP NFE',
  'Illegal',
  'LC',
  'LC Uber',
  'NFE',
  'NU',
  'NUBL',
  'OU',
  'PU',
  'PUBL',
  'RU',
  'RUBL',
  'UU',
  'UUBL',
  'Uber',
  'Unreleased',
];

Map<String, int Function(Pokemon, Pokemon)> sorts = {
  'None': (l, r) => 0,
  'Hp': (l, r) => r.baseStats.hp - l.baseStats.hp,
  'Atk': (l, r) => r.baseStats.atk - l.baseStats.atk,
  'Def': (l, r) => r.baseStats.def - l.baseStats.def,
  'SpA': (l, r) => r.baseStats.spa - l.baseStats.spa,
  'SpD': (l, r) => r.baseStats.spd - l.baseStats.spd,
  'Spe': (l, r) => r.baseStats.spe - l.baseStats.spe,
  'BST': (l, r) => r.baseStats.bst - l.baseStats.bst,
};

const Map<String, bool> defaultTypesFilters = {
  'Bird': false,
  'Bug': false,
  'Dark': false,
  'Dragon': false,
  'Electric': false,
  'Fairy': false,
  'Fighting': false,
  'Fire': false,
  'Flying': false,
  'Ghost': false,
  'Grass': false,
  'Ground': false,
  'Ice': false,
  'Normal': false,
  'Poison': false,
  'Psychic': false,
  'Rock': false,
  'Steel': false,
  'Water': false,
};

Filters defaultFilters = Filters(defaultTypesFilters, tiers.first, sorts.keys.first);

class Filters {
  Filters(this.typesFilters, this.tier, this.sortBy);
  Filters.clone(Filters copy)
      : typesFilters = Map.from(copy.typesFilters),
        tier = copy.tier,
        sortBy = copy.sortBy;

  Map<String, bool> typesFilters;
  String tier;
  String sortBy;
}

class ActionButton extends StatelessWidget {
  const ActionButton(this.text, {this.onPressed});
  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        height: 36,
        color: Colors.transparent,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            child: Center(
              child: Text(
                text,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FiltersDialog extends StatefulWidget {
  const FiltersDialog(this.currentFilters);
  final Filters currentFilters;
  @override
  _FiltersDialogState createState() => _FiltersDialogState();
}

class _FiltersDialogState extends State<FiltersDialog> {
  Filters filters;

  @override
  void initState() {
    super.initState();
    filters = Filters.clone(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(8),
        height: 580,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: LayoutBuilder(
          builder: (_, BoxConstraints viewportConstraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: viewportConstraints.maxHeight),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Types :'),
                      Container(
                        width: 214,
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          alignment: WrapAlignment.center,
                          children: filters.typesFilters.entries.map((e) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  filters.typesFilters[e.key] = !filters.typesFilters[e.key];
                                });
                              },
                              child: ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  e.value ? Colors.white : Colors.grey[600],
                                  BlendMode.modulate,
                                ),
                                child: TypeBox(
                                  e.key,
                                  width: 56,
                                  height: 28,
                                  fontSize: 9,
                                  pressable: false,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text('Tier : '),
                        DropdownButton<String>(
                            value: filters.tier,
                            icon: const Icon(Icons.arrow_downward),
                            iconSize: 18,
                            items: tiers.map((value) {
                              return DropdownMenuItem<String>(value: value, child: Text(value));
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                filters.tier = newValue;
                              });
                            })
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text('Sort by : '),
                        DropdownButton<String>(
                            value: filters.sortBy,
                            icon: const Icon(Icons.arrow_downward),
                            iconSize: 18,
                            items: sorts.keys.map((value) {
                              return DropdownMenuItem<String>(value: value, child: Text(value));
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                filters.sortBy = newValue;
                              });
                            })
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ActionButton('Cancel', onPressed: () {
                        Navigator.of(context).pop();
                      }),
                      ActionButton('All', onPressed: () {
                        setState(() {
                          filters = Filters(filters.typesFilters.map((key, value) => MapEntry(key, true)), tiers.first,
                              sorts.keys.first);
                        });
                      }),
                      ActionButton('Clear', onPressed: () {
                        setState(() {
                          filters = Filters.clone(defaultFilters);
                        });
                      }),
                      ActionButton('Save', onPressed: () {
                        Navigator.of(context).pop(filters);
                      }),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
