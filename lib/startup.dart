import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_showdown/models/pokemon.dart';
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

class Startup extends StatelessWidget {
  const Startup({this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchDex(),
      builder: (BuildContext context, AsyncSnapshot<List<Pokemon>> snapshot) {
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
          final data = snapshot.data;
          return Provider.value(
            value: data,
            child: child,
          );
        }
      },
    );
  }
}
