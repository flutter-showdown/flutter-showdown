import 'package:json_annotation/json_annotation.dart';

part 'pokemon.g.dart';

// @JsonSerializable()
// class Ability {
//   final Ability ability;
//   final bool is_hidden;
// }
@JsonSerializable()
class Sprites {
  Sprites();

  factory Sprites.fromJson(Map<String, dynamic> json) =>
      _$SpritesFromJson(json);

  @JsonKey(name: 'back_default', nullable: true)
  String backDefault;
  @JsonKey(name: 'front_default', nullable: true)
  String frontDefault;
}

@JsonSerializable()
class Pokemon {
  Pokemon();

  factory Pokemon.fromJson(Map<String, dynamic> json) =>
      _$PokemonFromJson(json);

  int id;
  String name;
  Sprites sprites;

  // @JsonKey(
  //   fromJson: _parseAbility,
  // )
  // final List<Ability> abilities;
}
