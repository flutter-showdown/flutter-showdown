import 'package:flutter/material.dart';
import 'package:flutter_showdown/models/pokemon.dart';
import 'package:provider/provider.dart';
import 'pokemon_card.dart';

class Pokedex extends StatefulWidget {
  @override
  _PokedexState createState() => _PokedexState();
}

class _PokedexState extends State<Pokedex> {
  List<Pokemon> pokedex;
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    pokedex = context.read<List<Pokemon>>();
  }

  void _scrollToTop() {
    controller.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => _scrollToTop(),
          child: const Icon(Icons.arrow_upward),
        ),
        body: ListView.builder(
            controller: controller,
            padding: const EdgeInsets.all(8),
            itemCount: pokedex.length,
            itemBuilder: (_, idx) => PokemonCard(pokedex[idx])),
      ),
    );
  }
}
