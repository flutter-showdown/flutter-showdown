import 'package:flutter/material.dart';
import 'package:flutter_showdown/models/move.dart';
import 'package:flutter_showdown/models/pokemon.dart';
import 'package:flutter_showdown/parser.dart';
import 'package:flutter_showdown/screens/pokedex/common/pokemon_list_item.dart';
import 'package:flutter_showdown/screens/pokedex/common/type_box.dart';
import 'package:provider/provider.dart';

class MoveDetails extends StatelessWidget {
  const MoveDetails(this.move);

  final Move move;

  String getTargetDesc() {
    if (move.target == 'allAdjacent')
      return 'In Doubles, hits all adjacent Pokémon (including allies)';
    if (move.target == 'allAdjacentFoes')
      return 'In Doubles, hits all adjacent foes';
    return null;
  }

  String getPriorityDesc() {
    if (move.priority > 1)
      return 'Nearly always moves first (priority +${move.priority})';
    if (move.priority <= -1)
      return 'Nearly always moves last (priority ${move.priority})';
    if (move.priority == 1)
      return 'Usually moves first (priority +${move.priority})';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final String targetDesc = getTargetDesc();
    final String priorityDesc = getPriorityDesc();

    final learnsets =
        Provider.of<Map<String, List<String>>>(context, listen: false);

    final dex = Provider.of<Map<String, Pokemon>>(context, listen: false)
        .values
        .where((e) {
      final pokeId = Parser.toId(e.name);
      final learnsetId = e.forme != null ? Parser.toId(e.baseSpecies) : pokeId;
      final learnset = learnsets[pokeId] ?? learnsets[learnsetId];
      if (learnset == null) {
        return false;
      }
      return learnset.contains(Parser.toId(move.name));
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(move.name),
        backgroundColor: TypeBox.typeColors[move.type][0],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Type :',
                style: TextStyle(fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    TypeBox(move.type),
                    const VerticalDivider(width: 8),
                    TypeBox(move.category, pressable: false),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (move.basePower > 0)
                      Column(
                        children: [
                          const Text(
                            'Base power:',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            '${move.basePower}',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    Column(
                      children: [
                        const Text(
                          'Accuracy:',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          move.accuracy != null ? '${move.accuracy}%' : '-',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PP:',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          '${move.pp}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          '(max: ${move.ppMax})',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (targetDesc != null)
                Text(targetDesc, style: TextStyle(color: Colors.grey[600])),
              if (priorityDesc != null) Text(priorityDesc),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(move.desc),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Pokemons that can learn ${move.name} :',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dex.length,
                itemBuilder: (_, idx) => Container(
                  child: PokemonListItem(dex[idx]),
                  color: idx % 2 == 0
                      ? TypeBox.typeColors[move.type][0].withOpacity(0.3)
                      : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
