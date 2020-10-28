// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stats _$StatsFromJson(Map<String, dynamic> json) {
  return Stats()
    ..hp = json['hp'] as int
    ..atk = json['atk'] as int
    ..def = json['def'] as int
    ..spa = json['spa'] as int
    ..spd = json['spd'] as int
    ..spe = json['spe'] as int;
}

Map<String, dynamic> _$StatsToJson(Stats instance) => <String, dynamic>{
      'hp': instance.hp,
      'atk': instance.atk,
      'def': instance.def,
      'spa': instance.spa,
      'spd': instance.spd,
      'spe': instance.spe,
    };

Abilities _$AbilitiesFromJson(Map<String, dynamic> json) {
  return Abilities()
    ..first = json['0'] as String
    ..second = json['1'] as String
    ..hidden = json['H'] as String
    ..special = json['S'] as String;
}

Map<String, dynamic> _$AbilitiesToJson(Abilities instance) => <String, dynamic>{
      '0': instance.first,
      '1': instance.second,
      'H': instance.hidden,
      'S': instance.special,
    };

Pokemon _$PokemonFromJson(Map<String, dynamic> json) {
  return Pokemon()
    ..id = json['num'] as int
    ..name = json['name'] as String
    ..types = (json['types'] as List)?.map((e) => e as String)?.toList()
    ..baseStats = json['baseStats'] == null
        ? null
        : Stats.fromJson(json['baseStats'] as Map<String, dynamic>)
    ..abilities = json['abilities'] == null
        ? null
        : Abilities.fromJson(json['abilities'] as Map<String, dynamic>)
    ..height = (json['heightm'] as num)?.toDouble()
    ..weight = (json['weightkg'] as num)?.toDouble()
    ..gender = json['gender'] as String ?? 'M/F'
    ..evos = (json['evos'] as List)?.map((e) => e as String)?.toList()
    ..evoLevel = json['evoLevel'] as int
    ..prevo = json['prevo'] as String
    ..baseForme = json['baseForme'] as String
    ..forme = json['forme'] as String
    ..baseSpecies = json['baseSpecies'] as String
    ..otherFormes =
        (json['otherFormes'] as List)?.map((e) => e as String)?.toList()
    ..cosmeticFormes =
        (json['cosmeticFormes'] as List)?.map((e) => e as String)?.toList()
    ..formeOrder =
        (json['formeOrder'] as List)?.map((e) => e as String)?.toList()
    ..changesFrom = json['changesFrom'] as String
    ..canGigantamax = json['canGigantamax'] as String
    ..requiredItem = json['requiredItem'] as String
    ..evoType = json['evoType'] as String
    ..evoItem = json['evoItem'] as String
    ..evoMove = json['evoMove'] as String
    ..evoCondition = json['evoCondition'] as String
    ..tier = json['tier'] as String ?? 'Illegal'
    ..isNonStandard = json['isNonStandard'] as String;
}

Map<String, dynamic> _$PokemonToJson(Pokemon instance) => <String, dynamic>{
      'num': instance.id,
      'name': instance.name,
      'types': instance.types,
      'baseStats': instance.baseStats,
      'abilities': instance.abilities,
      'heightm': instance.height,
      'weightkg': instance.weight,
      'gender': instance.gender,
      'evos': instance.evos,
      'evoLevel': instance.evoLevel,
      'prevo': instance.prevo,
      'baseForme': instance.baseForme,
      'forme': instance.forme,
      'baseSpecies': instance.baseSpecies,
      'otherFormes': instance.otherFormes,
      'cosmeticFormes': instance.cosmeticFormes,
      'formeOrder': instance.formeOrder,
      'changesFrom': instance.changesFrom,
      'canGigantamax': instance.canGigantamax,
      'requiredItem': instance.requiredItem,
      'evoType': instance.evoType,
      'evoItem': instance.evoItem,
      'evoMove': instance.evoMove,
      'evoCondition': instance.evoCondition,
      'tier': instance.tier,
      'isNonStandard': instance.isNonStandard,
    };
