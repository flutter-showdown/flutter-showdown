import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:image/image.dart' as imglib;

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
  List<Image> outputImageList = List<Image>();

  for (int y = 0; y < parameters.verticalPieceCount; y++)
    for (int x = 0; x < parameters.horizontalPieceCount; x++) {
      outputImageList.add(Image.memory(imglib.encodeJpg(
          imglib.copyCrop(image, x * xLength, y * yLength, xLength, yLength))));
    }
  return outputImageList;
}
