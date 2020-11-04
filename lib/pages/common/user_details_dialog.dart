import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_showdown/constants.dart';
import 'package:flutter_showdown/utils.dart';
import 'package:flutter_showdown/providers/global_messages_enums.dart';

//https://pokemonshowdown.com/users/{name}
class UserDetailsDialog extends StatelessWidget {
  const UserDetailsDialog(this._roomGroup, this._details);

  final String _roomGroup;
  final UserDetails _details;

  Text displayStatus(String status) {
    TextStyle style = const TextStyle(fontSize: 12, fontStyle: FontStyle.italic);

    if (status.startsWith(':') || status.startsWith('!(Idle)')) {
      status = '(Offline)';
      style = const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.red);
    } else if (status.startsWith('!')) {
      status = '(Idle)';
    }
    return Text(status, style: style);
  }

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
                backgroundImage: CachedNetworkImageProvider(getAvatarLink(_details.avatar)),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_details.name, style: const TextStyle(fontSize: 20)),
                      displayStatus(_details.status),
                      if (_roomGroup != _details.group)
                        Text(Groups[_roomGroup], style: const TextStyle(fontSize: 14)),
                      if (_details.group != ' ')
                        Text('Global ' + Groups[_details.group], style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          /*const Divider(),
          const Text('Battles:'),*/
          if (_details.rooms.isNotEmpty) const Divider(),
          if (_details.rooms.isNotEmpty) const Text('Chatrooms:'),
          if (_details.rooms.isNotEmpty)
            Container(
              height: 18,
              // TODO(anyone): Use the parent width
              width: MediaQuery.of(context).size.width * 0.63,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: _details.rooms.length,
                itemBuilder: (BuildContext context, int index) {
                  return Text(_details.rooms[index] + '  ');
                },
              ),
            ),
        ],
      ),
    );
  }
}