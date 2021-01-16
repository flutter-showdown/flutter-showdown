import 'package:flutter/material.dart';
import 'package:flutter_showdown/models/move.dart';
import 'package:flutter_showdown/models/pokemon.dart';
import 'package:flutter_showdown/parser.dart';
import 'package:flutter_showdown/screens/pokedex/common/pokemon_list_item.dart';
import 'package:flutter_showdown/screens/pokedex/common/type_box.dart';
import 'package:provider/provider.dart';

class MoveDetails extends StatefulWidget {
  const MoveDetails(this.move);

  final Move move;

  @override
  _MoveDetailsState createState() => _MoveDetailsState();
}

class _MoveDetailsState extends State<MoveDetails> {
  int i = 0;
  List<Pokemon> pokemons = [];
  final List<Pokemon> dex = [];
  final ScrollController _scrollController = ScrollController();

  String getTargetDesc() {
    if (widget.move.target == 'allAdjacent') {
      return 'In Doubles, hits all adjacent Pokémon (including allies)';
    } else if (widget.move.target == 'allAdjacentFoes') {
      return 'In Doubles, hits all adjacent foes';
    }
    return null;
  }

  String getPriorityDesc() {
    if (widget.move.priority > 1) {
      return 'Nearly always moves first (priority +${widget.move.priority})';
    } else if (widget.move.priority <= -1) {
      return 'Nearly always moves last (priority ${widget.move.priority})';
    } else if (widget.move.priority == 1) {
      return 'Usually moves first (priority +${widget.move.priority})';
    }
    return null;
  }

  List<Pokemon> _fillDex(int count) {
    final List<Pokemon> list = [];
    final learnsets = Provider.of<Map<String, List<String>>>(context, listen: false);

    for (; i < pokemons.length && list.length < count; i++) {
      final current = pokemons[i];
      final pokeId = Parser.toId(current.name);
      final learnsetId = current.forme != null ? Parser.toId(current.baseSpecies) : pokeId;
      final learnset = learnsets[pokeId] ?? learnsets[learnsetId];

      if (learnset == null) {
        continue;
      } else if (learnset.contains(Parser.toId(widget.move.name))) {
        list.add(current);
      }
    }
    return list;
  }

  @override
  void initState() {
    super.initState();

    pokemons = Provider.of<Map<String, Pokemon>>(context, listen: false).values.toList();

    dex.addAll(_fillDex(30));
    _scrollController.addListener(() {
      if (i < pokemons.length &&
          _scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - _scrollController.position.viewportDimension / 2) {
        setState(() {
          dex.addAll(_fillDex(5));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String targetDesc = getTargetDesc();
    final String priorityDesc = getPriorityDesc();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.move.name),
        backgroundColor: TypeBox.typeColors[widget.move.type][0],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                  TypeBox(widget.move.type),
                  const VerticalDivider(width: 8),
                  TypeBox(widget.move.category, pressable: false),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.move.basePower > 0)
                    Column(
                      children: [
                        const Text(
                          'Base power:',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          '${widget.move.basePower}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                        widget.move.accuracy != null ? '${widget.move.accuracy}%' : '-',
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
                        '${widget.move.pp}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        '(max: ${widget.move.ppMax})',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (targetDesc != null) Text(targetDesc, style: TextStyle(color: Colors.grey[600])),
            if (priorityDesc != null) Text(priorityDesc),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(widget.move.desc),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Pokemons that can learn ${widget.move.name} :',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dex.length,
              itemBuilder: (_, idx) => Container(
                child: PokemonListItem(dex[idx]),
                color: idx % 2 == 0 ? TypeBox.typeColors[widget.move.type][0].withOpacity(0.3) : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
