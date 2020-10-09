import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:web_socket_channel/io.dart';

///
/// Singleton
///
WebSocketsNotifications sockets = new WebSocketsNotifications();

class WebSocketsNotifications {
  //https://github.com/smogon/pokemon-showdown/blob/master/PROTOCOL.md
  static const String _SERVER_ADDRESS = "ws://sim.smogon.com:8000/showdown/websocket";
  static final WebSocketsNotifications _sockets = new WebSocketsNotifications._internal();

  factory WebSocketsNotifications() {
    return _sockets;
  }

  bool _isOn = false;

  IOWebSocketChannel _channel;

  WebSocketsNotifications._internal();

  ObserverList<Function> _listeners = new ObserverList<Function>();

  initCommunication() async {
    reset();

    try {
      _channel = new IOWebSocketChannel.connect(_SERVER_ADDRESS);
      _channel.stream.listen(_onReceptionOfMessageFromServer);
    } catch (e) {
      /// TODO
    }
  }

  reset() {
    if (_channel != null) {
      if (_channel.sink != null) {
        _channel.sink.close();
        _isOn = false;
      }
    }
  }

  send(String message) {
    if (_channel != null) {
      if (_channel.sink != null && _isOn) {
        log(message, name: "SEND");
        _channel.sink.add(message);
      }
    }
  }

  addListener(Function callback) {
    _listeners.add(callback);
  }

  removeListener(Function callback) {
    _listeners.remove(callback);
  }

  _onReceptionOfMessageFromServer(message) {
    _isOn = true;
    log(message, name: "RECEIVE");
    _listeners.forEach((Function callback) {
      callback(message.toString());
    });
  }
}
