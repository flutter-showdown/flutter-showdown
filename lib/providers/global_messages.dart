import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../parser.dart';
import 'global_messages_enums.dart';
import 'websockets.dart';

GlobalMessages globalMessages = GlobalMessages();

class GlobalMessages {
  factory GlobalMessages() {
    return _globalMessages;
  }

  GlobalMessages._internal() {
    sockets.addListener(_onMessageReceived);
  }

  static final _globalMessages = GlobalMessages._internal();
  final ObserverList<Function> _listeners = ObserverList<Function>();

  String _challstr;
  final User _user = User();
  static const String SERVER_URL = 'https://play.pokemonshowdown.com/action.php';

  // TODO(reno): put in cache userdetails [autojoin help,lobby] [ |/noreply /leave lobby]
  void _onMessageReceived(String message) {
    for (final String line in message.split('\n')) {
      final List<String> args = Parser.parseLine(line);

      switch (args[0]) {
        case 'challstr':
          final Map<String, String> body = {'act': 'upkeep', 'challstr': args[1]};

          _challstr = args[1];
          sockets.send('|/cmd rooms');
          sockets.send('|/autojoin');
          http.post(SERVER_URL, body: body).then((http.Response response) {
            if (response == null)
              return;
            final body = jsonDecode(response.body.substring(1)) as Map<String, dynamic>;

            if (body['loggedin'] as bool)
              sockets.send('/trn ' + body['username'].toString() + ',0,' + body['assertion'].toString());
          });
          break;
        case 'updateuser':
          _user.setName(args[1], args[2] == 'true', args[3]);

          _sendToListeners(GlobalMessage.updateUser(_user));
          break;
        case 'updatechallenges':
          break;
        case 'queryresponse':
          args.removeAt(0);

          switch (args[0]) {
            case 'userdetails':
              final UserDetails newDetails = UserDetails.fromJson(jsonDecode(args[1]) as Map<String, dynamic>);

              if (newDetails.userid == _user.userId) {
                _user.avatar = newDetails.avatar;
                _sendToListeners(GlobalMessage.updateUser(_user));
              }
              break;
          }
          break;
      }
    }
  }

  void _sendToListeners(GlobalMessage message) {
    for (final cb in _listeners) {
      cb(message);
    }
  }

  void addListener(Function callback) {
    _listeners.add(callback);
  }

  void removeListener(Function callback) {
    _listeners.remove(callback);
  }

  void setAvatar(String avatar) {
    sockets.send('|/avatar ' + avatar);
    sockets.send('|/cmd userdetails ' + _user.userId);
  }

  Future<bool> setUsername(String username) async {
    final Map<String, String> body = {
      'act': 'getassertion',
      'userid': Parser.toId(username),
      'challstr': _challstr
    };
    final response = await http.post(SERVER_URL, body: body);

    if (response.statusCode == 200) {
      if (response.body == ';') {
        return false;
      } else {
        sockets.send('|/trn ' + username + ',0,' + response.body);
        return true;
      }
    }
    return false;
  }

  Future<bool> logUser(String username, String password) async {
    final Map<String, String> body = {
      'act': 'login',
      'name': Parser.toId(username),
      'pass': password,
      'challstr': _challstr
    };
    final response = await http.post(SERVER_URL, body: body);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body.substring(1)) as Map<String, dynamic>;

      if (jsonResponse['actionsuccess'] as bool) {
        _user.registered = true;

        sockets.send('|/trn ' + username + ',0,' + jsonResponse['assertion'].toString());
        return true;
      }
    }
    return false;
  }

  Future<String> registerUser(String username, String password, String captcha) async {
    final Map<String, String> body = {
      'act': 'register',
      'username': username,
      'password': password,
      'cpassword': password,
      'captcha': captcha,
      'challstr': _challstr
    };
    final response = await http.post(SERVER_URL, body: body);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body.substring(1)) as Map<String, dynamic>;

      if (jsonResponse['actionsuccess'] != null) {
        _user.registered = true;

        sockets.send('|/trn ' + username + ',0,' + jsonResponse['assertion'].toString());
        return 'success';
      }
      return jsonResponse['actionerror'].toString();
    }
    return 'error';
  }
}
