import 'package:flutter/material.dart';
import 'package:flutter_showdown/models/ability.dart';
import 'package:flutter_showdown/models/pokemon.dart';
import 'package:flutter_showdown/parser.dart';
import 'package:flutter_showdown/screens/pokedex/common/pokemon_list_item.dart';
import 'package:provider/provider.dart';

class AbilityDetails extends StatelessWidget {
  const AbilityDetails(this.abilityName, {this.appBarColor});

  final String abilityName;
  final Color appBarColor;

  @override
  Widget build(BuildContext context) {
    final abilityId = Parser.toId(abilityName);
    final ability = Provider.of<Map<String, Ability>>(context, listen: false)[abilityId];

    final dex = Provider.of<Map<String, Pokemon>>(context, listen: false).values
        .where((e) => [e.abilities.first, e.abilities.second, e.abilities.hidden, e.abilities.special].contains(ability.name))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(ability.name),
        backgroundColor: appBarColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                ability.desc,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Pokemons with ${ability.name} :',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dex.length,
              itemBuilder: (_, idx) => Container(
                child: PokemonListItem(dex[idx]),
                color: idx % 2 == 0 ? const Color(0xffebebf7) : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
