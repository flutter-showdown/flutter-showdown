import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_showdown/pages/common/user_details_dialog.dart';
import 'package:flutter_showdown/parser.dart';
import 'package:provider/provider.dart';
import 'package:flutter_showdown/providers/global_messages_enums.dart';
import 'package:flutter_showdown/providers/room_messages.dart';

import '../../utils.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({this.offset, this.messages});

  final double offset;
  final List<UserMessage> messages;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  Animation<Offset> _animation;
  AnimationController _controller;
  double _dragStartX;
  bool closed = true;
  bool _isSwipingLeft = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController.unbounded(vsync: this);
    _updateAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  Widget _buildMessage(UserMessage message) {
    final nameArgs = Parser.parseName(message.sender);
    final details = context.read<RoomMessages>().getUserDetails(nameArgs[0]);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (details != null)
            InkWell(
              onTap: () {
                showDialog<UserDetailsDialog>(context: context, builder: (_) => UserDetailsDialog(nameArgs[1], details));
              },
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.blue,
                backgroundImage: CachedNetworkImageProvider(getAvatarLink(details.avatar)),
              ),
            )
          else
            const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nameArgs[0]),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(message.content),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: GestureDetector(
        onHorizontalDragStart: _dragStart,
        onHorizontalDragUpdate: _dragUpdate,
        onHorizontalDragEnd: _dragEnd,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
              ),
            ),
            leading: IconButton(
              icon: Icon(closed ? Icons.arrow_back_ios : Icons.arrow_forward_ios),
              splashRadius: 24.0,
              onPressed: () {
                const description = SpringDescription(mass: 30, stiffness: 1.0, damping: 1.0);
                final simulation = SpringSimulation(description, _controller.value, 1.0, 1.0);

                _controller.animateWith(simulation).then<void>((_) {
                  // TODO(anyone): This is called after ~1 second can lead to problems
                  setState(() {
                    closed = !closed;
                    _isSwipingLeft = closed;
                    _controller.value = 0.0;
                  });
                  _updateAnimation();
                });
              },
            ),
            title: Text('Lobby'),
          ),
          body: SizedBox.expand(
            child: Container(
              color: ThemeData.light().scaffoldBackgroundColor,
              child: ListView.builder(
                reverse: true,
                itemCount: widget.messages.length,
                itemBuilder: (BuildContext context, int idx) {
                  return _buildMessage(widget.messages[idx]);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _dragStart(DragStartDetails details) {
    _dragStartX = details.localPosition.dx;
  }

  void _dragUpdate(DragUpdateDetails details) {
    final isSwipingLeft = (details.localPosition.dx - _dragStartX) < 0;

    if (isSwipingLeft != _isSwipingLeft) {
      _isSwipingLeft = isSwipingLeft;

      _updateAnimation();
    }

    setState(() {
      _controller.value = (details.localPosition.dx - _dragStartX).abs() / context.size.width;
    });
  }

  void _dragEnd(DragEndDetails details) {
    const description = SpringDescription(mass: 30, stiffness: 1.0, damping: 1.0);
    final velocity = (details.velocity.pixelsPerSecond.dx / context.size.width).abs();
    final simulation = SpringSimulation(description, _controller.value, _controller.value >= 0.4 ? 1 : 0, velocity);

    _controller.animateWith(simulation).then<void>((_) {
      // TODO(anyone): This is called after ~1 second can lead to problems
      if (_controller.value.round() == 1.0) {
        setState(() {
          closed = !closed;
          _isSwipingLeft = closed;
          _controller.value = 0.0;
        });
        _updateAnimation();
      }
    });
  }

  void _updateAnimation() {
    _animation = _controller.drive(Tween<Offset>(
      begin: closed ? Offset(widget.offset, 0) : Offset.zero,
      end: _isSwipingLeft ? Offset.zero : Offset(widget.offset, 0),
    ));
  }
}
