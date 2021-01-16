import 'package:flutter/material.dart';
import 'package:flutter_showdown/models/pokemon.dart';
import 'package:flutter_showdown/screens/pokedex/filters_dialog.dart';
import 'package:flutter_showdown/screens/pokedex/items/item_list.dart';
import 'package:flutter_showdown/screens/pokedex/search_bar.dart';
import 'package:flutter_showdown/presentation/custom_icons_icons.dart';
import 'package:provider/provider.dart';
import 'pokemon/pokemon_card.dart';

class Pokedex extends StatefulWidget {
  @override
  _PokedexState createState() => _PokedexState();
}

class _PokedexState extends State<Pokedex> {
  List<Pokemon> pokedex;
  String currentSearch = '';
  Map<String, Pokemon> fullPokedex;
  Filters currentFilters = Filters.clone(defaultFilters);

  @override
  void initState() {
    super.initState();

    fullPokedex = context.read<Map<String, Pokemon>>();
    pokedex = fullPokedex.values.toList();
  }

  void _onSearch(String s) {
    setState(() => currentSearch = s.toLowerCase());
  }

  List<Pokemon> _applyFilters(Filters filters, String search) {
    final res = fullPokedex.values
        .toList()
        // Apply search
        .where((p) => p.name.toLowerCase().contains(search))
        // Apply types filters
        .where((p) =>
            // Does nothing if all filters are unset
            (filters.typesFilters.values.every((e) => e == false) ||
                // Filter by pokemon containing specified types
                filters.typesFilters.entries.where((e) => e.value && p.types.contains(e.key)).isNotEmpty) &&
            // Tier filter
            ((filters.tier == tiers.first) || p.tier == filters.tier))
        .toList();
    if (filters.sortBy != sorts.keys.first) {
      res.sort((l, r) => sorts[filters.sortBy](l, r));
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    pokedex = _applyFilters(currentFilters, currentSearch);

    return SafeArea(
      child: Scaffold(
        drawerEdgeDragWidth: MediaQuery.of(context).size.width,
        drawer: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(4),
              bottomLeft: Radius.circular(4),
            ),
          ),
          child: Column(
            children: [
              IconButton(
                iconSize: 48,
                padding: const EdgeInsets.only(top: 8),
                icon: const Icon(CustomIcons.pokeball),
                onPressed: () {
                  Navigator.pop(context);
                  // TODO(Adrien): Open pokemon list page
                },
              ),
              const Text('Pokemon', style: TextStyle(fontSize: 16)),
              IconButton(
                iconSize: 48,
                padding: const EdgeInsets.only(top: 8),
                icon: const Icon(CustomIcons.pokeball),
                onPressed: () {
                  Navigator.pop(context);
                  // TODO(Adrien): Open pokemon list page
                },
              ),
              const Text('Moves', style: TextStyle(fontSize: 16)),
              IconButton(
                iconSize: 48,
                padding: const EdgeInsets.only(top: 8),
                icon: const Icon(CustomIcons.pokeball),
                onPressed: () {
                  Navigator.pop(context);
                  // TODO(Adrien): Open pokemon list page
                },
              ),
              const Text('Abilities', style: TextStyle(fontSize: 16)),
              IconButton(
                iconSize: 48,
                padding: const EdgeInsets.only(top: 8),
                icon: const Icon(CustomIcons.pokeball),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const ItemList(),
                    ),
                  );
                },
              ),
              const Text('Items', style: TextStyle(fontSize: 16)),
              IconButton(
                iconSize: 48,
                padding: const EdgeInsets.only(top: 8),
                icon: const Icon(CustomIcons.pokeball),
                onPressed: () {
                  // TODO(Adrien): Open pokemon list page
                },
              ),
              const Text('Types', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
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
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: FlatButton(
                        onPressed: () async {
                          final data = await showDialog<Filters>(
                            context: context,
                            builder: (_) => FiltersDialog(currentFilters),
                          );
                          if (data != null) {
                            setState(() => currentFilters = data);
                          }
                        },
                        child: const Icon(Icons.filter_list),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: pokedex.isEmpty
                    ? const Center(child: Text('No match found :('))
                    : ListView.builder(
                        itemCount: pokedex.length,
                        itemBuilder: (_, idx) => PokemonCard(pokedex[idx]),
                      ),
              ),
              const SizedBox(height: kBottomNavigationBarHeight),
            ],
          ),
        ),
      ),
    );
  }
}
