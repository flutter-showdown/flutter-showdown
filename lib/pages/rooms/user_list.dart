import 'dart:ui';

import 'package:flutter_showdown/pages/common/user_details_dialog.dart';
import 'package:flutter_showdown/providers/global_messages_enums.dart';
import 'package:flutter_showdown/providers/room_messages.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../utils.dart';

class UserList extends StatelessWidget {
  const UserList(this.currentRoom);

  final Room currentRoom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(currentRoom != null ? currentRoom.info.title : 'Home'),
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
      body: Container(
        color: ThemeData.light().scaffoldBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16),
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
                  final details =
                      context.read<RoomMessages>().getUserDetails(user.name);

                  return Material(
                    child: ListTile(
                      title: usernameTextColor(user.name, user.status),
                      visualDensity: VisualDensity.compact,
                      subtitle: Text(Groups[user.group]),
                      leading: details != null
                          ? CircleAvatar(
                              backgroundColor: user.status.startsWith('!')
                                  ? Colors.grey
                                  : Colors.blue,
                              backgroundImage: CachedNetworkImageProvider(
                                getAvatarLink(details.avatar),
                              ),
                            )
                          : const CircularProgressIndicator(),
                      onTap: () {
                        showDialog<UserDetailsDialog>(
                          context: context,
                          builder: (_) =>
                              UserDetailsDialog(user.group, details),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
