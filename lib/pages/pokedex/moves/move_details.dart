import 'package:flutter/material.dart';
import 'package:flutter_showdown/models/move.dart';

const Map<String, List<Color>> categoryColors = {
  'Physical': [Color(0xffB8A038), Color(0xff93802D), Color(0xff746523)],
  'Special': [Color(0xffB8B8D0), Color(0xff9797BA), Color(0xff7A7AA7)],
  'Status': [Color(0xff6890F0), Color(0xff386CEB), Color(0xff1753E3)],
};

class MoveDetails extends StatelessWidget {
  const MoveDetails(this.move);

  final Move move;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(move.name),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(),
      ),
    );
  }
}
