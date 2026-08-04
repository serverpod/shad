import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// A selectable font, mirroring shadcn/ui's `FONT_DEFINITIONS`.
///
/// Everything except the two bundled Geist faces is resolved through
/// `google_fonts` at runtime, which is why the list can be as long as the
/// original's without shipping any font assets.
@immutable
class EditorFont {
  const EditorFont({
    required this.title,
    required this.family,
    this.bundled = false,
    this.category = FontCategory.sans,
  });

  /// The display name, and the Google Fonts family name.
  final String title;

  /// The family as Flutter knows it. For bundled fonts this is the asset
  /// family; for Google fonts it doubles as the lookup key.
  final String family;

  /// Whether the font ships with the package rather than coming from Google.
  final bool bundled;

  final FontCategory category;

  /// Wraps `GoogleFonts.getFont` into the all-named shape `GoogleFontBuilder`
  /// expects.
  ///
  /// `getFont` takes the family positionally, so it cannot be passed directly.
  GoogleFontBuilder get builder =>
      ({
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
      }) => GoogleFonts.getFont(
        family,
        textStyle: textStyle,
        color: color,
        backgroundColor: backgroundColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        textBaseline: textBaseline,
        height: height,
        locale: locale,
        foreground: foreground,
        background: background,
        shadows: shadows,
        fontFeatures: fontFeatures,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        decorationThickness: decorationThickness,
      );

  /// Builds the text theme for this font.
  ShadTextTheme textTheme() {
    if (bundled) {
      return ShadTextTheme(family: family, package: 'shadcn_ui');
    }
    return ShadTextTheme.fromGoogleFont(builder);
  }

  /// shadcn/ui's font list, in its order. The two Geist faces are the ones
  /// this package bundles; the rest come from Google Fonts.
  static const all = <EditorFont>[
    EditorFont(title: 'Geist', family: 'Geist', bundled: true),
    EditorFont(title: 'Inter', family: 'Inter'),
    EditorFont(title: 'Noto Sans', family: 'Noto Sans'),
    EditorFont(title: 'Nunito Sans', family: 'Nunito Sans'),
    EditorFont(title: 'Figtree', family: 'Figtree'),
    EditorFont(title: 'Roboto', family: 'Roboto'),
    EditorFont(title: 'Raleway', family: 'Raleway'),
    EditorFont(title: 'DM Sans', family: 'DM Sans'),
    EditorFont(title: 'Public Sans', family: 'Public Sans'),
    EditorFont(title: 'Outfit', family: 'Outfit'),
    EditorFont(title: 'Oxanium', family: 'Oxanium'),
    EditorFont(title: 'Manrope', family: 'Manrope'),
    EditorFont(title: 'Space Grotesk', family: 'Space Grotesk'),
    EditorFont(title: 'Montserrat', family: 'Montserrat'),
    EditorFont(title: 'IBM Plex Sans', family: 'IBM Plex Sans'),
    EditorFont(title: 'Source Sans 3', family: 'Source Sans 3'),
    EditorFont(title: 'Instrument Sans', family: 'Instrument Sans'),
    EditorFont(
      title: 'JetBrains Mono',
      family: 'JetBrains Mono',
      category: FontCategory.mono,
    ),
    EditorFont(
      title: 'Geist Mono',
      family: 'GeistMono',
      bundled: true,
      category: FontCategory.mono,
    ),
    EditorFont(
      title: 'Noto Serif',
      family: 'Noto Serif',
      category: FontCategory.serif,
    ),
    EditorFont(
      title: 'Roboto Slab',
      family: 'Roboto Slab',
      category: FontCategory.serif,
    ),
    EditorFont(
      title: 'Merriweather',
      family: 'Merriweather',
      category: FontCategory.serif,
    ),
    EditorFont(
      title: 'Lora',
      family: 'Lora',
      category: FontCategory.serif,
    ),
    EditorFont(
      title: 'Playfair Display',
      family: 'Playfair Display',
      category: FontCategory.serif,
    ),
    EditorFont(
      title: 'EB Garamond',
      family: 'EB Garamond',
      category: FontCategory.serif,
    ),
    EditorFont(
      title: 'Instrument Serif',
      family: 'Instrument Serif',
      category: FontCategory.serif,
    ),
  ];

  static EditorFont byTitle(String title) =>
      all.firstWhere((f) => f.title == title, orElse: () => all.first);

  @override
  bool operator ==(Object other) => other is EditorFont && other.title == title;

  @override
  int get hashCode => title.hashCode;
}

enum FontCategory { sans, serif, mono }
