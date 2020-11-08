import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PokemonAnimation extends StatefulWidget {
  @override
  _PokemonAnimationState createState() => _PokemonAnimationState();
}

class _PokemonAnimationState extends State<PokemonAnimation>
    with SingleTickerProviderStateMixin {
  Animation<double> animationBottom;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    animationBottom = Tween<double>(begin: 50, end: 100).animate(controller)
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
    return Positioned(
      top: animationBottom.value,
      left: 50,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          height: 100,
          width: 120,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/icons/sprite.png'), fit: BoxFit.fill),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
