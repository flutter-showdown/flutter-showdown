import 'package:flutter/material.dart';
import 'package:flutter_showdown/models/ability.dart';
import 'package:flutter_showdown/parser.dart';
import 'package:provider/provider.dart';

class AbilityDetails extends StatelessWidget {
  const AbilityDetails(this.abilityName);
  final String abilityName;

  @override
  Widget build(BuildContext context) {
    final abilityId = Parser.toId(abilityName);
    final ability =
        Provider.of<Map<String, Ability>>(context, listen: false)[abilityId];
    return Scaffold(
      appBar: AppBar(
        title: Text(ability.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(ability.desc),
            )
          ],
        ),
      ),
    );
  }
}
