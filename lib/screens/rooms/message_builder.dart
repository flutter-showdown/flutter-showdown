import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_showdown/screens/common/user_details_dialog.dart';
import 'package:flutter_showdown/providers/global_messages_enums.dart';
import 'package:flutter_showdown/providers/room_messages.dart';
import 'package:flutter_showdown/providers/global_messages.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../parser.dart';
import '../../utils.dart';

Widget buildMessage(BuildContext ctx, Message msg, bool sameAsP, bool sameAsN) {
  final args = Parser.parseName(msg.sender);
  final details = ctx.read<RoomMessages>().getUserDetails(args[0]);
  final bool isMe = args[0] == ctx.read<GlobalMessages>().user.name;

  return Padding(
    padding: EdgeInsets.only(
      right: isMe ? 24 : 48,
      left: isMe ? 72 : 8,
      top: sameAsN ? 1 : 8,
      bottom: sameAsP ? 1 : 8,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (details != null && !sameAsP && !isMe)
          InkWell(
            onTap: () {
              showDialog<UserDetailsDialog>(
                context: ctx,
                builder: (_) => UserDetailsDialog(args[1], details),
              );
            },
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue,
              backgroundImage: CachedNetworkImageProvider(
                getAvatarLink(details.avatar),
              ),
            ),
          )
        else
          SizedBox(
            width: 32,
            height: 32,
            child: sameAsP || isMe
                ? Container()
                : const CircularProgressIndicator(),
          ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (!sameAsN && !isMe)
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Row(
                    children: [
                      usernameTextColor(args[0], args[2]),
                      const SizedBox(width: 8),
                      Text(
                        Groups[args[1]],
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: isMe
                      ? Colors.blue
                      : const Color.fromARGB(255, 241, 241, 241),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(sameAsN && !isMe ? 4 : 16),
                    bottomLeft: Radius.circular(sameAsP && !isMe ? 4 : 16),
                    topRight: Radius.circular(sameAsN && isMe ? 4 : 16),
                    bottomRight: Radius.circular(sameAsP && isMe ? 4 : 16),
                  ),
                ),
                child: Text(
                  msg.content,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: isMe ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}
