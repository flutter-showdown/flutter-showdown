import 'package:flutter/material.dart';

class PrivateChannelsList extends StatefulWidget {
  const PrivateChannelsList({this.onChannelChange});

  final void Function(String) onChannelChange;

  @override
  State<StatefulWidget> createState() => _PrivateChannelsListState();
}

class _PrivateChannelsListState extends State<PrivateChannelsList> {
  String channel = 'News';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Private Messages'),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
      ),
      body: Container(
        color: ThemeData.light().scaffoldBackgroundColor,
        child: Column(
          children: [
            Material(
              child: ListTile(
                title: const Text('News'),
                subtitle: const Text('News of the day'),
                visualDensity: VisualDensity.compact,
                leading: const CircleAvatar(
                  child: Icon(Icons.new_releases, color: Colors.white),
                  backgroundColor: Colors.blue,
                ),
                onTap: () {
                  if (widget.onChannelChange != null) {
                    widget.onChannelChange(channel);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}