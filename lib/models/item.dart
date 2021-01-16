import 'package:json_annotation/json_annotation.dart';

part 'item.g.dart';

@JsonSerializable()
class Item {
  Item();
  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  @JsonKey(name: 'num')
  int id;

  String name;

  @JsonKey(name: 'spritenum')
  int spriteNum;

  String megaStone;

  String megaEvolves;

  List<String> itemUser;

  int gen;

  String desc;
  String shortDesc;

  @JsonKey(name: 'isNonstandard')
  String isNonStandard;
}
