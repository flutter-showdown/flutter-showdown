import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class MySpeechToText extends StatefulWidget {
  const MySpeechToText({this.onResult, this.onStatus, this.unFocus});

  final void Function(String result) onResult;
  final void Function(String result) onStatus;
  final void Function({UnfocusDisposition disposition}) unFocus;

  @override
  _SpeechToTextState createState() => _SpeechToTextState();
}

class _SpeechToTextState extends State<MySpeechToText> {
  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  final String _currentLocaleId = '';
  final SpeechToText _speech = SpeechToText();

  Future<void> initSpeechState() async {
    final bool hasSpeech = await _speech.initialize(
      onError: errorListener,
      onStatus: statusListener,
    );

    if (!mounted) {
      return;
    }
    setState(() => _hasSpeech = hasSpeech);
  }

  void startListening() {
    _speech.listen(
      onResult: resultListener,
      listenFor: const Duration(seconds: 10),
      localeId: _currentLocaleId,
      onSoundLevelChange: soundLevelListener,
      cancelOnError: true,
      listenMode: ListenMode.confirmation,
    );
    setState(() {});
  }

  void stopListening() {
    _speech.stop();

    setState(() => level = 0.0);
  }

  void cancelListening() {
    _speech.cancel();

    setState(() => level = 0.0);
  }

  void resultListener(SpeechRecognitionResult result) {
    if (result.recognizedWords.isNotEmpty)
      widget.onResult(result.recognizedWords);
  }

  void soundLevelListener(double newLevel) {
    minSoundLevel = min(minSoundLevel, newLevel);
    maxSoundLevel = max(maxSoundLevel, newLevel);

    setState(() => level = newLevel);
  }

  void errorListener(SpeechRecognitionError error) {}

  void statusListener(String status) {
    if (widget.onStatus != null) {
      widget.onStatus(status);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        child: GestureDetector(
          child: IconButton(
            icon: const Icon(Icons.mic, size: 30),
            color: Colors.blue,
            onPressed: () {
              if (widget.unFocus != null) {
                widget.unFocus();
              }
            },
            tooltip: 'Listening',
          ),
          onTapDown: (details) {
            if (!_hasSpeech) {
              initSpeechState();
            } else if (!_speech.isListening) {
              startListening();
            }
          },
          onLongPressEnd: (details) {
            if (_speech.isListening) {
              Future.delayed(const Duration(seconds: 1), () => stopListening());
            }
          },
        ),
      ),
    );
  }
}
