import 'package:flutter/material.dart';
import 'package:flutter_showdown/models/pokemon.dart';
import 'package:flutter_showdown/screens/pokedex/common/type_box.dart';
import 'package:flutter_showdown/screens/pokedex/common/get_icon_index.dart';
import 'package:flutter_showdown/screens/pokedex/pokemon/pokemon_details.dart';

class PokemonListItem extends StatelessWidget {
  const PokemonListItem(this.pokemon);

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (context) => PokemonDetails(pokemon),
          ),
        ),
        child: Container(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Container(
                  height: 30,
                  child: Image.asset(
                    'assets/pokemon-icons/${getIconIndex(pokemon)}.png',
                  ),
                ),
              ),
              Expanded(child: Text(pokemon.name)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    TypeBox(
                      pokemon.types[0],
                      width: 48,
                      height: 16,
                      fontSize: 9,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(4),
                        bottomLeft: const Radius.circular(4),
                        topRight: Radius.circular(pokemon.types.length > 1 ? 0 : 4),
                        bottomRight: Radius.circular(pokemon.types.length > 1 ? 0 : 4),
                      ),
                    ),
                    if (pokemon.types.length > 1)
                      TypeBox(
                        pokemon.types[1],
                        width: 48,
                        height: 16,
                        fontSize: 9,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(4),
                          bottomRight: Radius.circular(4),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
