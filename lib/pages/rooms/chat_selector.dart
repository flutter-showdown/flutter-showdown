import 'package:flutter/material.dart';
import 'package:flutter_showdown/providers/global_messages_enums.dart';
import 'package:flutter_showdown/providers/room_messages.dart';
import 'package:provider/provider.dart';

class ChatSelector extends StatefulWidget {
  const ChatSelector({this.current, this.onJoin});

  final String current;
  final void Function(RoomInfo) onJoin;

  @override
  _ChatSelectorState createState() => _ChatSelectorState();
}

class _ChatSelectorState extends State<ChatSelector> {
  Widget _buildSelector(RoomInfo info, bool first) {
    return Padding(
      padding: EdgeInsets.only(top: first ? 8 : 0),
      child: RoundedSelector(
        hasUpdates: false,
        isSelected: info.title == widget.current,
        child: Center(child: Text(info.title)),
        onTap: () => widget.onJoin(info),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rooms = context.watch<RoomMessages>().availableRooms;

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: RoundedSelector(
              hasUpdates: true,
              isSelected: widget.current == '',
              onTap: () => widget.onJoin(RoomInfo.title('')),
              child: const Icon(Icons.chat, color: Colors.white),
            ),
          ),

          const Divider(indent: 20, endIndent: 20),

          if (rooms.official.isEmpty)
            const CircularProgressIndicator()
          else
            ListView.builder(
              shrinkWrap: true,
              itemCount: rooms.official.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, int idx) => _buildSelector(rooms.official[idx], idx > 0),
            ),

          const Divider(indent: 20, endIndent: 20),

          ListView.builder(
            shrinkWrap: true,
            itemCount: rooms.chat.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, int idx) => _buildSelector(rooms.chat[idx], idx > 0),
          ),
        ],
      ),
    );
  }
}

class RoundedSelector extends StatefulWidget {
  const RoundedSelector({this.child, this.isSelected, this.hasUpdates, this.onTap});

  final Widget child;
  final bool isSelected;
  final bool hasUpdates;
  final VoidCallback onTap;

  @override
  _RoundedSelectorState createState() => _RoundedSelectorState();
}

class _RoundedSelectorState extends State<RoundedSelector> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 6,
          height: widget.isSelected ? 36 : widget.hasUpdates ? 12 : 0,
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
            onTap: widget.onTap,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(widget.isSelected ? 15.0 : 25.0),
              ),
              child: widget.child,
            ),
          ),
        ),
      ],
    );
  }
}