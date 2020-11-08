import 'package:flutter/material.dart';
import 'package:flutter_showdown/pages/common/login_dialog.dart';
import 'package:flutter_showdown/pages/common/speech_to_text.dart';
import 'package:flutter_showdown/providers/room_messages.dart';
import 'package:flutter_showdown/providers/global_messages.dart';
import 'package:provider/provider.dart';

class InputText extends StatefulWidget {
  @override
  _InputTextState createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  bool _focused = false;
  final _focus = FocusNode();
  final _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() => _focused = _focus.hasFocus);
  }

  @override
  void dispose() {
    _focus.dispose();
    _inputController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<GlobalMessages>().user;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MySpeechToText(
          unFocus: _focus.unfocus,
          onResult: (result) => setState(() => _inputController.text = result),
        ),
        if (!user.named)
          Expanded(
            child: ElevatedButton(
              child: const Text('Join Chat'),
              onPressed: () {
                showDialog<LoginDialog>(
                  context: context,
                  builder: (_) => LoginDialog(),
                );
              },
            ),
          )
        else
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 241, 241, 241),
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: TextField(
                minLines: 1,
                maxLines: 5,
                focusNode: _focus,
                controller: _inputController,
                textInputAction: TextInputAction.send,
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: 'Enter Text...',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                ),
              ),
            ),
          ),
        Material(
          child: Ink(
            child: IconButton(
              icon: const Icon(Icons.send),
              tooltip: 'Send',
              color: _focused ? Colors.blue : Colors.grey,
              onPressed: () {
                context.read<RoomMessages>().sendMessage(_inputController.text);

                _focus.unfocus();
                _inputController.clear();
              },
            ),
          ),
        ),
      ],
    );
  }
}
