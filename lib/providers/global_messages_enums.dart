import 'package:super_enum/super_enum.dart';
import 'package:json_annotation/json_annotation.dart';

import '../parser.dart';


part 'global_messages_enums.g.dart';

// **************************************************************************
// Run: flutter pub run build_runner build
// **************************************************************************
@JsonSerializable()
class UserDetails {
  UserDetails();

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    json['avatar'] = json['avatar'].toString();

    final UserDetails details = _$UserDetailsFromJson(json);

    (json['rooms'] as Map<String, dynamic>).keys.toList().forEach((room) {
      details.rooms.add(room);
    });
    return details;
  }

  String id;
  String userid;
  String name;
  String avatar;
  String group;
  String status;
  @JsonKey(ignore: true)
  List<String> rooms = [];
  @JsonKey(ignore: true)
  List<String> battles = [];
}

class User {
  String name = 'Guest';
  String group = '';
  String userId = 'guest';
  String avatar = '1';
  String status = '';
  bool named = false;
  bool registered = false;

  void setName(String fullName, bool newNamed, String newAvatar) {
    final List<String> args = Parser.parseName(fullName);

    name = args[0];
    group = args[1];
    userId = Parser.toId(name);
    avatar = newAvatar;
    status = args[2];
    named = newNamed;
  }
}

@superEnum
enum _GlobalMessage {
  @UseClass(User)
  updateUser
}

// **************************************************************************
// Rooms
// **************************************************************************
@JsonSerializable()
class AvailableRooms {
  AvailableRooms();

  factory AvailableRooms.fromJson(Map<String, dynamic> json) => _$AvailableRoomsFromJson(json);

  List<RoomInfo> official = [];
  List<RoomInfo> pspl = [];
  List<RoomInfo> chat = [];
  int userCount;
  int battleCount;
}

@JsonSerializable(nullable: true)
class RoomInfo {
  RoomInfo();

  RoomInfo.title(this.title);

  factory RoomInfo.fromJson(Map<String, dynamic> json) {
    final roomInfo = _$RoomInfoFromJson(json);

    roomInfo.id = Parser.toId(roomInfo.title);

    return roomInfo;
  }

  String title;
  @JsonKey(ignore: true)
  String id;
  String desc;
  int userCount;
  @JsonKey(nullable: true, defaultValue: <List<String>>[])
  List<String> subRooms;
}

class RoomUser{
  RoomUser(this.name, this.group, this.status);

  String name;
  String group;
  String status;
}

class UserMessage {
  int time;
  String sender;
  String content;
}

class Room {
  Room(this.info);

  RoomInfo info;
  int timeOffset = 0;
  List<RoomUser> users = [];
  List<UserMessage> messages = [];
}