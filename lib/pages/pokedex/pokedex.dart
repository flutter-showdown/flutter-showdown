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
  String currentSearch = '';
  Filters currentFilters = Filters.clone(defaultFilters);
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    fullPokedex = context.read<List<Pokemon>>();
    pokedex = fullPokedex;
  }

  void _onSearch(String s) {
    setState(() {
      currentSearch = s.toLowerCase();
    });
  }

  List<Pokemon> _applyFilters(Filters filters, String search) {
    final res = fullPokedex
        // Apply search
        .where((p) => p.name.toLowerCase().contains(search))
        // Apply types filters
        .where((p) =>
            filters.typesFilters.entries
                .where((e) => e.value && p.types.contains(e.key))
                .isNotEmpty &&
            // Tier filter
            ((filters.tier == tiers.first) || p.tier == filters.tier))
        .toList();
    if (filters.sortBy != sorts.keys.first) {
      res.sort(sorts[filters.sortBy]);
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    pokedex = _applyFilters(currentFilters, currentSearch);
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
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
                                  currentFilters = data;
                                });
                              }
                            },
                            child: const Icon(Icons.filter_list)))
                  ],
                ),
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
    );
  }
}
