import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_showdown/utils.dart';
import 'package:flutter_showdown/providers/global_messages_enums.dart';

import '../../constants.dart';

class UserDetailsDialog extends StatefulWidget {
  const UserDetailsDialog(this._roomGroup, this._details);

  final String _roomGroup;
  final UserDetails _details;

  @override
  _UserDetailsDialogState createState() => _UserDetailsDialogState();
}

//https://pokemonshowdown.com/users/{name}
class _UserDetailsDialogState extends State<UserDetailsDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: CachedNetworkImageProvider(getAvatarLink(widget._details.avatar)),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget._details.name,
                          style: const TextStyle(fontSize: 20)),
                      if (widget._details.status.length > 1)
                        Text(widget._details.status,
                            style: const TextStyle(
                                fontSize: 12, fontStyle: FontStyle.italic)),
                      if (widget._roomGroup != widget._details.group)
                        Text(GROUPS[widget._roomGroup],
                            style: const TextStyle(fontSize: 14)),
                      if (widget._details.group != ' ')
                        Text('Global ' + GROUPS[widget._details.group],
                            style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          const Text('Battles:'),
          const Divider(),
          if (widget._details.rooms.isNotEmpty)
            const Text('Chatrooms:'),
          Container(
            height: 18,
            // TODO(anyone): Use the parent width
            width: MediaQuery.of(context).size.width * 0.63,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: widget._details.rooms.length,
              itemBuilder: (BuildContext context, int index) {
                return Text(widget._details.rooms[index] + '  ');
              },
            ),
          ),
        ],
      ),
    );
  }
}