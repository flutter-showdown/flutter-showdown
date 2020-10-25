import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../constants.dart';
import '../parser.dart';
import 'global_messages_enums.dart';
import 'websockets.dart';

class RoomMessages with ChangeNotifier {
  RoomMessages() {
    sockets.addListener(_onMessageReceived);
  }

  String _from = '';
  final rooms = <String, Room>{};
  final _users = <String, UserDetails>{};
  AvailableRooms availableRooms = AvailableRooms();

  void _onMessageReceived(String message) {
    final List<String> room = Parser.parseRoomMessage(message);
    final List<String> lines = room[1].split('\n');

    if (room[0] != '') {
      _from = room[0];
    }

    for (final line in lines) {
      final List<String> args = Parser.parseLine(line);

      switch (args[0]) {
        case 'init':
          //args[0] == chat | battle
          break;
        case 'title':
          _from = Parser.toId(args[1]);
          break;

        case 'c':
        case 'chat':
          break;

        case ':':
          rooms[_from].timeOffset = (DateTime.now().millisecondsSinceEpoch / 1000).round() - (int.parse(args[1]));
          break;
        case 'c:':
          final message = UserMessage();

          message.time = rooms[_from].timeOffset + int.parse(args[1]);
          if (RegExp(r'^[A-Za-z0-9]').firstMatch(args[2]) != null) {
            args[2] = ' ' + args[2];
          }
          message.sender = args[2];
          message.content = args[3];
          rooms[_from].messages.insert(0, message);
          notifyListeners();
          break;

        case 'users':
          final List<RoomUser> users = [];
          final List<String> usersArgs = args[1].split(',');

          usersArgs.removeAt(0);
          for (final String user in usersArgs) {
            final nameArgs = Parser.parseName(user);
            
            users.add(RoomUser(nameArgs[0], nameArgs[1], nameArgs[2]));
          }

          users.sort((RoomUser l, RoomUser r) {
            final leftGroup = GROUPS.keys.toList().indexOf(l.group);
            final rightGroup = GROUPS.keys.toList().indexOf(r.group);
            final groupCompare = leftGroup.compareTo(rightGroup);

            if (groupCompare == 0) {
              if (l.status.startsWith('!') && !r.status.startsWith('!')) {
                return 1;
              } else if (r.status.startsWith('!') && !l.status.startsWith('!')) {
                return -1;
              }
              return l.name.compareTo(r.name);
            }
            return groupCompare;
          });
          rooms[_from].users = users;
          rooms[_from].info.userCount = users.length;
          notifyListeners();
          break;

        case 'queryresponse':
          args.removeAt(0);

          switch (args[0]) {
            case 'userdetails':
              final newDetails = UserDetails.fromJson(jsonDecode(args[1]) as Map<String, dynamic>);

              _users[newDetails.id] = newDetails;
              notifyListeners();
              break;
            case 'rooms':
              availableRooms = AvailableRooms.fromJson(jsonDecode(args[1]) as Map<String, dynamic>);
              availableRooms.chat.sort((RoomInfo l, RoomInfo r) => r.userCount.compareTo(l.userCount));
              notifyListeners();
              break;
          }
          break;
      }
    }
  }

  void joinRoom(RoomInfo newRoomInfo) {
    final String id = newRoomInfo.id;

    if (!rooms.keys.contains(id)) {
      rooms[id] = Room(newRoomInfo);
      // TODO(renaud): join subRooms
      sockets.send('|/join ' + id);
    }
  }

  UserDetails getUserDetails(String username) {
    final String userId = Parser.toId(username);

    if (_users.containsKey(userId)) {
      return _users[userId];
    }
    _users[userId] = null;
    sockets.send('|/cmd userdetails ' + userId);
    return null;
  }
}
