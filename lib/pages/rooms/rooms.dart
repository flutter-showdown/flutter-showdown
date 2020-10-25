import 'dart:io';
import 'dart:ui';

import 'package:flutter_showdown/pages/common/user_details_dialog.dart';
import 'package:flutter_showdown/parser.dart';
import 'package:flutter_showdown/providers/global_messages_enums.dart';
import 'package:flutter_showdown/providers/room_messages.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../utils.dart';
import 'chat_screen.dart';
import 'chat_selector.dart';

class Rooms extends StatefulWidget {
  @override
  _RoomsState createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {
  String _current = '';
  final double _widthFactor = 0.83;

  void _joinRoom(RoomInfo newRoomInfo) {
    setState(() => _current = newRoomInfo.id);

    if (_current != '') {
      context.read<RoomMessages>().joinRoom(newRoomInfo);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Room currentRoom = context.watch<RoomMessages>().rooms[_current];

    return SafeArea(
      child: Scaffold(
        body: Stack(
          overflow: Overflow.visible,
          children: [
            FractionallySizedBox(
              widthFactor: _widthFactor,
              child: Row(
                children: [
                  Container(
                    width: 72,
                    height: double.infinity,
                    color: Colors.grey,
                    child: ChatSelector(
                      current: _current,
                      onJoin: (roomInfo) => _joinRoom(roomInfo),
                    ),
                  ),

                  Expanded(
                    child: Scaffold(
                      appBar: AppBar(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_current != '' ? _current : 'Home'),
                            if (currentRoom != null)
                              Text(
                                currentRoom.info.desc,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                          ],
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        actions: [
                          IconButton(
                            icon: const Icon(Icons.more_vert),
                            splashRadius: 24.0,
                            onPressed: () {},
                          )
                        ],
                      ),
                      body: currentRoom != null ?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8, left: 16),
                            child: Text(
                              'Users - ${currentRoom.users.length}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),

                          Flexible(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: currentRoom.users.length,
                              itemBuilder: (BuildContext context, int idx) {
                                final user = currentRoom.users[idx];
                                final details = context.read<RoomMessages>().getUserDetails(user.name);

                                return ListTile(
                                  title: Text(
                                    user.name,
                                    style: TextStyle(color: user.status.startsWith('!') ? Colors.grey : Colors.black),
                                  ),
                                  visualDensity: VisualDensity.compact,
                                  subtitle: Text(GROUPS[user.group]),
                                  leading: details != null ? CircleAvatar(
                                    backgroundColor: user.status.startsWith('!') ? Colors.grey : Colors.blue,
                                    backgroundImage: CachedNetworkImageProvider(getAvatarLink(details.avatar)),
                                  ) : const CircularProgressIndicator(),
                                  onTap: () {
                                    showDialog<UserDetailsDialog>(context: context, builder: (_) => UserDetailsDialog(user.group, details));
                                  },
                                );
                              },
                            ),
                          )

                        ],
                      ) : const Text('Home Private Messages'),
                    ),
                  ),
                ],
              ),
            ),
            ChatScreen(
              offset: _widthFactor + 0.01,
              messages: currentRoom != null ? currentRoom.messages : [],
            ),
          ],
        ),
      ),
    );
  }
}