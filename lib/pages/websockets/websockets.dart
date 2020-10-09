import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:web_socket_channel/io.dart';

///
/// Singleton
///
WebSocketsNotifications sockets = WebSocketsNotifications();

//https://github.com/smogon/pokemon-showdown/blob/master/PROTOCOL.md
class WebSocketsNotifications {
  factory WebSocketsNotifications() => _sockets;
  WebSocketsNotifications._internal();

  static const String _SERVER_ADDRESS =
      'ws://sim.smogon.com:8000/showdown/websocket';
  static final WebSocketsNotifications _sockets =
      WebSocketsNotifications._internal();

  bool _isOn = false;

  IOWebSocketChannel _channel;

  final ObserverList<Function> _listeners = ObserverList<Function>();

  Future<void> initCommunication() async {
    reset();

    try {
      _channel = IOWebSocketChannel.connect(_SERVER_ADDRESS);
      _channel.stream.listen(_onReceptionOfMessageFromServer);
    } catch (e) {
      // TODO(reno): Catch
    }
  }

  void reset() {
    if (_channel != null) {
      if (_channel.sink != null) {
        _channel.sink.close();
        _isOn = false;
      }
    }
  }

  void send(String message) {
    if (_channel != null) {
      if (_channel.sink != null && _isOn) {
        log(message, name: 'SEND');
        _channel.sink.add(message);
      }
    }
  }

  void addListener(Function callback) {
    _listeners.add(callback);
  }

  void removeListener(Function callback) {
    _listeners.remove(callback);
  }

  void _onReceptionOfMessageFromServer(dynamic message) {
    _isOn = true;
    log(message.toString(), name: 'RECEIVE');
    for (final cb in _listeners) {
      cb(message.toString());
    }
  }
}
