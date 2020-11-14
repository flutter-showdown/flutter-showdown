import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_showdown/providers/global_messages_enums.dart';
import 'package:flutter_showdown/providers/room_messages.dart';
import 'package:provider/provider.dart';

import 'my_reordable_list.dart';
import 'room_name.dart';
import 'rounded_selector.dart';

class ChatSelector extends StatefulWidget {
  @override
  _ChatSelectorState createState() => _ChatSelectorState();
}

class _ChatSelectorState extends State<ChatSelector> {
  List<Room> _receivedRooms;
  void Function(String) _join;
  final List<List<Room>> _roomsPreferences = [];

  @override
  void initState() {
    super.initState();

    _join = context.read<RoomMessages>().joinRoom;
    _receivedRooms = context.read<RoomMessages>().rooms.values.toList();
    for (final room in _receivedRooms) {
      _roomsPreferences.add([room]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = context.watch<RoomMessages>().current;
    final receivedRooms = (context.watch<RoomMessages>().rooms).values.toList();

    if (receivedRooms.length != _receivedRooms.length) {
      // TODO(renaud): Merge
    }

    return Container(
      width: 72,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: RoundedSelector(
                hasUpdates: true,
                isSelected: current == '',
                onTap: () => _join(''),
                child: const Icon(Icons.chat, color: Colors.white),
              ),
            ),
            const Divider(indent: 20, endIndent: 20),
            MyReorderableListView<List<Room>>(
              _roomsPreferences,
              builder: (context, rooms) {
                final room = rooms.first;

                return RoundedSelector(
                  hasUpdates: room.hasUpdates,
                  isSelected: room.info.id == current,
                  child: RoomName(room.info.title),
                  onTap: () => _join(room.info.id),
                );
              },
              feedBack: (context, rooms) {
                final room = rooms.first;

                return RoundedSelector(child: RoomName(room.info.title));
              },
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  _roomsPreferences.insert(
                    newIndex,
                    _roomsPreferences.removeAt(oldIndex),
                  );
                });
              },
            ),
            Container(
              height: 56,
              margin: const EdgeInsets.only(top: 8),
            ),
          ],
        ),
      ),
    );
  }
}
