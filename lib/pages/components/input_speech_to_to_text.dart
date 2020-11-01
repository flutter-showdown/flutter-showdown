import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class MySpeechToText extends StatefulWidget {
  const MySpeechToText({Key key}) : super(key: key);

  @override
  _SpeechToTextState createState() => _SpeechToTextState();
}

class _SpeechToTextState extends State<MySpeechToText> {
  String _tmp = 'wesh';
  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastError = '';
  String lastStatus = '';
  String _currentLocaleId = '';
  SpeechToText _speech = SpeechToText();

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller;

    void errorListener(SpeechRecognitionError error) {
      setState(() {
        lastError = '${error.errorMsg} - ${error.permanent}';
      });
    }

    void statusListener(String status) {
      setState(() {
        lastStatus = status;
      });
    }

    Future<void> _initSpeechState() async {
      print('fdp');
      _speech
          .initialize(onError: errorListener, onStatus: statusListener)
          .then((bool hasSpeech) => {
                setState(() {
                  _hasSpeech = hasSpeech;
                })
              });
    }

    void _stopListening() {
      _speech.stop();
      setState(() {
        level = 0.0;
      });
    }

    @override
    Future initState() async {
      _controller = TextEditingController();
      super.initState();
    }

    @override
    void dispose() {
      _controller.dispose();
      _stopListening();
      super.dispose();
    }

    void _setText(String value) {
      setState(() {
        _tmp = value;
      });
    }

    void _soundLevelListener(double level) {
      minSoundLevel = min(minSoundLevel, level);
      maxSoundLevel = max(maxSoundLevel, level);
      setState(() {
        this.level = level;
      });
    }

    void _resultListener(SpeechRecognitionResult result) {
      setState(() {
        _tmp = result.recognizedWords;
      });
    }

    void _startListening() {
      lastError = '';
      _speech.listen(
          onResult: _resultListener,
          listenFor: const Duration(seconds: 10),
          localeId: _currentLocaleId,
          onSoundLevelChange: _soundLevelListener,
          cancelOnError: true,
          listenMode: ListenMode.confirmation);
      setState(() {});
    }

    return Column(children: <Widget>[
      Expanded(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: TextField(
                controller: _controller,
                onSubmitted: _setText,
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: const Icon(Icons.mic),
                onPressed: () async {
                  if (!_hasSpeech)
                    await _initSpeechState();
                  else {
                    _startListening();
                  }
                },
              ),
            ),
          ],
        ),
      ),
      Expanded(
          child: Text(_tmp)) // A supprimer c'est juste pour afficher le text
    ]);
  }
}
