import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurora_assessment/features/random_image/presentation/utils/color_utils.dart';

void main() {
  group('ColorListExtension', () {
    group('adaptiveTextColor', () {
      test('returns black87 for light colors', () {
        final colors = [Colors.white, Colors.yellow, Colors.lightBlue];
        expect(colors.adaptiveTextColor, Colors.black87);
      });

      test('returns white87 for dark colors', () {
        final colors = [Colors.black, Colors.blueGrey, Colors.indigo];
        expect(colors.adaptiveTextColor, Colors.white.withValues(alpha: 0.87));
      });

      test('returns black87 for mixed colors with light average', () {
        final colors = [Colors.white, Colors.black, Colors.white];
        expect(colors.adaptiveTextColor, Colors.black87);
      });

      test('returns white87 for mixed colors with dark average', () {
        final colors = [Colors.black, Colors.white, Colors.black];
        expect(colors.adaptiveTextColor, Colors.white.withValues(alpha: 0.87));
      });

      test('handles single light color', () {
        final colors = [Colors.white];
        expect(colors.adaptiveTextColor, Colors.black87);
      });

      test('handles single dark color', () {
        final colors = [Colors.black];
        expect(colors.adaptiveTextColor, Colors.white.withValues(alpha: 0.87));
      });

      test('handles threshold case at 0.5 luminance', () {
        final gray = const Color(0xFF808080);
        final colors = [gray];
        final luminance = gray.computeLuminance();
        if (luminance > 0.5) {
          expect(colors.adaptiveTextColor, Colors.black87);
        } else {
          expect(
            colors.adaptiveTextColor,
            Colors.white.withValues(alpha: 0.87),
          );
        }
      });
    });

    group('adaptiveErrorColor', () {
      test('returns red900 for light colors', () {
        final colors = [Colors.white, Colors.yellow, Colors.lightBlue];
        expect(colors.adaptiveErrorColor, Colors.red[900]!);
      });

      test('returns redAccent400 for dark colors', () {
        final colors = [Colors.black, Colors.blueGrey, Colors.indigo];
        expect(colors.adaptiveErrorColor, Colors.redAccent[400]!);
      });

      test('returns red900 for mixed colors with light average', () {
        final colors = [Colors.white, Colors.black, Colors.white];
        expect(colors.adaptiveErrorColor, Colors.red[900]!);
      });

      test('returns redAccent400 for mixed colors with dark average', () {
        final colors = [Colors.black, Colors.white, Colors.black];
        expect(colors.adaptiveErrorColor, Colors.redAccent[400]!);
      });

      test('handles single light color', () {
        final colors = [Colors.white];
        expect(colors.adaptiveErrorColor, Colors.red[900]!);
      });

      test('handles single dark color', () {
        final colors = [Colors.black];
        expect(colors.adaptiveErrorColor, Colors.redAccent[400]!);
      });
    });
  });
}
