import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_showdown/constants.dart';
import 'package:flutter_showdown/pages/common/user_details_dialog.dart';
import 'package:flutter_showdown/pages/rooms/input_text.dart';
import 'package:flutter_showdown/parser.dart';
import 'package:provider/provider.dart';
import 'package:flutter_showdown/providers/global_messages_enums.dart';
import 'package:flutter_showdown/providers/room_messages.dart';

import '../../utils.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({this.offset, this.messages, this.onDrag});

  final double offset;
  final List<Message> messages;
  final void Function() onDrag;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  double _lastDragX;
  double _dragStartX;
  bool closed = true;
  bool _isSwipingLeft = false;
  Animation<Offset> _animation;
  AnimationController _controller;

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

  Widget _buildUserMessage(Message message, bool sameAsP, bool sameAsN) {
    final nameArgs = Parser.parseName(message.sender);
    final details = context.read<RoomMessages>().getUserDetails(nameArgs[0]);

    return Padding(
      padding: EdgeInsets.only(
        left: 8,
        right: 48,
        top: sameAsN ? 1 : 8,
        bottom: sameAsP ? 1 : 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (details != null && !sameAsP)
            InkWell(
              onTap: () {
                showDialog<UserDetailsDialog>(context: context, builder: (_) => UserDetailsDialog(nameArgs[1], details));
              },
              child: CircleAvatar(radius: 16, backgroundColor: Colors.blue, backgroundImage: CachedNetworkImageProvider(getAvatarLink(details.avatar)),),
            )
          else
            SizedBox(
              width: 32,
              height: 32,
              child: sameAsP ? Container() : const CircularProgressIndicator(),
            ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!sameAsN)
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        usernameTextColor(nameArgs[0], nameArgs[2]),
                        const SizedBox(width: 8),
                        Text(Groups[nameArgs[1]], style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 241, 241, 241),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(sameAsN ? 4 : 16),
                      bottomLeft: Radius.circular(sameAsP ? 4 : 16),
                      topRight: const Radius.circular(16),
                      bottomRight: const Radius.circular(16),
                    ),
                  ),
                  child: Text(
                    message.content,
                    style: const TextStyle(fontFamily: 'Roboto'),
                  ),
                ),
              ],
            ),
          ),
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
        child: ColorFiltered(
          colorFilter: closed && _controller.value == 0 ?
          const ColorFilter.mode(Color.fromARGB(255, 221, 221, 221), BlendMode.modulate) :
          const ColorFilter.mode(Colors.white, BlendMode.modulate),
          child: Scaffold(
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
                    setState(() {
                      closed = !closed;
                      _isSwipingLeft = closed;
                      _controller.value = 0.0;
                    });
                    _updateAnimation();
                  });
                },
              ),
              title: const Text('Lobby'),
            ),
            body: SizedBox.expand(
              child: Container(
                child: ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: widget.messages.length,
                  itemBuilder: (BuildContext context, int idx) {
                    final message = widget.messages[idx];
                    if (message.type != MessageType.Message) {
                      return const Text('Html');
                    }
                    /*if (message.type == MessageType.Greating) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Divider(indent: 16, endIndent: 16),
                            Text(message.content),
                            const Divider(indent: 16, endIndent: 16),
                          ],
                        )
                      );
                    } else if (message.type == MessageType.Named) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 8),
                        child: RaisedButton(
                          onPressed: () {
                            showDialog<HtmlDialog>(context: context, builder: (_) => HtmlDialog(message.content));
                          },
                          child: Text(message.sender),
                        ),
                      );
                    }*/
                    /*if (widget.messages[idx].type != MessageType.Message) {
                      return
                      //return HtmlBuilder(widget.messages[idx].content);
                    }*/
                    bool sameAsP = false;
                    bool sameAsN = false;

                    if (widget.messages.length > 1) {
                      if (idx > 0) {
                        sameAsP = widget.messages[idx - 1].sender == message.sender;
                      }
                      if (idx + 1 != widget.messages.length) {
                        sameAsN = widget.messages[idx + 1].sender == message.sender;
                      }
                    }
                    return _buildUserMessage(message, sameAsP, sameAsN);
                  },
                ),
              ),
            ),
            bottomNavigationBar: InputText(),
          ),
        ),
      ),
    );
  }

  void _dragStart(DragStartDetails details) {
    _lastDragX = details.localPosition.dx;
    _dragStartX = details.localPosition.dx;
  }

  void _dragUpdate(DragUpdateDetails details) {
    final diff = details.localPosition.dx - _lastDragX;
    final isSwipingLeft = diff < 0;//(details.localPosition.dx - _dragStartX) < 0;

    if (diff.abs() > 10)
      _lastDragX = details.localPosition.dx;
    if (isSwipingLeft != _isSwipingLeft) {
      _isSwipingLeft = isSwipingLeft;
      widget.onDrag();
    }
    setState(() => _controller.value = (details.localPosition.dx - _dragStartX).abs() / context.size.width);
  }

  void _dragEnd(DragEndDetails details) {
    const description = SpringDescription(mass: 30, stiffness: 1.0, damping: 1.0);
    final velocity = (details.velocity.pixelsPerSecond.dx / context.size.width).abs();
    final simulation = SpringSimulation(description, _controller.value, _controller.value >= 0.4 ? 1 : 0, velocity);

    if (_controller.value < 0.4 && _isSwipingLeft == closed) {
      _isSwipingLeft = !_isSwipingLeft;
      widget.onDrag();
    }
    _controller.animateWith(simulation).then<void>((_) {
      setState(() {
        if (_controller.value.round() == 1.0) {
          closed = !closed;
          _updateAnimation();
        }
        _controller.value = 0.0;
      });
    });
  }

  void _updateAnimation() {
    _animation = _controller.drive(Tween<Offset>(
      begin: closed ? Offset(widget.offset, 0) : Offset.zero,
      end: closed ? Offset.zero : Offset(widget.offset, 0),
    ));
  }
}
