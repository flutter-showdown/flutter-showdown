import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ButtonPlainColor extends StatelessWidget {
  const ButtonPlainColor({
    @required this.text,
    @required this.onTap,
    this.color = Colors.lightBlue,
  });

  final void Function() onTap;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final hsl = HSLColor.fromColor(color);
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        gradient: LinearGradient(
          colors: <Color>[
            hsl
                .withLightness((hsl.lightness + 0.25).clamp(0, 1).toDouble())
                .toColor(),
            color
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[500],
            offset: const Offset(0.0, 1.5),
            blurRadius: 1.5,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
