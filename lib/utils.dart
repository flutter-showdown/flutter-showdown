import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:image/image.dart' as imglib;

import 'constants.dart';

class SplitParameters {
  SplitParameters(this.url, this.horizontalPieceCount, this.verticalPieceCount);

  String url;
  int horizontalPieceCount = 1;
  int verticalPieceCount = 1;
}

Future<List<Image>> splitImages(SplitParameters parameters) async {
  final image = imglib.decodePng((await http.get(parameters.url)).bodyBytes);
  final int xLength = (image.width / parameters.horizontalPieceCount).round();
  final int yLength = (image.height / parameters.verticalPieceCount).round();
  final outputImageList = <Image>[];

  for (int y = 0; y < parameters.verticalPieceCount; y++)
    for (int x = 0; x < parameters.horizontalPieceCount; x++) {
      outputImageList.add(Image.memory(Uint8List.fromList(imglib.encodeJpg(imglib.copyCrop(image, x * xLength, y * yLength, xLength, yLength)))));
    }
  return outputImageList;
}

String getAvatarLink(String avatar) {
  String link = '';
  const String AvatarLinkPrefix = ServerUrl + '/sprites/trainers/';
  const String CustomAvatarLinkPrefix = ServerUrl + '/sprites/trainers-custom/';

  if (int.tryParse(avatar) != null) {
    avatar = BattleAvatarNumbers[avatar];
  }
  if (AvatarsAvailable.contains(avatar)) {
    link = AvatarLinkPrefix + avatar + '.png';
  } else {
    if (avatar.startsWith('#')) {
      avatar = avatar.substring(1);
    }
    link = CustomAvatarLinkPrefix + avatar + '.png';
  }
  return link;
}

Text usernameTextColor(String username, String status) {
  Color color = Colors.grey;

  if (!status.startsWith('!')) {
    final int modulo = username.length % 5;
    if (modulo == 0) {
      color = Colors.lightBlue;
    } else if (modulo == 1) {
      color = Colors.orange;
    } else if (modulo == 2) {
      color = Colors.pink;
    } else if (modulo == 3) {
      color = Colors.lightGreen;
    } else if (modulo == 4) {
      color = Colors.deepPurple;
    }
  }

  return Text(
    username,
    style: TextStyle(
      color: color,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.bold,
    ),
  );
}