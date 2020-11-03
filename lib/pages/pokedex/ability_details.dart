import 'package:flutter/material.dart';
// import 'package:flutter_showdown/parser.dart';

class AbilityDetails extends StatelessWidget {
  const AbilityDetails(this.ability);

  final String ability;

  @override
  Widget build(BuildContext context) {
    // final abilityId = Parser.toId(ability);
    return Scaffold(
      appBar: AppBar(
        title: Text(ability),
      ),
      body: Container(
        child: Column(
          children: [Text(ability)],
        ),
      ),
    );
  }
}
