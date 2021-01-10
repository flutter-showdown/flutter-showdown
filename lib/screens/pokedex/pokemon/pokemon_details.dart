import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_showdown/models/pokemon.dart';
import 'package:flutter_showdown/screens/pokedex/ability/ability_details.dart';
import 'package:flutter_showdown/screens/pokedex/common/type_box.dart';
import 'package:flutter_showdown/screens/pokedex/common/type_effectiveness.dart';
import 'package:flutter_showdown/screens/pokedex/moves/move_card.dart';
import 'package:flutter_showdown/parser.dart';
import 'package:flutter_showdown/constants.dart';
import 'package:provider/provider.dart';
import '../common/get_icon_index.dart';

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        child: child,
        height: constraints.maxHeight,
        color: ThemeData.light().scaffoldBackgroundColor,
      );
    });
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

//https://github.com/flutter/flutter/issues/44557
class SliverPinnedBoxAdapter extends SingleChildRenderObjectWidget {
  const SliverPinnedBoxAdapter({
    @required this.child,
    Key key,
  }) : super(key: key, child: child);

  final Widget child;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderSliverPinnedBoxAdapter();
  }
}

class _RenderSliverPinnedBoxAdapter extends RenderSliverSingleBoxAdapter {
  _RenderSliverPinnedBoxAdapter({RenderBox child}) : super(child: child);

  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }

    child.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child.size.width;
        break;
      case Axis.vertical:
        childExtent = child.size.height;
        break;
    }

    assert(childExtent != null);

    final double paintedChildSize =
        calculatePaintOffset(constraints, from: 0.0, to: childExtent);
    final double cacheExtent =
        calculateCacheOffset(constraints, from: 0.0, to: childExtent);

    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);

    geometry = SliverGeometry(
      scrollExtent: childExtent,
      paintExtent: paintedChildSize,
      cacheExtent: cacheExtent,
      maxPaintExtent: childExtent,
      hitTestExtent: childExtent,
      hasVisualOverflow: childExtent > constraints.remainingPaintExtent ||
          constraints.scrollOffset > 0.0,
      paintOrigin: constraints.overlap,
      visible: true,
    );
  }

  @override
  double childMainAxisPosition(RenderBox child) => constraints.overlap;
}

class PokemonDetails extends StatefulWidget {
  const PokemonDetails(this.pokemon);

  final Pokemon pokemon;

  @override
  _PokemonDetailsState createState() => _PokemonDetailsState();
}

class _PokemonDetailsState extends State<PokemonDetails> {
  @override
  void initState() {
    super.initState();
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
          return condition.trim();
        default:
          return 'level ${widget.pokemon.evoLevel}$condition';
      }
    }

    Widget _evoTree() {
      if (widget.pokemon.prevo == null && widget.pokemon.evos == null) {
        return const Text(
          'Does not evolve',
          style: TextStyle(fontStyle: FontStyle.italic),
        );
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

    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              floating: true,
              delegate: _SliverAppBarDelegate(
                minHeight: 240,
                maxHeight: 240,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppBar(title: Text(widget.pokemon.name)),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
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
                                      TypeBox.typeColors[
                                          widget.pokemon.types[0]][0],
                                      TypeBox.typeColors[widget.pokemon.types[
                                          widget.pokemon.types.length > 1
                                              ? 1
                                              : 0]][0]
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
                                    imageUrl:
                                        '$ServerUrl/sprites/gen5/$resourceId.png',
                                    placeholder: (context, url) => Container(
                                      height: 96,
                                      width: 96,
                                      child: const Center(
                                        heightFactor: 0,
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                    errorWidget:
                                        (context, url, dynamic error) =>
                                            const Icon(Icons.error),
                                  ),
                                ),
                              ),
                              Container(
                                width: 232,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4,
                                          horizontal: 4,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            if (widget.pokemon.id > 0)
                                              Text(
                                                '#${widget.pokemon.id}',
                                                style: TextStyle(
                                                    color: Colors.grey[600]),
                                              ),
                                            Container(
                                              child: Text(widget.pokemon.tier),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey[700]),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                              width: 64,
                                              child: const Text('Types :')),
                                          Row(
                                            children: widget.pokemon.types
                                                .map(
                                                  (t) => Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 4),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute<
                                                              void>(
                                                            builder: (context) =>
                                                                TypeEffectiveness(
                                                                    t),
                                                          ),
                                                        );
                                                      },
                                                      child: TypeBox(t,
                                                          pressable: false),
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
                                            child: Text(
                                                '${widget.pokemon.height} m, ${widget.pokemon.weight} kg'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 8, left: 8),
                            child: Text(
                              'Abilities :',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8, left: 8),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  for (int i = 0;
                                      i < pokemonAbilities.length;
                                      i++)
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
                                                  builder: (context) =>
                                                      AbilityDetails(
                                                    pokemonAbilities[i],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              '${pokemonAbilities[i]}${i == 2 ? ' (H)' : i == 3 ? ' (S)' : ''}',
                                              style: TextStyle(
                                                fontSize: 15,
                                                decoration:
                                                    TextDecoration.underline,
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
                  ],
                ),
              ),
            ),
            SliverPinnedBoxAdapter(
              child: Container(
                padding: const EdgeInsets.only(left: 8),
                color: ThemeData.light().scaffoldBackgroundColor,
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
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 32,
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '${widget.pokemon.baseStats.bst}',
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
                    const SizedBox(height: 8),
                    const Text(
                      'Evolution: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    _evoTree(),
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
                    if (widget.pokemon.requiredItem != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          'Must hold ${widget.pokemon.requiredItem}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    const Text(
                      'Moves: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  if (learnset != null)
                    for (int i = 0; i < learnset.length; i++)
                      MoveCard(learnset[i])
                  else
                    const Text("This pokemon doesn't have a learnset"),
                ],
              ),
            )
          ],
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
    final int width = stat.clamp(0, 200).toInt();
    final int color = (stat * 180 / 255).clamp(0, 360).floor();
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
