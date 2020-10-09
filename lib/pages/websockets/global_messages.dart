import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'global_messages_enums.dart';
import 'websockets.dart';

GlobalMessages globalMessages = GlobalMessages();

class GlobalMessages {
  factory GlobalMessages() {
    return _game;
  }

  GlobalMessages._internal() {
    sockets.initCommunication();
    sockets.addListener(_onMessageReceived);
  }

  static final GlobalMessages _game = GlobalMessages._internal();
  final ObserverList<Function> _listeners = ObserverList<Function>();
  String _challstr;
  final User _user = User();

  // TODO(reno): put in cache username id rooms [autojoin help,lobby] [ |/noreply /leave lobby] send username (ukeep) and avatar
  void _onMessageReceived(String message) {
    if (message[0] == '|') {
      final List<String> list = message.substring(1).split('|');

      switch (list[0]) {
        case 'updateuser':
          _user.id = list[1].replaceAll(RegExp(r'[^a-zA-Z0-9]+'), '');
          _user.username = list[1].trim();
          _user.named = list[2] == '1';
          _user.avatar = list[3];
          _user.settings = jsonDecode(list[4]) as Map<String, dynamic>;

          sockets.send('|/cmd userdetails ' + _user.id);
          break;
        case 'challstr':
          _challstr = list[1] + '|' + list[2];

          sockets.send('|/cmd rooms');
          sockets.send('|/autojoin');
          break;
        case 'queryresponse':
          list.removeAt(0);
          switch (list[0]) {
            case 'rooms':
              break;
            case 'userdetails':
              final UserDetails newDetails = UserDetails.fromJson(
                  jsonDecode(list[1]) as Map<String, dynamic>);

              if (newDetails.id == _user.id) {
                _user.avatar = newDetails.avatar;

                _sendToListeners(GlobalMessage.updateUser(_user));
              } else {
                // TODO(reno): DIALOG just for other users
                _sendToListeners(GlobalMessage.userDetails(newDetails));
              }
              break;
            default:
              break;
          }
          break;
        default:
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
    sockets.send('|/cmd userdetails ' + _user.id);
    //receive: pour le /avatar
    // |pm| Guest 8296246|~|/text Avatar changed to:
    // |pm| Guest 8296246|~|/raw <img src='//play.pokemonshowdown.com/sprites/trainers/pokemonbreeder-gen4.png' alt='pokemonbreeder-gen4' width='80' height='80' class='pixelated' />
    // TODO(reno): notif ? dans la page rooms ?
  }

  Future<bool> setUsername(String username) async {
    final Map<String, String> body = {
      'act': 'getassertion',
      'userid': username.replaceAll(RegExp(r'[^a-zA-Z0-9]+'), ''),
      'challstr': _challstr
    };
    final http.Response response = await http
        .post('https://play.pokemonshowdown.com/action.php', body: body);

    if (response.body == ';') {
      return false;
    } else {
      sockets.send('|/trn ' + username + ',0,' + response.body);
      return true;
    }
  }

  Future<bool> logUser(String username, String password) async {
    final Map<String, String> body = {
      'act': 'login',
      'name': username.replaceAll(RegExp(r'[^a-zA-Z0-9]+'), ''),
      'pass': password,
      'challstr': _challstr
    };
    final response = await http
        .post('https://play.pokemonshowdown.com/action.php', body: body);
    if (response.statusCode == 200) {
      final jsonResponse =
          json.decode(response.body.substring(1)) as Map<String, dynamic>;

      if (jsonResponse['actionsuccess'] as bool) {
        _user.registerTime = jsonResponse['curuser']['registertime'].toString();

        sockets.send(
            '|/trn ' + username + ',0,' + jsonResponse['assertion'].toString());
        //[onLogin] ]{'curuser':{'userid':'kokodansko','usernum':'12210927','username':'kokodansko','email':null,'registertime':'1601246384','group':'1','banstate':'0','ip':'86.238.92.83','avatar':'0','account':null,'logintime':'1602165030','loginip':'86.238.92.83','loggedin':true,'outdatedpassword':false},'actionsuccess':true,'assertion':'text trst long'}
        return true;
      }
    }
    //[onLogin] ]{'curuser':{'username':'Guest','userid':'guest','group':0,'loggedin':false,'ip':'86.238.92.83'},'actionsuccess':false,'assertion':';;Your username cannot start with 'guest'.'}
    return false;
  }

  Future<String> registerUser(
      String username, String password, String captcha) async {
    final Map<String, String> body = {
      'act': 'register',
      'username': username,
      'password': password,
      'cpassword': password,
      'captcha': captcha,
      'challstr': _challstr
    };

    final response = await http
        .post('https://play.pokemonshowdown.com/action.php', body: body);
    if (response.statusCode == 200) {
      final jsonResponse =
          jsonDecode(response.body.substring(1)) as Map<String, dynamic>;

      if (jsonResponse['actionsuccess'] != null) {
        _user.registerTime = jsonResponse['curuser']['registertime'].toString();

        sockets.send(
            '|/trn ' + username + ',0,' + jsonResponse['assertion'].toString());
        return 'success';
      }
      return jsonResponse['actionerror'].toString();
    }
    return 'error';
  }
}
