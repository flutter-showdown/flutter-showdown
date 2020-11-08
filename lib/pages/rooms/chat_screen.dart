import 'package:flutter/material.dart';
import 'package:flutter_showdown/pages/rooms/input_text.dart';
import 'package:flutter_showdown/pages/rooms/message_builder.dart';
import 'package:flutter_showdown/providers/global_messages_enums.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({this.closed, this.messages});

  final bool closed;
  final List<Message> messages;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  Widget _buildMessage(BuildContext context, int idx) {
    bool sameAsP = false;
    bool sameAsN = false;
    final message = widget.messages[idx];

    switch (message.type) {
      case MessageType.Error:
        return Center(
          child: Text(
            message.content,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      case MessageType.Message:
        if (message.type != MessageType.Message) {
          return const Center(child: Text('Html'));
        }

        if (widget.messages.length > 1) {
          if (idx > 0) {
            sameAsP = widget.messages[idx - 1].sender == message.sender;
          }
          if (idx + 1 != widget.messages.length) {
            sameAsN = widget.messages[idx + 1].sender == message.sender;
          }
        }
        return buildMessage(context, message, sameAsP, sameAsN);
      default:
        return const Center(child: Text('Html'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: widget.closed ? const ColorFilter.mode(Color.fromARGB(255, 221, 221, 221), BlendMode.modulate) : const ColorFilter.mode(Colors.white, BlendMode.modulate),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
            ),
          ),
          /*leading: IconButton(
            icon: Icon(
              closed ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
            ),
            splashRadius: 24.0,
            onPressed: () {
              const description = SpringDescription(
                mass: 30,
                stiffness: 1.0,
                damping: 1.0,
              );
              final simulation = SpringSimulation(
                description,
                _controller.value,
                1.0,
                1.0,
              );
              widget.onDrag();
              FocusScope.of(context).requestFocus(FocusNode());
              _controller.animateWith(simulation).then<void>((_) {
                setState(() {
                  closed = !closed;
                  _isSwipingLeft = !_isSwipingLeft;
                  _controller.value = 0.0;
                });
                _updateAnimation();
              });
            },
          ),*/
          title: const Text('Lobby'),
        ),
        body: Container(
          color: ThemeData.light().scaffoldBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: widget.messages.length,
                  itemBuilder: (BuildContext context, int idx) {
                    return _buildMessage(context, idx);
                  },
                ),
              ),
              InputText()
            ],
          ),
        ),
      ),
    );
  }
}
