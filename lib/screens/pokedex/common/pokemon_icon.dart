import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_showdown/constants.dart';
import 'package:flutter_showdown/models/pokemon.dart';
import 'package:flutter_showdown/parser.dart';

int getIconIndex(Pokemon pokemon) {
  // if (pokemon.id < 0 || pokemon.id > 893) {
  //   return 0;
  // }

  final id = Parser.toId(pokemon.name);

  if (BattlePokemonIconIndexes.containsKey(id)) {
    return BattlePokemonIconIndexes[id];
  }
  return pokemon.id;
}

Future<Image> getIcon(String path) async {
  try {
    final asset = await rootBundle.load(path);
    return Image.memory(asset.buffer.asUint8List());
  } catch (_) {
    return Image.asset('assets/pokemon-icons/0.png');
  }
}

class PokemonIcon extends StatelessWidget {
  const PokemonIcon(this.pokemon);
  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getIcon('assets/pokemon-icons/${getIconIndex(pokemon)}.png'),
      builder: (_, AsyncSnapshot<Image> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return snapshot.data;
        } else {
          return Container();
        }
      },
    );
  }
}
