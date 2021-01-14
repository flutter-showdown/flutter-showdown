import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_showdown/screens/pokedex/common/type_effectiveness.dart';

class TypeBox extends StatelessWidget {
  const TypeBox(
    this.type, {
    this.textColor = Colors.white,
    this.width = 72,
    this.height = 24,
    this.fontSize = 13,
    this.pressable = true,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
  });

  final String type;
  final Color textColor;
  final double width;
  final double height;
  final double fontSize;
  final bool pressable;
  final BorderRadiusGeometry borderRadius;

  static const Map<String, List<Color>> typeColors = {
    'Bird': [Color(0xffCBC9CB), Color(0xffAAA6AA), Color(0xffa99890)],
    'Bug': [Color(0xffA8B820), Color(0xff8D9A1B), Color(0xff616B13)],
    'Dark': [Color(0xff705848), Color(0xff513F34), Color(0xff362A23)],
    'Dragon': [Color(0xff7038F8), Color(0xff4C08EF), Color(0xff3D07C0)],
    'Electric': [Color(0xffF8D030), Color(0xffF0C108), Color(0xffC19B07)],
    'Fairy': [Color(0xffF98CFF), Color(0xffF540FF), Color(0xffC1079B)],
    'Fighting': [Color(0xffC03028), Color(0xff9D2721), Color(0xff82211B)],
    'Fire': [Color(0xffF08030), Color(0xffDD6610), Color(0xffB4530D)],
    'Flying': [Color(0xffA890F0), Color(0xff9180C4), Color(0xff7762B6)],
    'Ghost': [Color(0xff705898), Color(0xff554374), Color(0xff413359)],
    'Grass': [Color(0xff78C850), Color(0xff5CA935), Color(0xff4A892B)],
    'Ground': [Color(0xffE0C068), Color(0xffD4A82F), Color(0xffAA8623)],
    'Ice': [Color(0xff98D8D8), Color(0xff69C6C6), Color(0xff45B6B6)],
    'Normal': [Color(0xffA8A878), Color(0xff8A8A59), Color(0xff79794E)],
    'Poison': [Color(0xffA040A0), Color(0xff803380), Color(0xff662966)],
    'Psychic': [Color(0xffF85888), Color(0xffF61C5D), Color(0xffD60945)],
    'Rock': [Color(0xffB8A038), Color(0xff93802D), Color(0xff746523)],
    'Steel': [Color(0xffB8B8D0), Color(0xff9797BA), Color(0xff7A7AA7)],
    'Water': [Color(0xff6890F0), Color(0xff386CEB), Color(0xff1753E3)],
    'Physical': [Color(0xffdc7b69), Color(0xffD25640), Color(0xff73241f)],
    'Special': [Color(0xff7590be), Color(0xff5274ae), Color(0xff4a3932)],
    'Status': [Color(0xffc3bdb1), Color(0xffada594), Color(0xff525252)],
  };

  @override
  Widget build(BuildContext context) {
    Widget content = Text(
      type.toUpperCase(),
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        shadows: const [
          Shadow(
            blurRadius: 1,
            offset: Offset(1, 1),
            color: Color(0xff333333),
          ),
        ],
      ),
    );

    if (type == 'Physical' || type == 'Special' || type == 'Status') {
      content = Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: SvgPicture.asset('assets/categories/$type.svg'),
      );
    }

    final Widget box = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: typeColors[type][2]),
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [typeColors[type][0], typeColors[type][1]],
        ),
      ),
      child: Center(child: content),
    );

    if (pressable) {
      return GestureDetector(
        child: box,
        onTap: () {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder<TypeEffectiveness>(
              pageBuilder: (context, _, __) => TypeEffectiveness(type),
              transitionDuration: const Duration(seconds: 0),
            ),
          );
        },
      );
    }
    return box;
  }
}
