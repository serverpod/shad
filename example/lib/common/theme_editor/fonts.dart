import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shad/shad.dart';

/// A selectable font, mirroring shadcn/ui's `FONT_DEFINITIONS`.
///
/// Every face is resolved through `google_fonts` at runtime: shad bundles no
/// fonts, and neither does this app, which is why the list can be as long as
/// the original's without shipping any font assets.
@immutable
class EditorFont {
  const EditorFont({
    required this.title,
    required this.family,
    this.category = FontCategory.sans,
  });

  /// The display name, and the Google Fonts family name.
  final String title;

  /// The Google Fonts family name, as `GoogleFonts.getFont` takes it.
  final String family;

  final FontCategory category;

  /// One builder and one text theme per family.
  ///
  /// `ShadTextTheme` compares `googleFontBuilder` by closure identity, and two
  /// closure literals are never `==`. Minting a fresh one per access made
  /// `ShadThemeData` unequal to itself, which restarts `ShadAnimatedTheme`'s
  /// 200 ms lerp across ~54 component themes on every rebuild and drags every
  /// `ShadTheme.of` dependent along with it — the equality invariant CLAUDE.md
  /// calls load-bearing. Keyed by family, since `EditorFont` is const.
  static final _builders = <String, ShadFontBuilder>{};
  static final _textThemes = <String, ShadTextTheme>{};

  /// Wraps `GoogleFonts.getFont` into the all-named shape `ShadFontBuilder`
  /// expects.
  ///
  /// `getFont` takes the family positionally, so it cannot be passed directly.
  ShadFontBuilder get builder => _builders[family] ??=
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
  ShadTextTheme textTheme() =>
      _textThemes[family] ??= ShadTextTheme.fromGoogleFont(builder);

  /// The regular face, for showing the font's own name in a picker.
  ///
  /// Building a `Text` with it is what makes `google_fonts` fetch the face, so
  /// a picker list loads only the rows it renders.
  TextStyle previewStyle() => _previews[family] ??= GoogleFonts.getFont(family);
  static final _previews = <String, TextStyle>{};

  /// The weights the text roles use. Fetching them up front means switching
  /// fonts reflows the text once, not once per weight as each arrives.
  static const _weights = [
    FontWeight.w400,
    FontWeight.w500,
    FontWeight.w600,
    FontWeight.w700,
    FontWeight.w800,
  ];

  /// Fetches this font's faces and completes once they are registered.
  ///
  /// Completes normally when fetching fails or is disabled (offline, tests):
  /// the text then renders in the fallback face, which is the best there is.
  Future<void> load({Duration timeout = const Duration(seconds: 5)}) async {
    try {
      for (final weight in _weights) {
        GoogleFonts.getFont(family, fontWeight: weight);
      }
      await GoogleFonts.pendingFonts().timeout(timeout);
    } on Object {
      // Offline, blocked or runtime fetching disabled: keep the fallback.
    }
  }

  /// shadcn/ui's font list, in its order.
  static const all = <EditorFont>[
    EditorFont(title: 'Inter', family: 'Inter'),
    EditorFont(title: 'Geist', family: 'Geist'),
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
      family: 'Geist Mono',
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
