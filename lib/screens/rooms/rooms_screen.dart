import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_showdown/providers/room_messages.dart';
import 'package:provider/provider.dart';

import 'chat_screen.dart';
import 'chat_selector/chat_selector.dart';
import 'private_section/news_screen.dart';
import 'private_section/private_channel_list.dart';
import 'user_list.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({this.onChatChange});

  final VoidCallback onChatChange;
  static const double _widthFactor = 0.87;

  @override
  State<StatefulWidget> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> with SingleTickerProviderStateMixin {
  bool closed = true;
  double _lastDragX;
  double _dragStartX;
  bool _isSwipingLeft = false;
  Animation<Offset> animation;
  AnimationController _controller;
  String privateChannel = 'News';

  @override
  void initState() {
    super.initState();

    _controller = AnimationController.unbounded(vsync: this);
    _updateAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentRoom = context.watch<RoomMessages>().currentRoom;
    return GestureDetector(
      onHorizontalDragStart: _dragStart,
      onHorizontalDragUpdate: _dragUpdate,
      onHorizontalDragEnd: _dragEnd,
      child: Container(
        color: const Color.fromARGB(255, 201, 201, 201),
        child: SafeArea(
          child: Stack(
            children: [
              FractionallySizedBox(
                widthFactor: RoomsScreen._widthFactor,
                child: Row(
                  children: [
                    ChatSelector(),
                    Expanded(
                      child: currentRoom != null ? UserList(currentRoom) : const PrivateChannelsList(),
                    ),
                  ],
                ),
              ),
              SlideTransition(
                position: animation,
                child: currentRoom == null && privateChannel == 'News' ? NewsScreen() :
                ChatScreen(
                  closed: closed,
                  messages: currentRoom != null ? currentRoom.messages : [],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _dragStart(DragStartDetails details) {
    _lastDragX = details.localPosition.dx;
    _dragStartX = details.localPosition.dx;
  }

  void _dragUpdate(DragUpdateDetails details) {
    final diff = details.localPosition.dx - _lastDragX;
    final isSwipingLeft = diff < 0;

    if (diff.abs() > 10) {
      _lastDragX = details.localPosition.dx;

      if (isSwipingLeft != _isSwipingLeft) {
        _isSwipingLeft = isSwipingLeft;
        widget.onChatChange();
      }
    }

    final value = (details.localPosition.dx - _dragStartX) / context.size.width;

    if ((isSwipingLeft && value < 0 && !closed) ||
        (!isSwipingLeft && value > 0 && closed)) {
      _dragStartX = details.localPosition.dx;
      return;
    }
    setState(() => _controller.value = value.abs());
  }

  void _dragEnd(DragEndDetails details) {
    const desc = SpringDescription(mass: 30.0, stiffness: 1.0, damping: 1.0);
    final velocity =
        (details.velocity.pixelsPerSecond.dx / context.size.width).abs();
    SpringSimulation simulation;

    if (details.velocity.pixelsPerSecond.dx == 0.0) {
      simulation = SpringSimulation(
        desc,
        _controller.value,
        _controller.value >= 0.4 ? 1 : 0,
        velocity,
      );
      if (_controller.value < 0.4 && _isSwipingLeft == closed) {
        _isSwipingLeft = !_isSwipingLeft;
        widget.onChatChange();
      }
    } else if ((_isSwipingLeft && closed) || (!_isSwipingLeft && !closed)) {
      simulation = SpringSimulation(desc, _controller.value, 1, velocity);
    }

    if (simulation != null) {
      _controller.animateWith(simulation).then<void>((_) {
        setState(() {
          if (_controller.value.round() == 1.0) {
            closed = !closed;
            _updateAnimation();
          }
          _controller.value = 0.0;
        });
      });
    }
  }

  void _updateAnimation() {
    const offset = RoomsScreen._widthFactor + 0.01;

    animation = _controller.drive(
      Tween<Offset>(
        begin: closed ? const Offset(offset, 0) : Offset.zero,
        end: closed ? Offset.zero : const Offset(offset, 0),
      ),
    );
  }
}