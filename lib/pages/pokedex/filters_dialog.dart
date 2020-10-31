import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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

const Map<String, bool> defaultTypesFilters = {
  'Bird': true,
  'Bug': true,
  'Dark': true,
  'Dragon': true,
  'Electric': true,
  'Fairy': true,
  'Fighting': true,
  'Fire': true,
  'Flying': true,
  'Ghost': true,
  'Grass': true,
  'Ground': true,
  'Ice': true,
  'Normal': true,
  'Poison': true,
  'Psychic': true,
  'Rock': true,
  'Steel': true,
  'Water': true,
};

Filters defaultFilters = Filters(defaultTypesFilters, tiers.first);

class Filters {
  Filters(this.typesFilters, this.tier);
  Filters.clone(Filters copy)
      : typesFilters = Map.from(copy.typesFilters),
        tier = copy.tier;

  Map<String, bool> typesFilters;
  String tier;
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        // height: MediaQuery.of(context).size.height,
        height: 580,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: LayoutBuilder(
          builder: (_, BoxConstraints viewportConstraints) =>
              SingleChildScrollView(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(minHeight: viewportConstraints.maxHeight),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Types :'),
                      Container(
                        width: 220,
                        padding: const EdgeInsets.all(8),
                        child: GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 10,
                          childAspectRatio: 2,
                          crossAxisCount: 4,
                          children: filters.typesFilters.entries.map((e) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  filters.typesFilters[e.key] =
                                      !filters.typesFilters[e.key];
                                });
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: e.value
                                        ? Colors.blue
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.asset(
                                    'assets/types/${e.key}.png',
                                    scale: 0.9,
                                  )),
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Tier : '),
                        DropdownButton<String>(
                            value: filters.tier,
                            icon: const Icon(Icons.arrow_downward),
                            iconSize: 18,
                            items: tiers.map((value) {
                              return DropdownMenuItem<String>(
                                  value: value, child: Text(value));
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                filters.tier = newValue;
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
                      ActionButton('Reset', onPressed: () {
                        setState(() {
                          filters = Filters.clone(defaultFilters);
                        });
                      }),
                      ActionButton('Clear', onPressed: () {
                        setState(() {
                          filters = Filters(
                              filters.typesFilters
                                  .map((key, value) => MapEntry(key, false)),
                              tiers.first);
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
