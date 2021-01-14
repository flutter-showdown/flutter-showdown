import 'package:flutter/material.dart';
import 'package:flutter_showdown/models/move.dart';
import 'package:flutter_showdown/screens/pokedex/common/type_box.dart';
import 'package:flutter_showdown/screens/pokedex/moves/move_details.dart';
import 'package:provider/provider.dart';

class MoveCard extends StatelessWidget {
  const MoveCard(this.moveId);

  final String moveId;

  @override
  Widget build(BuildContext context) {
    final Move move =
        Provider.of<Map<String, Move>>(context, listen: false)[moveId];

    return Tooltip(
      message: move.shortDesc,
      preferBelow: false,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (context) => MoveDetails(move)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 96,
                child: Text(
                  move.name,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: TypeBox(
                      move.type,
                      pressable: false,
                      width: 48,
                      height: 16,
                      fontSize: 8,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: TypeBox(
                      move.category,
                      pressable: false,
                      width: 48,
                      height: 16,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
              Container(
                width: 50,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                child: (move.basePower > 0)
                    ? Column(
                        children: [
                          Text(
                            'Power',
                            style:
                                TextStyle(fontSize: 9, color: Colors.grey[600]),
                          ),
                          Text('${move.basePower}'),
                        ],
                      )
                    : Container(),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 50,
                child: Column(
                  children: [
                    Text(
                      'Accuracy',
                      style: TextStyle(fontSize: 9, color: Colors.grey[600]),
                    ),
                    Text(move.accuracy != null ? '${move.accuracy}%' : '-'),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 18,
                child: Column(
                  children: [
                    Text(
                      'PP',
                      style: TextStyle(fontSize: 9, color: Colors.grey[600]),
                    ),
                    Text('${move.pp}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
