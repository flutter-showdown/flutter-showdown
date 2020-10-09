import 'dart:developer';

import 'package:flutter/material.dart';

import 'websockets/global_messages.dart';

import '../utils.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Future<List<Image>> images;

  @override
  void initState() {
    super.initState();

    //globalMessages.addListener(_globalMessageReceived);
    //images = splitImages("https://play.pokemonshowdown.com/sprites/trainers-sheet.png", horizontalPieceCount: 16, verticalPieceCount: 19);
  }

  _globalMessageReceived(message) {

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Text("OUI")/*FutureBuilder(
          future: images,
          builder: (BuildContext context, AsyncSnapshot<List<Image>> snapshot) {
            if (snapshot.hasData) {
              return GridView.count(
                crossAxisCount: 6,
                children: snapshot.data,
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        )*/,
      ),
    );
  }
}
