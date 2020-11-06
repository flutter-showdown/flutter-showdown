import 'dart:ui';

import 'package:flutter/material.dart';

class BottomWaveContainer extends StatelessWidget {
  final Widget child;

  BottomWaveContainer(this.child);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      child: child,
      curve: Curves.elasticOut,
      tween: Tween(begin: -50.0, end: 0.0),
      duration: const Duration(seconds: 10),
      builder: (BuildContext context, double size, Widget child) {
        return ClipPath(
          child: child,
          clipper: BottomWaveClipper(value: size),
        );
      },
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  final double value;

  BottomWaveClipper({this.value}) : super();

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height / 4.25);

    final firstControlPoint = Offset(size.width / 4, (size.height / 3) - value);
    final firstEndPoint = Offset(size.width / 2, size.height / 3 - 60);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    final secondControlPoint =
        Offset(size.width - (size.width / 4), (size.height / 4 - 65) + value);
    final secondEndPoint = Offset(size.width, (size.height / 3) - 40);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) =>
      oldClipper is BottomWaveClipper && value != oldClipper.value;
}
