import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../utils.dart';

class AvatarDialog extends StatelessWidget {
  static final _trainerList = compute(
    splitImages,
    SplitParameters(ServerUrl + '/sprites/trainers-sheet.png', 16, 19),
  );

  List<Widget> _getTiles(BuildContext context, List<Image> list) {
    final List<Widget> tiles = <Widget>[];

    for (int i = 0; i < list.length; i++) {
      tiles.add(InkWell(
        child: list[i],
        onTap: () {
          Navigator.of(context).pop(i + 1);
        },
      ));
    }
    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose an Avatar'),
      contentPadding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0.0),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.90,
        height: MediaQuery.of(context).size.height * 0.60,
        child: FutureBuilder(
          future: _trainerList,
          builder: (BuildContext context, AsyncSnapshot<List<Image>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return GridView.count(
                crossAxisCount: 5,
                children: _getTiles(context, snapshot.data),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: const Text('Close'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}