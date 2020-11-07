import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';

class ButtonOutlineColor extends StatelessWidget {
  const ButtonOutlineColor({@required this.text, @required this.actionName});

  final void Function() actionName;
  final String text;

  @override
  Widget build(BuildContext context) {
    return OutlineGradientButton(
      gradient: const LinearGradient(
        colors: <Color>[Colors.blue, Colors.green],
      ),
      onTap: () => {actionName()},
      child: Center(child: Text(text)),
      strokeWidth: 2,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      radius: const Radius.circular(8),
    );
  }
}