import 'package:flutter_showdown/constants.dart';
import 'package:flutter_showdown/models/pokemon.dart';
import 'package:flutter_showdown/parser.dart';

int getIconIndex(Pokemon pokemon) {
  // if (pokemon.id < 0 || pokemon.id > 893) {
  //   return 0;
  // }

  final id = Parser.toId(pokemon.name);

  if (BattlePokemonIconIndexes.containsKey(id))
    return BattlePokemonIconIndexes[id];
  return pokemon.id;
}
