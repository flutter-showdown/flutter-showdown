import 'package:flutter/material.dart';

class GreenClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height / 4.25);
    final firstControlPoint = Offset(size.width / 4, size.height / 3);
    final firstEndPoint = Offset(size.width / 2, size.height / 3 - 60);
    final secondControlPoint =
        Offset(size.width - (size.width / 4), size.height / 4 - 65);
    final secondEndPoint = Offset(size.width, size.height / 3 - 40);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height / 3);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return null;
  }
}
