// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_messages_enums.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDetails _$UserDetailsFromJson(Map<String, dynamic> json) {
  return UserDetails()
    ..id = json['id'] as String
    ..userId = json['userId'] as String
    ..name = json['name'] as String
    ..avatar = json['avatar'] as String
    ..groups = json['groups'] as String
    ..autoConfirmed = json['autoConfirmed'] as bool
    ..status = json['status'] as String;
}

Map<String, dynamic> _$UserDetailsToJson(UserDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'avatar': instance.avatar,
      'groups': instance.groups,
      'autoConfirmed': instance.autoConfirmed,
      'status': instance.status,
    };

// **************************************************************************
// SuperEnumGenerator
// **************************************************************************

@immutable
abstract class GlobalMessage extends Equatable {
  const GlobalMessage(this._type);

  factory GlobalMessage.updateUser(User user) = UserWrapper;

  factory GlobalMessage.userDetails(UserDetails userDetails) =
      UserDetailsWrapper;

  final _GlobalMessage _type;

//ignore: missing_return
  R when<R>(
      {@required R Function(User) updateUser,
      @required R Function(UserDetails) userDetails}) {
    assert(() {
      if (updateUser == null || userDetails == null) {
        throw 'check for all possible cases';
      }
      return true;
    }());
    switch (this._type) {
      case _GlobalMessage.updateUser:
        return updateUser((this as UserWrapper).user);
      case _GlobalMessage.userDetails:
        return userDetails((this as UserDetailsWrapper).userDetails);
    }
  }

//ignore: missing_return
  Future<R> asyncWhen<R>(
      {@required FutureOr<R> Function(User) updateUser,
      @required FutureOr<R> Function(UserDetails) userDetails}) {
    assert(() {
      if (updateUser == null || userDetails == null) {
        throw 'check for all possible cases';
      }
      return true;
    }());
    switch (this._type) {
      case _GlobalMessage.updateUser:
        return updateUser((this as UserWrapper).user);
      case _GlobalMessage.userDetails:
        return userDetails((this as UserDetailsWrapper).userDetails);
    }
  }

  R whenOrElse<R>(
      {R Function(User) updateUser,
      R Function(UserDetails) userDetails,
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
      case _GlobalMessage.userDetails:
        if (userDetails == null) break;
        return userDetails((this as UserDetailsWrapper).userDetails);
    }
    return orElse(this);
  }

  Future<R> asyncWhenOrElse<R>(
      {FutureOr<R> Function(User) updateUser,
      FutureOr<R> Function(UserDetails) userDetails,
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
      case _GlobalMessage.userDetails:
        if (userDetails == null) break;
        return userDetails((this as UserDetailsWrapper).userDetails);
    }
    return orElse(this);
  }

//ignore: missing_return
  Future<void> whenPartial(
      {FutureOr<void> Function(User) updateUser,
      FutureOr<void> Function(UserDetails) userDetails}) {
    assert(() {
      if (updateUser == null && userDetails == null) {
        throw 'provide at least one branch';
      }
      return true;
    }());
    switch (this._type) {
      case _GlobalMessage.updateUser:
        if (updateUser == null) break;
        return updateUser((this as UserWrapper).user);
      case _GlobalMessage.userDetails:
        if (userDetails == null) break;
        return userDetails((this as UserDetailsWrapper).userDetails);
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

@immutable
class UserDetailsWrapper extends GlobalMessage {
  const UserDetailsWrapper(this.userDetails)
      : super(_GlobalMessage.userDetails);

  final UserDetails userDetails;

  @override
  String toString() => 'UserDetailsWrapper($userDetails)';
  @override
  List get props => [userDetails];
}
