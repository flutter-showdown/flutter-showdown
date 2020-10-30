import 'package:flutter/material.dart';
import 'package:flutter_showdown/models/pokemon.dart';
import 'package:flutter_showdown/pages/pokedex/filters_dialog.dart';
import 'package:flutter_showdown/pages/pokedex/search_bar.dart';
import 'package:provider/provider.dart';
import 'pokemon_card.dart';

class Pokedex extends StatefulWidget {
  @override
  _PokedexState createState() => _PokedexState();
}

class _PokedexState extends State<Pokedex> {
  List<Pokemon> fullPokedex;
  List<Pokemon> pokedex;
  Filters currentFilters = Filters.clone(defaultFilters);
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    fullPokedex = context.read<List<Pokemon>>();
    pokedex = fullPokedex;
  }

  void _onSearch(String s) {
    final search = s.toLowerCase();
    setState(() {
      pokedex = fullPokedex
          .where((p) => p.name.toLowerCase().contains(search))
          .toList();
    });
  }

  List<Pokemon> _applyFilters(Filters filters) {
    return fullPokedex
        .where((p) => filters.typesFilters.entries
            .where((e) => e.value && p.types.contains(e.key))
            .isNotEmpty)
        .toList();
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
        body: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      flex: 5,
                      child: SearchBar(
                        onSearch: _onSearch,
                        placeholder: 'Search pokemon here...',
                        autofillHints: pokedex.map((p) => p.name),
                      ),
                    ),
                    Flexible(
                        flex: 1,
                        child: FlatButton(
                            onPressed: () async {
                              final data = await showDialog<Filters>(
                                  context: context,
                                  builder: (_) =>
                                      FiltersDialog(currentFilters));
                              if (data != null) {
                                setState(() {
                                  pokedex = _applyFilters(data);
                                  currentFilters = data;
                                });
                              }
                            },
                            child: const Icon(Icons.filter_list)))
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                      controller: controller,
                      itemCount: pokedex.length,
                      itemBuilder: (_, idx) => PokemonCard(pokedex[idx])),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
