import 'package:flutter/material.dart';
import 'package:flutter_showdown/models/pokemon.dart';
import 'package:flutter_showdown/screens/pokedex/common/pokemon_list_item.dart';
import 'package:provider/provider.dart';

class TierDetails extends StatelessWidget {
  const TierDetails(this.tier);

  final String tier;

  @override
  Widget build(BuildContext context) {
    final dex = Provider.of<Map<String, Pokemon>>(context, listen: false).values.where((e) => tier == e.tier).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(tier),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Pokemons included in $tier :',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dex.length,
                itemBuilder: (_, idx) => Container(
                  child: PokemonListItem(dex[idx]),
                  color: idx % 2 == 0 ? const Color(0xffebebf7) : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
