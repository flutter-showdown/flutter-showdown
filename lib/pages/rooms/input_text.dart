import 'package:flutter/material.dart';
import 'package:flutter_showdown/pages/common/speech_to_text.dart';

class InputText extends StatefulWidget {
  @override
  _InputTextState createState() => _InputTextState();
}

class _InputTextState extends State<InputText>
    with SingleTickerProviderStateMixin {
  final _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: ThemeData.light().scaffoldBackgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MySpeechToText(
            onResult: (String result) => setState(() => _inputController.text = result),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 241, 241, 241),
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: TextField(
                controller: _inputController,
                decoration: const InputDecoration(hintText: 'Enter Text...'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
