import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './pokemon.dart';
import 'pokemon_card.dart';
import '../components/input_speech_to_to_text.dart';

const LIMIT = 20;

Future<List<Pokemon>> fetchPokemons() async {
  final response =
      await http.get('https://pokeapi.co/api/v2/pokemon/?limit=$LIMIT');
  final List<Pokemon> pokemons = [];
  if (response.statusCode == 200) {
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final dynamic res = json['results'];
    for (var i = 0; i < LIMIT; i++) {
      final r = await http.get(res[i]['url']);
      if (r.statusCode == 200) {
        pokemons
            .add(Pokemon.fromJson(jsonDecode(r.body) as Map<String, dynamic>));
      }
    }
    return pokemons;
  } else
    throw Exception('Failed to fetch pokemons');
}

class Pokedex extends StatefulWidget {
  @override
  _PokedexState createState() => _PokedexState();
}

class _PokedexState extends State<Pokedex> {
  Future<List<Pokemon>> futurePokemons;

  @override
  void initState() {
    super.initState();
    futurePokemons = fetchPokemons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokedex'),
      ),
      body: MySpeechToText(),
      // body: FutureBuilder<List<Pokemon>>(
      //   future: futurePokemons,
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData) {
      //       return ListView.builder(
      //           padding: const EdgeInsets.all(8),
      //           itemCount: snapshot.data.length,
      //           itemBuilder: (_, idx) => PokemonCard(snapshot.data[idx]));
      //     } else if (snapshot.hasError) {
      //       return Text('${snapshot.error}');
      //     }
      //     // By default, show a loading spinner.
      //     return const CircularProgressIndicator();
      //   },
      // ),
    );
  }
}
