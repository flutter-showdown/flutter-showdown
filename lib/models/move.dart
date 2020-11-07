import 'package:json_annotation/json_annotation.dart';

part 'move.g.dart';

@JsonSerializable()
class Move {
  Move();
  factory Move.fromJson(Map<String, dynamic> json) {
    final moves = _$MoveFromJson(json);
    moves.accuracy = json['accuracy'] is bool ? null : json['accuracy'] as int;
    return moves;
  }

  @JsonKey(name: 'num')
  int id;

  @JsonKey(ignore: true)
  int accuracy;

  int basePower;

  String category;

  @JsonKey(name: 'isNonstandard')
  String isNonStandard;

  String name;

  int pp;

  int get ppMax => pp * 8 ~/ 5;

  int priority;

  Map<String, int> flags;

  // Map<String, int> condition;

  String target;

  String type;

  String desc;

  String shortDesc;
}
