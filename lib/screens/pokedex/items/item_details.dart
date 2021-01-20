import 'package:flutter/material.dart';
import 'package:flutter_showdown/models/item.dart';

class ItemDetails extends StatelessWidget {
  const ItemDetails(this.item);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(6))),
                padding: const EdgeInsets.all(8),
                child: Image.asset('assets/item-icons/${item.spriteNum}.png')),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                item.desc,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
