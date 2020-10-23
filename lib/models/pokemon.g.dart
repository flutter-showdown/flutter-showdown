// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sprites _$SpritesFromJson(Map<String, dynamic> json) {
  return Sprites()
    ..backDefault = json['back_default'] as String
    ..frontDefault = json['front_default'] as String;
}

Map<String, dynamic> _$SpritesToJson(Sprites instance) => <String, dynamic>{
      'back_default': instance.backDefault,
      'front_default': instance.frontDefault,
    };

Pokemon _$PokemonFromJson(Map<String, dynamic> json) {
  return Pokemon()
    ..id = json['id'] as int
    ..name = json['name'] as String
    ..sprites = json['sprites'] == null
        ? null
        : Sprites.fromJson(json['sprites'] as Map<String, dynamic>);
}

Map<String, dynamic> _$PokemonToJson(Pokemon instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sprites': instance.sprites,
    };
