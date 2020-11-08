import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../parser.dart';
import 'global_messages_enums.dart';
import 'websockets.dart';

class GlobalMessages with ChangeNotifier {
  GlobalMessages() {
    sockets.initCommunication();
    sockets.addListener(_onMessageReceived);
  }

  String _challstr;
  User user = User();
  static const String ActionUrl = ServerUrl + '/action.php';

  // TODO(reno): put in cache userdetails [autojoin help,lobby] [ |/noreply /leave lobby]
  void _onMessageReceived(String message) {
    for (final String line in message.split('\n')) {
      final List<String> args = Parser.parseLine(line);

      switch (args[0]) {
        case 'challstr':
          //|challstr|CHALLSTR
          final Map<String, String> body = {'act': 'upkeep', 'challstr': args[1]};

          _challstr = args[1];
          sockets.send('|/cmd rooms');
          sockets.send('|/autojoin');
          http.post(ActionUrl, body: body).then((http.Response response) {
            if (response == null)
              return;
            final body = jsonDecode(response.body.substring(1)) as Map<String, dynamic>;

            if (body['loggedin'] as bool)
              sockets.send('/trn ' + body['username'].toString() + ',0,' + body['assertion'].toString());
          });
          break;
        case 'updateuser':
          //|updateuser|USER|NAMED|AVATAR|SETTINGS
          user.setName(args[1], args[2] == '1', args[3]);

          notifyListeners();
          break;
        case 'updatechallenges':
          break;
        case 'queryresponse':
          args.removeAt(0);

          switch (args[0]) {
            case 'userdetails':
              final UserDetails newDetails = UserDetails.fromJson(jsonDecode(args[1]) as Map<String, dynamic>);

              if (newDetails.userid == user.userId) {
                user.avatar = newDetails.avatar;
                notifyListeners();
              }
              break;
          }
          break;
      }
    }
  }

  void setAvatar(String avatar) {
    sockets.send('|/avatar ' + avatar);
    sockets.send('|/cmd userdetails ' + user.userId);
  }

  Future<String> setUsername(String username) async {
    final Map<String, String> body = {
      'act': 'getassertion',
      'userid': Parser.toId(username),
      'challstr': _challstr
    };
    final response = await http.post(ActionUrl, body: body);

    if (response.statusCode == 200) {
      if (response.body.startsWith(';')) {
        return response.body.substring(response.body.lastIndexOf(';'));
      } else {
        sockets.send('|/trn ' + username + ',0,' + response.body);
        return '';
      }
    }
    return ';Request Failed';
  }

  Future<bool> logUser(String username, String password) async {
    final Map<String, String> body = {
      'act': 'login',
      'name': Parser.toId(username),
      'pass': password,
      'challstr': _challstr
    };
    final response = await http.post(ActionUrl, body: body);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body.substring(1)) as Map<String, dynamic>;

      if (jsonResponse['actionsuccess'] as bool) {
        user.registered = true;

        sockets.send('|/trn ' + username + ',0,' + jsonResponse['assertion'].toString());
        return true;
      }
    }
    return false;
  }

  Future<String> registerUser(String username, String password, String captcha) async {
    final Map<String, String> body = {
      'act': 'register',
      'username': Parser.toId(username),
      'password': password,
      'cpassword': password,
      'captcha': captcha,
      'challstr': _challstr
    };
    final response = await http.post(ActionUrl, body: body);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body.substring(1)) as Map<String, dynamic>;

      if (jsonResponse['actionsuccess'] != null) {
        user.registered = true;

        sockets.send('|/trn ' + username + ',0,' + jsonResponse['assertion'].toString());
        return '';
      }
      return jsonResponse['actionerror'].toString();
    }
    return 'Register Failed';
  }
}
