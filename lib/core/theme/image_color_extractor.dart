import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class ImageColorExtractor {
  Future<Color> dominantColor(ImageProvider image) async {
    final imageObj = await _resolveImage(image);
    return await _getAverageColor(imageObj);
  }

  Future<List<Color>> gradientColors(ImageProvider image) async {
    final imageObj = await _resolveImage(image);
    final topColor = await _getTopColor(imageObj);
    final bottomColor = await _getBottomColor(imageObj);
    return [topColor, bottomColor];
  }

  Future<ui.Image> _resolveImage(ImageProvider provider) async {
    final completer = Completer<ui.Image>();
    final imageStream = provider.resolve(const ImageConfiguration());
    late final ImageStreamListener listener;
    listener = ImageStreamListener((ImageInfo info, bool _) {
      if (!completer.isCompleted) {
        completer.complete(info.image);
        imageStream.removeListener(listener);
      }
    });
    imageStream.addListener(listener);
    final image = await completer.future;
    imageStream.removeListener(listener);
    return image;
  }

  Future<Color> _getTopColor(ui.Image image) async {
    final pixelData = await image.toByteData(
      format: ui.ImageByteFormat.rawRgba,
    );
    if (pixelData == null) return Colors.black;

    final width = image.width;
    final sampleSize = width > 100 ? 10 : 1;
    var r = 0, g = 0, b = 0, count = 0;

    for (var x = 0; x < width; x += sampleSize) {
      final offset = (x * 4);
      r += pixelData.getUint8(offset);
      g += pixelData.getUint8(offset + 1);
      b += pixelData.getUint8(offset + 2);
      count++;
    }

    if (count == 0) return Colors.black;
    return Color.fromRGBO(
      (r / count).round(),
      (g / count).round(),
      (b / count).round(),
      1.0,
    );
  }

  Future<Color> _getBottomColor(ui.Image image) async {
    final pixelData = await image.toByteData(
      format: ui.ImageByteFormat.rawRgba,
    );
    if (pixelData == null) return Colors.black;

    final width = image.width;
    final height = image.height;
    final sampleSize = width > 100 ? 10 : 1;
    var r = 0, g = 0, b = 0, count = 0;

    final bottomRowOffset = ((height - 1) * width * 4);
    for (var x = 0; x < width; x += sampleSize) {
      final offset = bottomRowOffset + (x * 4);
      r += pixelData.getUint8(offset);
      g += pixelData.getUint8(offset + 1);
      b += pixelData.getUint8(offset + 2);
      count++;
    }

    if (count == 0) return Colors.black;
    return Color.fromRGBO(
      (r / count).round(),
      (g / count).round(),
      (b / count).round(),
      1.0,
    );
  }

  Future<Color> _getAverageColor(ui.Image image) async {
    final pixelData = await image.toByteData(
      format: ui.ImageByteFormat.rawRgba,
    );
    if (pixelData == null) return Colors.black;

    final width = image.width;
    final height = image.height;
    final sampleSize = (width * height > 10000) ? 10 : 1;
    var r = 0, g = 0, b = 0, count = 0;

    for (var y = 0; y < height; y += sampleSize) {
      for (var x = 0; x < width; x += sampleSize) {
        final offset = ((y * width) + x) * 4;
        r += pixelData.getUint8(offset);
        g += pixelData.getUint8(offset + 1);
        b += pixelData.getUint8(offset + 2);
        count++;
      }
    }

    if (count == 0) return Colors.black;
    return Color.fromRGBO(
      (r / count).round(),
      (g / count).round(),
      (b / count).round(),
      1.0,
    );
  }
}
