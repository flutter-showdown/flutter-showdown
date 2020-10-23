import 'package:flutter/material.dart';

class SpeechToText extends StatefulWidget {
  @override
  _SpeechToTextState createState() => _SpeechToTextState();
}

class _SpeechToTextState extends State<SpeechToText> {
  String _tmp = 'wesh';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller;

    void initState() {
      super.initState();
      _controller = TextEditingController();
    }

    void dispose() {
      _controller.dispose();
      super.dispose();
    }

    void _setText(String value) {
      setState(() {
        _tmp = value;
      });
    }

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _controller,
                onSubmitted: _setText,
              ),
            ),
            Expanded(
              child: RaisedButton(
                onPressed: () {
                  _setText(_controller.text);
                },
                textColor: Colors.white,
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: const Text('Recorde', style: TextStyle(fontSize: 20)),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Text(_tmp, textAlign: TextAlign.center),
        ),
      ],
    );
  }
}
