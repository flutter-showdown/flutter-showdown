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
    ..status = json['status'] as String;
}

Map<String, dynamic> _$UserDetailsToJson(UserDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userid': instance.userid,
      'name': instance.name,
      'avatar': instance.avatar,
      'group': instance.group,
      'status': instance.status,
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

// **************************************************************************
// SuperEnumGenerator
// **************************************************************************

@immutable
abstract class GlobalMessage extends Equatable {
  const GlobalMessage(this._type);

  factory GlobalMessage.updateUser(User user) = UserWrapper;

  final _GlobalMessage _type;

//ignore: missing_return
  R when<R>({@required R Function(User) updateUser}) {
    assert(() {
      if (updateUser == null) {
        throw 'check for all possible cases';
      }
      return true;
    }());
    switch (this._type) {
      case _GlobalMessage.updateUser:
        return updateUser((this as UserWrapper).user);
    }
  }

//ignore: missing_return
  Future<R> asyncWhen<R>({@required FutureOr<R> Function(User) updateUser}) {
    assert(() {
      if (updateUser == null) {
        throw 'check for all possible cases';
      }
      return true;
    }());
    switch (this._type) {
      case _GlobalMessage.updateUser:
        return updateUser((this as UserWrapper).user);
    }
  }

  R whenOrElse<R>(
      {R Function(User) updateUser,
      @required R Function(GlobalMessage) orElse}) {
    assert(() {
      if (orElse == null) {
        throw 'Missing orElse case';
      }
      return true;
    }());
    switch (this._type) {
      case _GlobalMessage.updateUser:
        if (updateUser == null) break;
        return updateUser((this as UserWrapper).user);
    }
    return orElse(this);
  }

  Future<R> asyncWhenOrElse<R>(
      {FutureOr<R> Function(User) updateUser,
      @required FutureOr<R> Function(GlobalMessage) orElse}) {
    assert(() {
      if (orElse == null) {
        throw 'Missing orElse case';
      }
      return true;
    }());
    switch (this._type) {
      case _GlobalMessage.updateUser:
        if (updateUser == null) break;
        return updateUser((this as UserWrapper).user);
    }
    return orElse(this);
  }

//ignore: missing_return
  Future<void> whenPartial({FutureOr<void> Function(User) updateUser}) {
    assert(() {
      if (updateUser == null) {
        throw 'provide at least one branch';
      }
      return true;
    }());
    switch (this._type) {
      case _GlobalMessage.updateUser:
        if (updateUser == null) break;
        return updateUser((this as UserWrapper).user);
    }
  }

  @override
  List get props => const [];
}

@immutable
class UserWrapper extends GlobalMessage {
  const UserWrapper(this.user) : super(_GlobalMessage.updateUser);

  final User user;

  @override
  String toString() => 'UserWrapper($user)';
  @override
  List get props => [user];
}
