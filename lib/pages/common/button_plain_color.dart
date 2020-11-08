import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ButtonPlainColor extends StatelessWidget {
  const ButtonPlainColor({@required this.text, @required this.onTap});

  final void Function() onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            gradient: LinearGradient(
              colors: <Color>[Colors.lightBlue[200], Colors.lightBlue],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[500],
                offset: const Offset(0.0, 1.5),
                blurRadius: 1.5,
              ),
            ]),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: () => onTap(),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Center(
                    child: Text(
                      text,
                      style: const TextStyle(
                          color: Colors.white, fontFamily: 'Roboto'),
                    ),
                  ),
                ))));
  }
}
