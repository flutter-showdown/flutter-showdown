import 'package:json_annotation/json_annotation.dart';

part 'ability.g.dart';

@JsonSerializable()
class Ability {
  Ability();
  factory Ability.fromJson(Map<String, dynamic> json) =>
      _$AbilityFromJson(json);

  @JsonKey(name: 'isNonstandart')
  String isNonStandard;
  String name;
  double rating;
  @JsonKey(name: 'num')
  int id;
  String desc;
  String shortDesc;
}
