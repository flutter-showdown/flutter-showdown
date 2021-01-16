import 'package:flutter/material.dart';
import 'package:flutter_showdown/models/item.dart';
import 'package:flutter_showdown/screens/pokedex/items/item_details.dart';

class ItemCard extends StatelessWidget {
  const ItemCard(this.item);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      leading: Image.asset('assets/item-icons/${item.spriteNum}.png'),
      title: Text(item.name),
      subtitle: Text(
        item.shortDesc ?? item.desc,
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (context) => ItemDetails(item)),
      ),
    );
  }
}
