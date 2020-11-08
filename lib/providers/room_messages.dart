import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:html/parser.dart';

import '../constants.dart';
import '../parser.dart';
import 'global_messages_enums.dart';
import 'websockets.dart';

class RoomMessages with ChangeNotifier {
  RoomMessages() {
    sockets.addListener(_onMessageReceived);
  }

  String _from = '';
  String current = '';
  final Map<String, Room> rooms = {};
  final List<String> _currentRooms = [];
  final Map<String, UserDetails> _users = {};

  Room get currentRoom => rooms[current];

  void _onMessageReceived(String message) {
    final List<String> roomMsg = Parser.parseRoomMessage(message);
    final List<String> lines = roomMsg[1].split('\n');

    if (roomMsg[0] != '') {
      _from = roomMsg[0];
    }

    for (final line in lines) {
      final List<String> args = Parser.parseLine(line);

      switch (args[0]) {
        case 'init':
          //|init|ROOMTYPE
          //args[0] == chat | battle
          break;
        case 'title':
          //|title|TITLE
          _from = Parser.toId(args[1]);
          break;

        case 'c':
        case 'chat':
          break;

        case 'j':
        case 'join':
        case 'J':
          //|join|USER, |j|USER, or |J|USER
          rooms[_from].users.add(RoomUser(Parser.parseName(args[1])));

          _sortUser();
          notifyListeners();
          break;

        case 'l':
        case 'leave':
        case 'L':
          //|leave|USER, |l|USER, or |L|USER
          final nameArgs = Parser.parseName(args[1]);

          rooms[_from].users.removeWhere((user) => user.id == Parser.toId(nameArgs[0]));

          notifyListeners();
          break;

        case 'n':
        case 'name':
        case 'N':
          //|name|USER|OLDID, |n|USER|OLDID, or |N|USER|OLDID
          _users.remove(args[2]);
          rooms[_from].users.removeWhere((user) => user.id == args[2]);
          rooms[_from].users.add(RoomUser(Parser.parseName(args[1])));

          notifyListeners();
          break;

        case ':':
          //|:|TIMESTAMP
          break;
        case 'c:':
          //|c:|TIMESTAMP|USER|MESSAGE
          if (RegExp(r'^[A-Za-z0-9]').firstMatch(args[2]) != null) {
            args[2] = ' ' + args[2];
          }
          if (_from != current) {
            rooms[_from].hasUpdates = true;
          }
          rooms[_from].messages.insert(
                0,
                Message(
                  int.parse(args[1]),
                  args[2],
                  args[3],
                  MessageType.Message,
                ),
              );
          notifyListeners();
          break;

        case 'error':
          rooms[_from].messages.insert(
                0,
                Message(
                  null,
                  null,
                  args[1],
                  MessageType.Error,
                ),
              );
          notifyListeners();
          break;

        case 'html':
          //|html|HTML
          log(args[1], name: 'HTML');
          break;
        case 'uhtml':
          //|uhtml|NAME|HTML
          rooms[_from].messages.removeWhere((message) => message.sender == args[1]);
          rooms[_from].messages.insert(0, Message(0, args[1], args[2], MessageType.Named));
          notifyListeners();
          /*log(args[1], name: 'UHTML');
          log(args[2], name: 'UHTML');

          //Si c'est un poll get tout les boutons
          for (final strong in parse(args[2]).getElementsByTagName('strong')) {
            log(strong.innerHtml, name:'Strong text');
          }*/

          break;
        case 'raw':
          final infobox = parse(args[1]).getElementsByClassName('infobox')[0];

          if (infobox.children.isEmpty) {
            rooms[_from].messages.insert(0, Message(0, '', infobox.innerHtml, MessageType.Intro));
          } else {
            //"infobox infobox-roomintro"
            rooms[_from].messages.insert(0, Message(0, '', args[1], MessageType.Named));
          }
          notifyListeners();
          break;
        case 'users':
        //|users|USERLIST
          final List<String> usersArgs = args[1].split(',');

          usersArgs.removeAt(0);
          for (final String user in usersArgs)
            rooms[_from].users.add(RoomUser(Parser.parseName(user)));
          rooms[_from].info.userCount = rooms[_from].users.length;

          _sortUser();
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
              final availableRooms = AvailableRooms.fromJson(jsonDecode(args[1]) as Map<String, dynamic>);

              availableRooms.chat.sort((RoomInfo l, RoomInfo r) => r.userCount.compareTo(l.userCount));
              for (final roomInfo in availableRooms.official) {
                rooms[roomInfo.id] = Room(roomInfo);
              }
              for (final roomInfo in availableRooms.chat) {
                rooms[roomInfo.id] = Room(roomInfo);
              }
              notifyListeners();
              break;
          }
          break;
      }
    }
  }

  void sendMessage(String message) {
    sockets.send('$current|$message');
  }

  void _sortUser() {
    rooms[_from].users.sort((RoomUser l, RoomUser r) {
      final leftGroup = Groups.keys.toList().indexOf(l.group);
      final rightGroup = Groups.keys.toList().indexOf(r.group);
      final groupCompare = leftGroup.compareTo(rightGroup);

      if (groupCompare == 0) {
        if (l.status.startsWith('!') && !r.status.startsWith('!')) {
          return 1;
        } else if (r.status.startsWith('!') &&
            !l.status.startsWith('!')) {
          return -1;
        }
        return l.name.compareTo(r.name);
      }
      return groupCompare;
    });
  }

  void joinRoom(String id) {
    current = id;

    if (id.isEmpty) {
      notifyListeners();
      return;
    } else if (!_currentRooms.contains(id)) {
      _currentRooms.add(id);
      sockets.send('|/join ' + id);
    } else {
      //Clear updates when entering the room
      rooms[id].hasUpdates = false;
      notifyListeners();
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
