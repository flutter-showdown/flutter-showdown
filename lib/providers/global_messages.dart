import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../parser.dart';
import 'global_messages_enums.dart';
import 'websockets.dart';

class GlobalMessages with ChangeNotifier {
  GlobalMessages() {
    sockets.initCommunication();
    sockets.addListener(_onMessageReceived);

    SharedPreferences.getInstance().then((value) => _prefs = value);
  }

  User user;
  String _challstr;
  SharedPreferences _prefs;
  static const String ActionUrl = ServerUrl + '/action.php';

  void _onMessageReceived(String message) {
    for (final String line in message.split('\n')) {
      final List<String> args = Parser.parseLine(line);

      switch (args[0]) {
        case 'challstr':
          //|challstr|CHALLSTR
          _challstr = args[1];

          keepConnection();
          return;
        case 'updateuser':
          //|updateuser|USER|NAMED|AVATAR|SETTINGS
          user ??= User();
          user.setName(args[1], args[2] == '1', args[3]);
          // TODO(renaud): If the avatar isn't a number. Put it in cache ?
          notifyListeners();
          return;
        case 'updatechallenges':
          return;
        case 'queryresponse':
          args.removeAt(0);

          switch (args[0]) {
            case 'userdetails':
              final UserDetails newDetails = UserDetails.fromJson(
                  jsonDecode(args[1]) as Map<String, dynamic>);

              if (newDetails.userid == user.userId) {
                user.avatar = newDetails.avatar;
                if (newDetails.autoconfirmed) {
                  user.registered = true;
                }
                notifyListeners();
              }
              return;
          }
          return;
      }
    }
  }

  void keepConnection() {
    final body = {'act': 'upkeep', 'challstr': _challstr};
    final headers = {'cookie': _prefs.getString('AuthCookie') ?? ''};

    post(ActionUrl, headers: headers, body: body).then((Response res) {
      final body = jsonDecode(res.body.substring(1)) as Map<String, dynamic>;
      final avatar = _prefs.getString('UserAvatar') ?? '';

      if (avatar.isNotEmpty) {
        sockets.send('|/avatar $avatar');
        sockets.send('|/cmd userdetails ${user.userId}');
      }
      sockets.send('|/cmd rooms');
      sockets.send('|/autojoin');
      //[autojoin help,lobby] [ |/noreply /leave lobby]
      if (body['loggedin'] as bool) {
        final username = body['username'].toString();

        user ??= User();
        user.setName(' $username', true, avatar);
        sockets.send('|/trn $username,0,${body['assertion']}');
        notifyListeners();
      }
    });
  }

  void setAvatar(String avatar) {
    sockets.send('|/avatar ' + avatar);
    sockets.send('|/cmd userdetails ${user.userId}');

    _prefs.setString('UserAvatar', avatar);
  }

  Future<String> setUsername(String username) async {
    final Map<String, String> body = {
      'act': 'getassertion',
      'userid': Parser.toId(username),
      'challstr': _challstr
    };
    final response = await post(ActionUrl, body: body);

    if (response.statusCode == 200) {
      if (response.body.startsWith(';')) {
        return response.body.substring(response.body.lastIndexOf(';'));
      } else {
        sockets.send('|/trn $username,0,${response.body}');
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
    final response = await post(ActionUrl, body: body);

    if (response.statusCode == 200) {
      final jsonResponse =
          json.decode(response.body.substring(1)) as Map<String, dynamic>;

      if (jsonResponse['actionsuccess'] as bool) {
        user.registered = true;
        final rawCookie = response.headers['set-cookie'];
        if (rawCookie != null) {
          final sidIdx = rawCookie.indexOf('sid=');

          _prefs.setString(
            'AuthCookie',
            rawCookie.substring(sidIdx, rawCookie.indexOf(';', sidIdx)),
          );
        }
        sockets.send('|/trn $username,0,${jsonResponse['assertion']}');
        return true;
      }
    }
    return false;
  }

  void logout() {
    user = null;
    // Clear user preferences
    _prefs.remove('AuthCookie');
    // Reset websocket
    sockets.initCommunication();
  }

  Future<String> registerUser(
      String username, String password, String captcha) async {
    final Map<String, String> body = {
      'act': 'register',
      'username': Parser.toId(username),
      'password': password,
      'cpassword': password,
      'captcha': captcha,
      'challstr': _challstr
    };
    final response = await post(ActionUrl, body: body);

    if (response.statusCode == 200) {
      final jsonResponse =
          jsonDecode(response.body.substring(1)) as Map<String, dynamic>;

      if (jsonResponse['actionsuccess'] != null) {
        user.registered = true;

        sockets.send('|/trn $username,0,${jsonResponse['assertion']}');
        return '';
      }
      return jsonResponse['actionerror'].toString();
    }
    return 'Register Failed';
  }
}
