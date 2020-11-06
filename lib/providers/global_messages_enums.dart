import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
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

    if (json['rooms'] is Map<String, dynamic>) {
      (json['rooms'] as Map<String, dynamic>).keys.toList().forEach((room) {
        details.rooms.add(room);
      });
    }
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
  String group = ' ';
  String userId = 'guest';
  String avatar = '1';
  String status = '';
  bool named = false;
  bool registered = false;

  void setName(String fullName, bool named, String avatar) {
    final List<String> args = Parser.parseName(fullName);

    name = args[0];
    group = args[1];
    userId = Parser.toId(name);
    this.avatar = avatar;
    status = args[2];
    this.named = named;
    if (!named) {
      registered = false;
    }
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
  RoomUser(List<String> nameArgs) {
    id = Parser.toId(nameArgs[0]);
    name = nameArgs[0];
    group = nameArgs[1];
    status = nameArgs[2];
  }

  String id;
  String name;
  String group;
  String status;
}

enum MessageType {
  Named,
  Message,
  Greating,
}

class Message {
  Message(this.time, this.sender, this.content, this.type);

  int time;
  String sender;
  String content;
  MessageType type;
}

//https://pokemonshowdown.com/news.json
//User private messages

class Room {
  Room(this.info);

  RoomInfo info;
  int timeOffset = 0;
  bool hasUpdates = false;
  List<RoomUser> users = [];
  List<Message> messages = [];
}