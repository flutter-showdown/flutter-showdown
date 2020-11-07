import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_showdown/models/ability.dart';
import 'package:flutter_showdown/models/move.dart';
import 'package:flutter_showdown/models/pokemon.dart';
import 'package:flutter_showdown/providers/global_messages.dart';
import 'package:flutter_showdown/providers/room_messages.dart';
import 'package:provider/provider.dart';

Future<List<Pokemon>> fetchDex() async {
  final dexJson = await rootBundle.loadString('assets/data/pokedex.json');
  final List<Pokemon> pokemons = [];
  final json = jsonDecode(dexJson) as Map<String, dynamic>;
  json.forEach((key, dynamic value) {
    pokemons.add(Pokemon.fromJson(value as Map<String, dynamic>));
  });
  return pokemons;
}

Future<Map<String, Ability>> fetchAbilities() async {
  final abilitiesJson =
      await rootBundle.loadString('assets/data/abilities.json');
  final Map<String, Ability> abilities = {};
  final json = jsonDecode(abilitiesJson) as Map<String, dynamic>;
  json.forEach((key, dynamic value) {
    abilities[key] = Ability.fromJson(value as Map<String, dynamic>);
  });
  return abilities;
}

// Transform                  into         {
// {                                         "missingno": ["blizzard"]
//   "missingno": {                        }
//     "learnset": {
//       "blizzard": ["3L1"],
//     }
//   }
// }
Future<Map<String, List<String>>> fetchLearnsets() async {
  final learnsetsJson =
      await rootBundle.loadString('assets/data/learnset.json');
  final Map<String, List<String>> learnsets = {};
  final json = jsonDecode(learnsetsJson) as Map<String, dynamic>;
  json.forEach((key, dynamic value) {
    final List<String> learnset = [];
    final dynamic moves = (value as Map<String, dynamic>)['learnset'];
    if (moves != null) {
      (moves as Map<String, dynamic>).forEach((key, dynamic value) {
        learnset.add(key);
      });
      learnsets[key] = learnset;
    }
  });
  return learnsets;
}

Future<Map<String, Move>> fetchMoves() async {
  final movesJson = await rootBundle.loadString('assets/data/moves.json');
  final Map<String, Move> moves = {};
  final json = jsonDecode(movesJson) as Map<String, dynamic>;
  json.forEach((key, dynamic value) {
    moves[key] = Move.fromJson(value as Map<String, dynamic>);
  });
  return moves;
}

class Startup extends StatelessWidget {
  const Startup({this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait(
          [fetchDex(), fetchAbilities(), fetchLearnsets(), fetchMoves()]),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasError) {
          print('Error when loading data: ${snapshot.error}');
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                  create: (_) => RoomMessages(), lazy: false),
              ChangeNotifierProvider(
                  create: (_) => GlobalMessages(), lazy: false),
            ],
            child: child,
          );
        }
        if (!snapshot.hasData) {
          // Loading
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final pokedex = snapshot.data[0] as List<Pokemon>;
          final abilities = snapshot.data[1] as Map<String, Ability>;
          final learnsets = snapshot.data[2] as Map<String, List<String>>;
          final moves = snapshot.data[3] as Map<String, Move>;
          return MultiProvider(
            providers: [
              Provider<List<Pokemon>>(create: (_) => pokedex, lazy: false),
              Provider<Map<String, Ability>>(
                  create: (_) => abilities, lazy: false),
              Provider<Map<String, List<String>>>(
                  create: (_) => learnsets, lazy: false),
              Provider<Map<String, Move>>(create: (_) => moves, lazy: false),
              ChangeNotifierProvider(
                  create: (_) => RoomMessages(), lazy: false),
              ChangeNotifierProvider(
                  create: (_) => GlobalMessages(), lazy: false),
            ],
            child: child,
          );
        }
      },
    );
  }
}
