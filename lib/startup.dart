import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_showdown/models/ability.dart';
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

class Startup extends StatelessWidget {
  const Startup({this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([fetchDex(), fetchAbilities()]),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return child;
        }
        if (!snapshot.hasData) {
          // Loading
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final pokedex = snapshot.data[0] as List<Pokemon>;
          final abilities = snapshot.data[1] as Map<String, Ability>;
          return MultiProvider(
            providers: [
              Provider<List<Pokemon>>(create: (_) => pokedex, lazy: false),
              Provider<Map<String, Ability>>(
                  create: (_) => abilities, lazy: false),
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
