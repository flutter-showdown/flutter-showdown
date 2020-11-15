// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_messages_enums.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDetails _$UserDetailsFromJson(Map<String, dynamic> json) {
  return UserDetails()
    ..id = json['id'] as String
    ..userid = json['userid'] as String
    ..name = json['name'] as String
    ..avatar = json['avatar'] as String
    ..group = json['group'] as String
    ..status = json['status'] as String
    ..autoconfirmed = json['autoconfirmed'] as bool;
}

Map<String, dynamic> _$UserDetailsToJson(UserDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userid': instance.userid,
      'name': instance.name,
      'avatar': instance.avatar,
      'group': instance.group,
      'status': instance.status,
      'autoconfirmed': instance.autoconfirmed,
    };

AvailableRooms _$AvailableRoomsFromJson(Map<String, dynamic> json) {
  return AvailableRooms()
    ..official = (json['official'] as List)
        ?.map((e) =>
            e == null ? null : RoomInfo.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..pspl = (json['pspl'] as List)
        ?.map((e) =>
            e == null ? null : RoomInfo.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..chat = (json['chat'] as List)
        ?.map((e) =>
            e == null ? null : RoomInfo.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..userCount = json['userCount'] as int
    ..battleCount = json['battleCount'] as int;
}

Map<String, dynamic> _$AvailableRoomsToJson(AvailableRooms instance) =>
    <String, dynamic>{
      'official': instance.official,
      'pspl': instance.pspl,
      'chat': instance.chat,
      'userCount': instance.userCount,
      'battleCount': instance.battleCount,
    };

RoomInfo _$RoomInfoFromJson(Map<String, dynamic> json) {
  return RoomInfo()
    ..title = json['title'] as String
    ..desc = json['desc'] as String
    ..userCount = json['userCount'] as int
    ..subRooms =
        (json['subRooms'] as List)?.map((e) => e as String)?.toList() ?? [];
}

Map<String, dynamic> _$RoomInfoToJson(RoomInfo instance) => <String, dynamic>{
      'title': instance.title,
      'desc': instance.desc,
      'userCount': instance.userCount,
      'subRooms': instance.subRooms,
    };

News _$NewsFromJson(Map<String, dynamic> json) {
  return News()
    ..id = json['id'] as String
    ..title = json['title'] as String
    ..author = json['author'] as String
    ..date = json['date'] as int
    ..summaryHTML = json['summaryHTML'] as String
    ..detailsHTML = json['detailsHTML'] as String;
}

Map<String, dynamic> _$NewsToJson(News instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'author': instance.author,
      'date': instance.date,
      'summaryHTML': instance.summaryHTML,
      'detailsHTML': instance.detailsHTML,
    };
