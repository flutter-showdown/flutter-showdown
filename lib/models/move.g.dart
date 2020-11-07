// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'move.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Move _$MoveFromJson(Map<String, dynamic> json) {
  return Move()
    ..id = json['num'] as int
    ..basePower = json['basePower'] as int
    ..category = json['category'] as String
    ..isNonStandard = json['isNonstandard'] as String
    ..name = json['name'] as String
    ..pp = json['pp'] as int
    ..priority = json['priority'] as int
    ..flags = (json['flags'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as int),
    )
    ..target = json['target'] as String
    ..type = json['type'] as String
    ..desc = json['desc'] as String
    ..shortDesc = json['shortDesc'] as String;
}

Map<String, dynamic> _$MoveToJson(Move instance) => <String, dynamic>{
      'num': instance.id,
      'basePower': instance.basePower,
      'category': instance.category,
      'isNonstandard': instance.isNonStandard,
      'name': instance.name,
      'pp': instance.pp,
      'priority': instance.priority,
      'flags': instance.flags,
      'target': instance.target,
      'type': instance.type,
      'desc': instance.desc,
      'shortDesc': instance.shortDesc,
    };
