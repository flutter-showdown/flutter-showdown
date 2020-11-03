import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_showdown/providers/room_messages.dart';
import 'package:provider/provider.dart';

import 'chat_screen.dart';
import 'chat_selector.dart';
import 'user_list.dart';

class RoomsScreen extends StatelessWidget {
  const RoomsScreen({this.onChatChange});

  final VoidCallback onChatChange;
  static const double _widthFactor = 0.83;

  @override
  Widget build(BuildContext context) {
    final currentRoom = context.watch<RoomMessages>().currentRoom;

    return Container(
      color: const Color.fromARGB(255, 201, 201, 201),
      child: SafeArea(
        child: Stack(
          overflow: Overflow.visible,
          children: [
            FractionallySizedBox(
              widthFactor: _widthFactor,
              child: Row(
                children: [
                  ChatSelector(),
                  Expanded(
                    child: currentRoom != null ? UserList(currentRoom) : const Text('Private'),
                  ),
                ],
              ),
            ),
            ChatScreen(
              offset: _widthFactor + 0.01,
              onDrag: onChatChange,
              messages: currentRoom != null ? currentRoom.messages : [],
            )
          ],
        ),
      ),
    );
  }
}