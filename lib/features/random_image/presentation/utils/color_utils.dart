import 'package:flutter/material.dart';

extension ColorListExtension on List<Color> {
  double get _averageLuminance {
    double totalLuminance = 0;
    for (final color in this) {
      totalLuminance += color.computeLuminance();
    }
    return totalLuminance / length;
  }

  Color get adaptiveTextColor {
    return _averageLuminance > 0.5
        ? Colors.black87
        : Colors.white.withValues(alpha: 0.87);
  }

  Color get adaptiveErrorColor {
    return _averageLuminance > 0.5 ? Colors.red[900]! : Colors.redAccent[400]!;
  }
}
