import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_showdown/providers/room_messages.dart';

class ChatSelector extends StatelessWidget {
  String _getInitials(String name) {
    String initials = '';

    if (name.length <= 5)
      return name;

    for (final String word in name.split(' ')) {
      initials += word[0];
      for (int i = 1; i < word.length; i++) {
        if (word[i] == word[i].toUpperCase()) {
          initials += word[i];
        }
      }
    }
    return initials;
  }

  @override
  Widget build(BuildContext context) {
    final current = context.watch<RoomMessages>().current;
    final rooms = (context.watch<RoomMessages>().rooms).values.toList();

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
                onTap: () => context.read<RoomMessages>().joinRoom(''),
                child: const Icon(Icons.chat, color: Colors.white),
              ),
            ),
            const Divider(indent: 20, endIndent: 20),
            if (rooms.isEmpty)
              const CircularProgressIndicator()
            else
              ListView.builder(
                shrinkWrap: true,
                itemCount: rooms.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, int idx) {
                  final room = rooms[idx];
                  final joinRoom = context.read<RoomMessages>().joinRoom;

                  return Padding(
                    padding: EdgeInsets.only(top: idx > 0 ? 8 : 0),
                    child: Tooltip(
                      message: room.info.title,
                      preferBelow: false,
                      child: RoundedSelector(
                        hasUpdates: room.hasUpdates,
                        isSelected: room.info.id == current,
                        child: Center(
                          child: Text(
                            _getInitials(room.info.title),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        onTap: () => joinRoom(room.info.id),
                      ),
                    ),
                  );
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

class RoundedSelector extends StatelessWidget {
  const RoundedSelector({this.child, this.isSelected, this.hasUpdates, this.onTap});

  final Widget child;
  final bool isSelected;
  final bool hasUpdates;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 6,
          height: isSelected ? 36 : hasUpdates ? 12 : 0,
          decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 6),
          child: InkWell(
            onTap: onTap,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(isSelected ? 15 : 25),
              ),
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}