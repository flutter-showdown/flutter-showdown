// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ability.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ability _$AbilityFromJson(Map<String, dynamic> json) {
  return Ability()
    ..isNonStandard = json['isNonstandart'] as String
    ..name = json['name'] as String
    ..rating = (json['rating'] as num)?.toDouble()
    ..id = json['num'] as int
    ..desc = json['desc'] as String
    ..shortDesc = json['shortDesc'] as String;
}

Map<String, dynamic> _$AbilityToJson(Ability instance) => <String, dynamic>{
      'isNonstandart': instance.isNonStandard,
      'name': instance.name,
      'rating': instance.rating,
      'num': instance.id,
      'desc': instance.desc,
      'shortDesc': instance.shortDesc,
    };
