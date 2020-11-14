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

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    animationBottom = Tween<double>(begin: 50, end: 180).animate(controller)
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
      right: 30,
      child: Center(
        child: Container(
          width: 120,
          height: 100,
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/flying-pikachu.png'),
              fit: BoxFit.fill,
            ),
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
