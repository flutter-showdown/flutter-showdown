import 'package:super_enum/super_enum.dart';
import 'package:json_annotation/json_annotation.dart';

part "global_messages_enums.g.dart";

// **************************************************************************
// Run: flutter pub run build_runner build
// **************************************************************************

//{"id":" Guest 8298217","userid":"guest8298217","name":"Guest 8298217","avatar":"pokemonbreeder-gen4","group":" ","autoconfirmed":false,"status":"","rooms":{}}
//"id":"kokodanskos","userid":"kokodanskos","name":"Kokodanskos","avatar":"pokemonbreederf-gen4","group":" ","autoconfirmed":false,"status":"","rooms":{"lobby":{},"help":{}}}"

@JsonSerializable()
class UserDetails {
  String id;
  String userId = "guest";
  String name = "Guest";
  String avatar;
  String groups;
  bool autoConfirmed;
  String status;
  //List<String> rooms;
  UserDetails();
  factory UserDetails.fromJson(Map<String, dynamic> json) {
    json["avatar"] = json["avatar"].toString();
    return _$UserDetailsFromJson(json);
  }
}

class User {
  String id;
  String username;
  bool named = false;
  String avatar;
  Map settings; //TODO STRUCT SETTINGS
  String registerTime;
}

@superEnum
enum _GlobalMessage {
  @UseClass(User)
  updateUser,
  @UseClass(UserDetails)
  userDetails
}
