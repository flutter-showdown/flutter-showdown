import 'package:flutter/material.dart';
import 'package:flutter_showdown/models/item.dart';
import 'package:flutter_showdown/screens/pokedex/items/item_card.dart';
import 'package:provider/provider.dart';

class ItemList extends StatelessWidget {
  const ItemList();

  @override
  Widget build(BuildContext context) {
    final items = Provider.of<Map<String, Item>>(context, listen: false).values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (_, idx) => Container(
                child: ItemCard(items[idx]),
                color: idx % 2 == 0 ? const Color(0xffebebf7) : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
