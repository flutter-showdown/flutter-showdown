import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_showdown/models/pokemon.dart';
import 'package:flutter_showdown/screens/pokedex/ability/ability_details.dart';
import 'package:flutter_showdown/screens/pokedex/common/type_box.dart';
import 'package:flutter_showdown/screens/pokedex/moves/move_card.dart';
import 'package:flutter_showdown/parser.dart';
import 'package:flutter_showdown/constants.dart';
import 'package:provider/provider.dart';
import '../common/get_icon_index.dart';

class PokemonDetails extends StatefulWidget {
  const PokemonDetails(this.pokemon);

  final Pokemon pokemon;

  @override
  _PokemonDetailsState createState() => _PokemonDetailsState();
}

class _PokemonDetailsState extends State<PokemonDetails> {
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final forme = widget.pokemon.forme?.replaceFirst('Totem', '');
    final pokeId = Parser.toId(widget.pokemon.name);
    final resourceId = widget.pokemon.forme != null
        ? '${Parser.toId(widget.pokemon.baseSpecies)}${forme.isEmpty ? '' : '-'}${Parser.toId(forme)}'
        : pokeId;

    final pokemonAbilities = [
      widget.pokemon.abilities.first,
      widget.pokemon.abilities.second,
      widget.pokemon.abilities.hidden,
      widget.pokemon.abilities.special,
    ];

    final learnsetId = widget.pokemon.forme != null
        ? Parser.toId(widget.pokemon.baseSpecies)
        : pokeId;
    final learnsets =
        Provider.of<Map<String, List<String>>>(context, listen: false);
    final learnset = learnsets[pokeId] ?? learnsets[learnsetId];

    final dex = Provider.of<Map<String, Pokemon>>(context, listen: false);

    Widget _getNextEvo(String pokeName) {
      final poke = dex[Parser.toId(pokeName)];
      return Row(
        children: [
          PokeBox(poke, current: poke.name == widget.pokemon.name),
          if (poke.evos != null)
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(Icons.arrow_right_alt),
            ),
          if (poke.evos != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < poke.evos.length; i++)
                  _getNextEvo(poke.evos[i]),
              ],
            ),
        ],
      );
    }

    String _getEvoMethod() {
      final condition = widget.pokemon.evoCondition == null
          ? ''
          : ' ${widget.pokemon.evoCondition}';
      final item = widget.pokemon.evoItem;
      switch (widget.pokemon.evoType) {
        case 'levelExtra':
          return 'level-up$condition';
        case 'levelFriendship':
          return 'level-up with high Friendship$condition';
        case 'levelHold':
          return 'level-up holding $item$condition';
        case 'levelMove':
          return 'level-up with ${widget.pokemon.evoMove}$condition';
        case 'useItem':
          return item;
        case 'trade':
          return 'trade${item != null ? ' holding $item' : ''}';
        case 'other':
          return condition;
        default:
          return 'level ${widget.pokemon.evoLevel}';
      }
    }

    Widget _evoTree() {
      if (widget.pokemon.prevo == null && widget.pokemon.evos == null) {
        return const Text('Does not evolve',
            style: TextStyle(fontStyle: FontStyle.italic));
      }
      Pokemon current = widget.pokemon;
      while (current.prevo != null) {
        final poke = dex[Parser.toId(current.prevo)];
        current = poke;
      }
      final Pokemon base = current;
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: _getNextEvo(base.name),
      );
    }

    Widget _formesList() {
      final base = widget.pokemon.forme != null
          ? dex[Parser.toId(widget.pokemon.baseSpecies)]
          : widget.pokemon;
      final name = base.baseForme ?? 'Base';
      return Wrap(
        direction: Axis.horizontal,
        spacing: 8,
        children: [
          PokeBox(
            base,
            label: name,
            current: base.name == widget.pokemon.name,
          ),
          if (base.otherFormes != null)
            ...base.otherFormes.map((f) {
              final poke = dex[Parser.toId(f)];
              return PokeBox(poke,
                  label: poke.forme, current: widget.pokemon.name == poke.name);
            })
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pokemon.name),
      ),
      body: SingleChildScrollView(
        controller: _controller,
        child: Container(
          height: MediaQuery.of(context).size.height + 200,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 116,
                    height: 116,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          TypeBox.typeColors[widget.pokemon.types[0]][0],
                          TypeBox.typeColors[widget.pokemon.types[
                              widget.pokemon.types.length > 1 ? 1 : 0]][0]
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
                              child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, dynamic error) =>
                            const Icon(Icons.error),
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
                                if (widget.pokemon.id > 0)
                                  Text(
                                    '#${widget.pokemon.id}',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                Container(
                                  child: Text(widget.pokemon.tier),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 4),
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.grey[700]),
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                  width: 64, child: const Text('Types :')),
                              Row(
                                children: widget.pokemon.types
                                    .map((t) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: TypeBox(t),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(width: 64, child: const Text('Size :')),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    '${widget.pokemon.height} m, ${widget.pokemon.weight} kg'),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16, left: 8),
                child: Text('Abilities :'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
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
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text('|'),
                                ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                        builder: (context) => AbilityDetails(
                                            pokemonAbilities[i])),
                                  );
                                },
                                child: Text(
                                    '${pokemonAbilities[i]}${i == 2 ? ' (H)' : i == 3 ? ' (S)' : ''}',
                                    style: TextStyle(
                                        fontSize: 15,
                                        decoration: TextDecoration.underline,
                                        color: Colors.blue[800])),
                              ),
                            ],
                          ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Base stats :',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    StatBox('HP', widget.pokemon.baseStats.hp),
                    StatBox('Attack', widget.pokemon.baseStats.atk),
                    StatBox('Defense', widget.pokemon.baseStats.def),
                    StatBox('Sp. Atk', widget.pokemon.baseStats.spa),
                    StatBox('Sp. Def', widget.pokemon.baseStats.spd),
                    StatBox('Speed', widget.pokemon.baseStats.spe),
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
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                          Container(
                            width: 32,
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${widget.pokemon.baseStats.bst}',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Text('Evolution: '),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _evoTree(),
              ),
              if (widget.pokemon.prevo != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    'Evolves from ${widget.pokemon.prevo} (${_getEvoMethod()})',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              if (widget.pokemon.otherFormes != null ||
                  widget.pokemon.forme != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Formes:'),
                      _formesList(),
                    ],
                  ),
                ),
              if (widget.pokemon.requiredItem != null)
                Text(
                  'Must hold ${widget.pokemon.requiredItem}',
                  style: const TextStyle(fontSize: 12),
                ),
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('Moves: '),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: learnset != null
                      ? ListView.builder(
                          itemCount: learnset.length,
                          itemBuilder: (_, idx) => MoveCard(learnset[idx]),
                        )
                      : const Text("This pokemon doesn't have a learnset"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PokeBox extends StatelessWidget {
  const PokeBox(this.pokemon, {this.label, this.current = false});
  final Pokemon pokemon;
  final bool current;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder<PokemonDetails>(
              pageBuilder: (context, _, __) => PokemonDetails(pokemon),
              transitionDuration: const Duration(seconds: 0),
            ));
      },
      child: IntrinsicWidth(
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Image.asset('assets/pokemon-icons/${getIconIndex(pokemon)}.png'),
              const VerticalDivider(width: 2),
              Text(
                label ?? pokemon.name,
                style: TextStyle(
                    color: Colors.blue[800],
                    fontWeight: current ? FontWeight.bold : FontWeight.normal,
                    decoration: TextDecoration.underline),
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
    int width = stat.floor();
    if (width > 200) {
      width = 200;
    }
    int color = (stat * 180 / 255).floor();
    if (color > 360) {
      color = 360;
    }
    return Row(
      children: [
        Container(
            width: 70,
            margin: const EdgeInsets.only(right: 8),
            alignment: Alignment.centerRight,
            child: Text('$label :')),
        Container(
            width: 32,
            margin: const EdgeInsets.only(right: 8),
            alignment: Alignment.centerRight,
            child: Text('$stat',
                style: const TextStyle(fontWeight: FontWeight.bold))),
        Expanded(
          child: Stack(children: [
            Container(
              height: 12,
              width: width.toDouble(),
              decoration: BoxDecoration(
                border: Border.all(
                    color: HSLColor.fromAHSL(1, color.toDouble(), 0.75, 0.35)
                        .toColor()),
                borderRadius: BorderRadius.circular(2),
                color: HSLColor.fromAHSL(1, color.toDouble(), 0.85, 0.45)
                    .toColor(),
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
                      topRight: Radius.circular(2)),
                  color: HSLColor.fromAHSL(1, color.toDouble(), 0.85, 0.55)
                      .toColor(),
                ),
              ),
            ),
          ]),
        )
      ],
    );
  }
}
