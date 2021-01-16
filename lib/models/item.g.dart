// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) {
  return Item()
    ..id = json['num'] as int
    ..name = json['name'] as String
    ..spriteNum = json['spritenum'] as int
    ..megaStone = json['megaStone'] as String
    ..megaEvolves = json['megaEvolves'] as String
    ..itemUser = (json['itemUser'] as List)?.map((e) => e as String)?.toList()
    ..gen = json['gen'] as int
    ..desc = json['desc'] as String
    ..shortDesc = json['shortDesc'] as String
    ..isNonStandard = json['isNonstandard'] as String;
}

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'num': instance.id,
      'name': instance.name,
      'spritenum': instance.spriteNum,
      'megaStone': instance.megaStone,
      'megaEvolves': instance.megaEvolves,
      'itemUser': instance.itemUser,
      'gen': instance.gen,
      'desc': instance.desc,
      'shortDesc': instance.shortDesc,
      'isNonstandard': instance.isNonStandard,
    };
