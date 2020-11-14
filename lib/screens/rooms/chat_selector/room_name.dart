import 'package:flutter/material.dart';

class RoomName extends StatelessWidget {
  const RoomName(this.name, {this.fontSize = 12});

  final String name;
  final double fontSize;

  String _getInitials(String name) {
    String initials = '';

    if (name.length <= 6) {
      return name;
    }

    for (final String word in name.split(' ')) {
      initials += word[0];
      for (int i = 1; i < word.length; i++) {
        if (word[i] == word[i].toUpperCase()) {
          initials += word[i];
        }
      }
    }
    return initials;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        _getInitials(name),
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.white,
        ),
      ),
    );
  }
}