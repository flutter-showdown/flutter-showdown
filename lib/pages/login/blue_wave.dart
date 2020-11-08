import 'dart:ui';

import 'package:flutter/material.dart';

class BottomWaveContainer extends StatefulWidget {
  const BottomWaveContainer(this.child);
  final Widget child;

  @override
  _BottomWaveContainerState createState() => _BottomWaveContainerState();
}

class _BottomWaveContainerState extends State<BottomWaveContainer>
    with SingleTickerProviderStateMixin {
  Animation<double> animationBottom;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    animationBottom = Tween<double>(begin: -40.0, end: 0.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed)
        controller.forward();
      else if (status == AnimationStatus.completed) {
        controller.reverse();
      }
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      child: widget.child,
      curve: Curves.elasticOut,
      tween: Tween(begin: -40.0, end: 0.0),
      duration: const Duration(seconds: 3),
      builder: (BuildContext context, double size, Widget child) {
        return ClipPath(
          child: child,
          clipper: BottomWaveClipper(value: animationBottom.value),
        );
      },
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  BottomWaveClipper({this.value}) : super();
  final double value;

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
