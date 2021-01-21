import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_showdown/constants.dart';
import 'package:flutter_showdown/models/item.dart';
import 'package:flutter_showdown/models/pokemon.dart';
import 'package:flutter_showdown/parser.dart';
import 'package:flutter_showdown/screens/pokedex/items/item_details.dart';
import 'package:flutter_showdown/screens/pokedex/ability/ability_details.dart';
import 'package:flutter_showdown/screens/pokedex/common/type_box.dart';
import 'package:flutter_showdown/screens/pokedex/common/type_effectiveness.dart';
import 'package:flutter_showdown/screens/pokedex/moves/move_card.dart';
import 'package:flutter_showdown/screens/common/custom_slivers.dart';
import 'package:flutter_showdown/screens/pokedex/pokemon/tier_details.dart';
import 'package:provider/provider.dart';
import '../common/get_icon_index.dart';

class PokemonDetails extends StatelessWidget {
  const PokemonDetails(this.pokemon);

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    final pokeId = Parser.toId(pokemon.name);
    final forme = pokemon.forme?.replaceFirst('Totem', '');
    final resourceId = pokemon.forme != null
        ? '${Parser.toId(pokemon.baseSpecies)}${forme.isEmpty ? '' : '-'}${Parser.toId(forme)}'
        : pokeId;

    final pokemonAbilities = [
      pokemon.abilities.first,
      pokemon.abilities.second,
      pokemon.abilities.hidden,
      pokemon.abilities.special,
    ];

    final learnsetId = pokemon.forme != null ? Parser.toId(pokemon.baseSpecies) : pokeId;
    final learnsets = Provider.of<Map<String, List<String>>>(context, listen: false);
    final learnset = learnsets[pokeId] ?? learnsets[learnsetId];

    final dex = Provider.of<Map<String, Pokemon>>(context, listen: false);

    Widget _getNextEvo(String pokeName) {
      final poke = dex[Parser.toId(pokeName)];

      return Row(
        children: [
          PokeBox(poke, current: poke.name == pokemon.name),
          if (poke.evos != null)
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(Icons.arrow_right_alt),
            ),
          if (poke.evos != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < poke.evos.length; i++) _getNextEvo(poke.evos[i]),
              ],
            ),
        ],
      );
    }

    Widget _evoTree() {
      Pokemon current = pokemon;

      if (current.prevo == null && current.evos == null) {
        return const Text(
          'Does not evolve',
          style: TextStyle(fontStyle: FontStyle.italic),
        );
      }
      while (current.prevo != null) {
        final prevo = dex[Parser.toId(current.prevo)];

        current = prevo;
      }

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: _getNextEvo(current.name),
      );
    }

    Widget _formesList() {
      final base = pokemon.forme != null ? dex[Parser.toId(pokemon.baseSpecies)] : pokemon;
      final name = base.baseForme ?? 'Base';

      return Wrap(
        spacing: 8,
        direction: Axis.horizontal,
        children: [
          PokeBox(base, label: name, current: base.name == pokemon.name),
          if (base.otherFormes != null)
            ...base.otherFormes.map((f) {
              final poke = dex[Parser.toId(f)];

              return PokeBox(poke, label: poke.forme, current: pokemon.name == poke.name);
            }),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
              colors: <Color>[
                TypeBox.typeColors[pokemon.types[0]][0],
                TypeBox.typeColors[pokemon.types[0]][0],
                TypeBox.typeColors[pokemon.types[pokemon.types.length > 1 ? 1 : 0]][0]
              ],
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFloatingHeader(
            child: Container(
              // Trick to remove the 1px gap
              decoration: BoxDecoration(
                color: ThemeData.light().scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: ThemeData.light().scaffoldBackgroundColor,
                    blurRadius: 0.0,
                    spreadRadius: 0.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 116,
                          height: 116,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                TypeBox.typeColors[pokemon.types[0]][0],
                                TypeBox.typeColors[pokemon.types[pokemon.types.length > 1 ? 1 : 0]][0]
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(2.5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: '$ServerUrl/sprites/gen5/$resourceId.png',
                              placeholder: (context, url) => Container(
                                height: 96,
                                width: 96,
                                child: const Center(
                                  heightFactor: 0,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, dynamic error) => const Icon(Icons.error),
                            ),
                          ),
                        ),
                        Container(
                          width: 232,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 4,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (pokemon.id > 0)
                                        Text(
                                          '#${pokemon.id}',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      GestureDetector(
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute<void>(
                                            builder: (context) => TierDetails(pokemon.tier),
                                          ),
                                        ),
                                        child: Container(
                                          child: Text(pokemon.tier),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4,
                                            horizontal: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey[700]),
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 64,
                                      child: const Text('Types :'),
                                    ),
                                    Row(
                                      children: pokemon.types
                                          .map(
                                            (t) => Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 4,
                                              ),
                                              child: GestureDetector(
                                                onTap: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute<void>(
                                                    builder: (context) => TypeEffectiveness(t),
                                                  ),
                                                ),
                                                child: TypeBox(t, pressable: false),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 64,
                                      child: const Text('Size :'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('${pokemon.height} m, ${pokemon.weight} kg'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8, left: 16),
                    child: Text(
                      'Abilities :',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 16, bottom: 8),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (int i = 0; i < pokemonAbilities.length; i++)
                            if (pokemonAbilities[i] != null)
                              Row(
                                children: [
                                  if (i != 0)
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                      ),
                                      child: Text('|'),
                                    ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (context) => AbilityDetails(
                                            pokemonAbilities[i],
                                            appBarColor: TypeBox.typeColors[pokemon.types[0]][0],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      '${pokemonAbilities[i]}${i == 2 ? ' (H)' : i == 3 ? ' (S)' : ''}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        decoration: TextDecoration.underline,
                                        color: Colors.blue[800],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPinnedHeader(
            child: Container(
              padding: const EdgeInsets.only(left: 8),
              // Trick to remove the 1px gap
              decoration: BoxDecoration(
                color: ThemeData.light().scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: ThemeData.light().scaffoldBackgroundColor,
                    blurRadius: 0.0,
                    spreadRadius: 0.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Base stats :',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        StatBox('HP', pokemon.baseStats.hp),
                        StatBox('Attack', pokemon.baseStats.atk),
                        StatBox('Defense', pokemon.baseStats.def),
                        StatBox('Sp. Atk', pokemon.baseStats.spa),
                        StatBox('Sp. Def', pokemon.baseStats.spd),
                        StatBox('Speed', pokemon.baseStats.spe),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 70,
                                margin: const EdgeInsets.only(right: 8),
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Total :',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              Container(
                                width: 32,
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '${pokemon.baseStats.bst}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverFloatingHeader(
            child: Container(
              color: ThemeData.light().scaffoldBackgroundColor,
              padding: const EdgeInsets.only(top: 8, left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Evolution: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _evoTree(),
                  if (pokemon.prevo != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 4, right: 16),
                      child: EvoText(pokemon),
                    ),
                  if (pokemon.otherFormes != null || pokemon.forme != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Formes:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        _formesList(),
                      ],
                    ),
                  if (pokemon.requiredItem != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Text('Must hold:'),
                          ItemLink(pokemon.requiredItem),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          SliverPinnedHeader(
            child: Container(
              padding: const EdgeInsets.only(left: 16, bottom: 4),
              color: ThemeData.light().scaffoldBackgroundColor,
              child: const Text(
                'Moves: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  if (learnset != null)
                    for (int i = 0; i < learnset.length; i++)
                      Container(
                        color: i % 2 == 0 ? const Color(0xffebebf7) : Colors.white,
                        child: MoveCard(learnset[i]),
                      )
                  else
                    const Text("This pokemon doesn't have a learnset"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ItemLink extends StatelessWidget {
  const ItemLink(this.itemName);

  final String itemName;

  @override
  Widget build(BuildContext context) {
    final items = Provider.of<Map<String, Item>>(context, listen: false);
    final item = items[Parser.toId(itemName)];

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (context) => ItemDetails(item)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 2),
          Image(
            height: 16,
            image: AssetImage('assets/item-icons/${item.spriteNum}.png'),
          ),
          const SizedBox(width: 2),
          Text(
            item.name,
            style: TextStyle(
              color: Colors.blue[800],
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}

class EvoText extends StatelessWidget {
  const EvoText(this.pokemon);

  final Pokemon pokemon;

  String _evoMethod() {
    final condition = pokemon.evoCondition == null ? '' : ' ${pokemon.evoCondition}';

    switch (pokemon.evoType) {
      case 'levelExtra':
        return 'level-up$condition';
      case 'levelFriendship':
        return 'level-up with high Friendship$condition';
      case 'levelMove':
        return 'level-up with ${pokemon.evoMove}$condition';
      case 'other':
        return condition.trim();
      case 'levelHold':
        return 'level-up holding';
      case 'trade':
        return 'trade${pokemon.evoItem != null ? ' holding' : ''}';
      case 'useItem':
        return '';
      default:
        return 'level ${pokemon.evoLevel}$condition';
    }
  }

  @override
  Widget build(BuildContext context) {
    return (['trade', 'levelHold', 'useItem'].contains(pokemon.evoType)) && pokemon.evoItem != null
        ? Row(
            children: [
              Text('Evolves from ${pokemon.prevo} (${_evoMethod()}'),
              if (['trade', 'levelHold', 'useItem'].contains(pokemon.evoType)) ItemLink(pokemon.evoItem),
              const Text(')'),
            ],
          )
        : Text('Evolves from ${pokemon.prevo} (${_evoMethod()})');
  }
}

class PokeBox extends StatelessWidget {
  const PokeBox(this.pokemon, {this.label, this.current = false});

  final String label;
  final bool current;
  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder<PokemonDetails>(
            pageBuilder: (context, _, __) => PokemonDetails(pokemon),
            transitionDuration: const Duration(seconds: 0),
          ),
        );
      },
      child: IntrinsicWidth(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Image.asset('assets/pokemon-icons/${getIconIndex(pokemon)}.png'),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  label ?? pokemon.name,
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontWeight: current ? FontWeight.bold : FontWeight.normal,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class StatBox extends StatelessWidget {
  const StatBox(this.label, this.stat);

  final String label;
  final int stat;

  @override
  Widget build(BuildContext context) {
    final int width = stat.clamp(0, 200).toInt();
    final int color = (stat * 180 / 255).clamp(0, 360).floor();

    return Row(
      children: [
        Container(
          width: 72,
          margin: const EdgeInsets.only(right: 8),
          alignment: Alignment.centerRight,
          child: Text('$label :'),
        ),
        Container(
          width: 32,
          margin: const EdgeInsets.only(right: 8),
          alignment: Alignment.centerRight,
          child: Text(
            '$stat',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 12,
                width: width.toDouble(),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: HSLColor.fromAHSL(1, color.toDouble(), 0.75, 0.35).toColor(),
                  ),
                  borderRadius: BorderRadius.circular(2),
                  color: HSLColor.fromAHSL(1, color.toDouble(), 0.85, 0.45).toColor(),
                ),
              ),
              Positioned(
                top: 1,
                left: 1,
                child: Container(
                  height: 3.2,
                  width: width.toDouble() - (width < 2 ? width : 2),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(2),
                      topRight: Radius.circular(2),
                    ),
                    color: HSLColor.fromAHSL(1, color.toDouble(), 0.85, 0.55).toColor(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
