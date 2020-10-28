import 'package:json_annotation/json_annotation.dart';

part 'pokemon.g.dart';

@JsonSerializable()
class Stats {
  Stats();
  factory Stats.fromJson(Map<String, dynamic> json) => _$StatsFromJson(json);

  int get bst => hp + atk + def + spa + spd + spe;

  int hp;
  int atk;
  int def;
  int spa;
  int spd;
  int spe;
}

@JsonSerializable()
class Abilities {
  Abilities();
  factory Abilities.fromJson(Map<String, dynamic> json) =>
      _$AbilitiesFromJson(json);

  @JsonKey(name: '0')
  String first;
  @JsonKey(name: '1', nullable: true)
  String second;
  @JsonKey(name: 'H', nullable: true)
  String hidden;
  @JsonKey(name: 'S', nullable: true)
  String special;
}

@JsonSerializable()
class Pokemon {
  Pokemon();
  factory Pokemon.fromJson(Map<String, dynamic> json) =>
      _$PokemonFromJson(json);

  @JsonKey(name: 'num')
  int id;
  String name;
  List<String> types;
  Stats baseStats;
  Abilities abilities;

  @JsonKey(name: 'heightm')
  double height;

  @JsonKey(name: 'weightkg')
  double weight;

  @JsonKey(defaultValue: 'M/F')
  String gender;

  @JsonKey(nullable: true)
  List<String> evos;

  @JsonKey(nullable: true)
  int evoLevel;

  @JsonKey(nullable: true)
  String prevo;

  //
  @JsonKey(nullable: true)
  String baseForme;

  // forme name (e.g. Mega-Y, Gmax)
  @JsonKey(nullable: true)
  String forme;

  // Base pokemon, always here if forme exists
  @JsonKey(nullable: true)
  String baseSpecies;

  // Alternative formes (e.g. Mega / Primal)
  @JsonKey(nullable: true)
  List<String> otherFormes;

  @JsonKey(nullable: true)
  List<String> cosmeticFormes;

  //
  @JsonKey(nullable: true)
  List<String> formeOrder;

  // Gigantamax only : base pokemon
  @JsonKey(nullable: true)
  String changesFrom;

  @JsonKey(nullable: true)
  String canGigantamax;

  // Required item to change into current form
  @JsonKey(nullable: true)
  String requiredItem;

  // item, move, trade, levelFriendship, levelExtra
  @JsonKey(nullable: true)
  String evoType;

  @JsonKey(nullable: true)
  String evoItem;

  @JsonKey(nullable: true)
  String evoMove;

  // Display as is
  @JsonKey(nullable: true)
  String evoCondition;

  @JsonKey(defaultValue: 'Illegal')
  String tier;

  @JsonKey(nullable: true)
  String isNonStandard;
}
