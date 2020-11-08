import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';

class ButtonOutlineColor extends StatelessWidget {
  const ButtonOutlineColor({@required this.text, @required this.onTap});

  final void Function() onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return OutlineGradientButton(
      gradient: LinearGradient(
        colors: <Color>[Colors.lightBlue[200], Colors.lightBlue],
      ),
      onTap: () => onTap(),
      child: Center(child: Text(text)),
      strokeWidth: 2,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      radius: const Radius.circular(8),
    );
  }
}
