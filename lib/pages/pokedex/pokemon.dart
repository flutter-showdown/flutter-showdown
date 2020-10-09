import 'package:json_annotation/json_annotation.dart';

part 'pokemon.g.dart';

// @JsonSerializable()
// class Ability {
//   final Ability ability;
//   final bool is_hidden;
// }

@JsonSerializable()
class Pokemon {
  Pokemon();

  factory Pokemon.fromJson(Map<String, dynamic> json) =>
      _$PokemonFromJson(json);

  int id;
  String name;

  // @JsonKey(
  //   fromJson: _parseAbility,
  // )
  // final List<Ability> abilities;
}
