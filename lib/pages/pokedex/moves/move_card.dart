import 'package:flutter/material.dart';
import 'package:flutter_showdown/models/move.dart';
import 'package:flutter_showdown/pages/pokedex/moves/move_details.dart';
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
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (context) => MoveDetails(move)),
            );
          },
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
                    )),
                Row(
                  children: [
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        width: 32,
                        child: Image.asset('assets/types/${move.type}.png')),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        width: 32,
                        child: Image.asset(
                            'assets/categories/${move.category}.png')),
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
                              style: TextStyle(
                                  fontSize: 9, color: Colors.grey[600]),
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
      ),
    );
  }
}
