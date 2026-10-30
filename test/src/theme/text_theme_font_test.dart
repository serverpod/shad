import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';

TextStyle _fakeGoogleFont({
  TextStyle? textStyle,
  Color? color,
  Color? backgroundColor,
  double? fontSize,
  FontWeight? fontWeight,
  FontStyle? fontStyle,
  double? letterSpacing,
  double? wordSpacing,
  TextBaseline? textBaseline,
  double? height,
  Locale? locale,
  Paint? foreground,
  Paint? background,
  List<ui.Shadow>? shadows,
  List<ui.FontFeature>? fontFeatures,
  TextDecoration? decoration,
  Color? decorationColor,
  TextDecorationStyle? decorationStyle,
  double? decorationThickness,
}) => TextStyle(
  fontFamily:
      'Fake_${(fontWeight ?? FontWeight.w400).value}'
      '${fontStyle == FontStyle.italic ? 'i' : ''}',
);

void main() {
  group('shad bundles no fonts', () {
    test('the default text theme uses the platform font', () {
      final theme = ShadTextTheme();
      expect(theme.family, isNull);
      for (final style in [
        theme.h1Large,
        theme.h1,
        theme.h2,
        theme.h3,
        theme.h4,
        theme.p,
        theme.blockquote,
        theme.table,
        theme.list,
        theme.lead,
        theme.large,
        theme.small,
        theme.muted,
      ]) {
        expect(style.fontFamily, isNull);
      }
    });

    test('the resolved theme names no family either', () {
      final theme = ShadThemeData();
      expect(theme.textTheme.family, isNull);
      expect(theme.textTheme.p.fontFamily, isNull);
    });

    test('a package qualifies only a family the caller named', () {
      expect(ShadTextTheme(package: 'my_fonts').family, isNull);
      expect(
        ShadTextTheme(family: 'Inter', package: 'my_fonts').family,
        'packages/my_fonts/Inter',
      );
      expect(ShadTextTheme(family: 'Inter').p.fontFamily, 'Inter');
    });

    test('input OTP slots use tabular figures, not a monospace family', () {
      final style = ShadThemeData().inputOTPTheme.style!;
      expect(style.fontFamily, isNull);
      expect(style.fontFeatures, contains(const FontFeature.tabularFigures()));
    });
  });

  group('fromGoogleFont', () {
    test('the same builder gives an equal text theme', () {
      expect(
        ShadTextTheme.fromGoogleFont(_fakeGoogleFont),
        ShadTextTheme.fromGoogleFont(_fakeGoogleFont),
      );
    });

    test('the family follows the weight', () {
      final theme = ShadTextTheme.fromGoogleFont(_fakeGoogleFont);
      expect(theme.h1.fontFamily, 'Fake_800');
      expect(
        theme.p.copyWith(fontWeight: FontWeight.w700).fontFamily,
        'Fake_700',
      );
    });

    test('a copy keeps the weight or style it does not change', () {
      final italicBold = ShadBuilderTextStyle(
        const TextStyle(
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.italic,
        ),
        builder: _fakeGoogleFont,
      );
      expect(italicBold.fontFamily, 'Fake_700i');
      expect(
        italicBold.copyWith(fontWeight: FontWeight.w400).fontFamily,
        'Fake_400i',
      );
      expect(
        italicBold.copyWith(fontStyle: FontStyle.normal).fontFamily,
        'Fake_700',
      );
    });
  });
}
