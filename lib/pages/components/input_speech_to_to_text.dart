import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class MySpeechToText extends StatefulWidget {
  @override
  _SpeechToTextState createState() => _SpeechToTextState();
}

class _SpeechToTextState extends State<MySpeechToText> {
  String _tmp = 'wesh';
  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = "";
  List<LocaleName> _localeNames = [];
  final SpeechToText speech = SpeechToText();

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

    void soundLevelListener(double level) {
      minSoundLevel = min(minSoundLevel, level);
      maxSoundLevel = max(maxSoundLevel, level);
      // print("sound level $level: $minSoundLevel - $maxSoundLevel ");
      setState(() {
        this.level = level;
      });
    }

    void resultListener(SpeechRecognitionResult result) {
      setState(() {
        lastWords = "${result.recognizedWords} - ${result.finalResult}";
      });
    }

    void startListening() {
      lastWords = "";
      lastError = "";
      speech.listen(
          onResult: resultListener,
          listenFor: Duration(seconds: 10),
          localeId: _currentLocaleId,
          onSoundLevelChange: soundLevelListener,
          cancelOnError: true,
          listenMode: ListenMode.confirmation);
      setState(() {});
    }

    void stopListening() {
      speech.stop();
      setState(() {
        level = 0.0;
      });
    }

    void cancelListening() {
      speech.cancel();
      setState(() {
        level = 0.0;
      });
    }

    void errorListener(SpeechRecognitionError error) {
      // print("Received error status: $error, listening: ${speech.isListening}");
      setState(() {
        lastError = "${error.errorMsg} - ${error.permanent}";
      });
    }

    void statusListener(String status) {
      // print(
      // "Received listener status: $status, listening: ${speech.isListening}");
      setState(() {
        lastStatus = "$status";
      });
    }

    Future<void> initSpeechState() async {
      bool hasSpeech = await speech.initialize(
          onError: errorListener, onStatus: statusListener);
      if (hasSpeech) {
        _localeNames = await speech.locales();

        var systemLocale = await speech.systemLocale();
        _currentLocaleId = systemLocale.localeId;
      }

      if (!mounted) return;

      setState(() {
        _hasSpeech = hasSpeech;
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
            FlatButton(
              child: Text('Initialize'),
              onPressed: _hasSpeech ? null : initSpeechState,
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
        Container(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FlatButton(
                    child: Text('Initialize'),
                    onPressed: _hasSpeech ? null : initSpeechState,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FlatButton(
                    child: Text('Start'),
                    onPressed: !_hasSpeech || speech.isListening
                        ? null
                        : startListening,
                  ),
                  FlatButton(
                    child: Text('Stop'),
                    onPressed: speech.isListening ? stopListening : null,
                  ),
                  FlatButton(
                    child: Text('Cancel'),
                    onPressed: speech.isListening ? cancelListening : null,
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Column(
            children: <Widget>[
              Center(
                child: Text(
                  'Recognized Words',
                  style: TextStyle(fontSize: 22.0),
                ),
              ),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Container(
                      color: Theme.of(context).selectedRowColor,
                      child: Center(
                        child: Text(
                          lastWords,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      bottom: 10,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: .26,
                                  spreadRadius: level * 1.5,
                                  color: Colors.black.withOpacity(.05))
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          child: IconButton(icon: Icon(Icons.mic)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            children: <Widget>[
              Center(
                child: Text(
                  'Error Status',
                  style: TextStyle(fontSize: 22.0),
                ),
              ),
              Center(
                child: Text(lastError),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          color: Theme.of(context).backgroundColor,
          child: Center(
            child: speech.isListening
                ? Text(
                    "I'm listening...",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                : Text(
                    'Not listening',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ],
    );
  }
}
